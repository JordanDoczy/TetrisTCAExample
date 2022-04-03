import Combine
import ComposableArchitecture
import SwiftUI

/* NEXT UP
 1. drop after line completion
 2. ghost
  */

struct GridState: Hashable {

    enum GridStateError: Error {
        case unsupportedGrid(String)
    }

    var grid: [[BlockType]]
    var activeShape: Shape?
    var activeCoord: Coordinate?
    var isRunning = false
    var frequency: DispatchQueue.SchedulerTimeType.Stride = 0.5

    var numberOfRows: Int {
        grid.count
    }

    var numberOfColumns: Int {
        grid[0].count
    }

    init(grid: [[BlockType]]) throws {
        let counts = grid.map(\.count)
        guard counts.dropFirst().allSatisfy({ $0 == counts.first }) else {
            throw GridStateError.unsupportedGrid("Columns must be of equivalent length")
        }

        self.grid = grid
    }

    init(rows: Int, columns: Int) {

        var grid = [[BlockType]]()

        (1...rows).forEach { _ in
            var row = [BlockType]()
            (1...columns).forEach { _ in
                row.append(.empty())
            }
            grid.append(row)
        }

        self.grid = grid
    }
}

enum GridAction {
    case addShape
    case appear
    case check
    case doubleTap
    case setTimer(DispatchQueue.SchedulerTimeType.Stride)
    case tap
    case timerTicked
    case tryMoveShape(_: Shape, to: Coordinate, failureCase: Effect<GridAction, Never> = .none)
    case tryRotateShape
    case userDirection(CardinalDirection)
}

struct GridEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let gridReducer = Reducer<GridState, GridAction, GridEnvironment> { state, action, environment in
    struct TimerId: Hashable {}

    switch action {

    case .addShape:
        let shape = Shape.line(.west) //Shape.randomElement()
        let coord = Coordinate(x: (state.numberOfColumns/2 - 1), y: 0) // center
        state.activeShape = shape
        state.activeCoord = coord

        return .init(value: .tryMoveShape(shape, to: coord))

    case .appear:
        return .init(value: .setTimer(state.frequency))

    case .check:
        let completedRowIndexes = (0..<state.numberOfRows).filter {
            state.grid[$0].isFull()
        }

        completedRowIndexes.forEach { rowIndex in
            (0..<rowIndex).reversed().forEach {
                let row = state.grid[$0]
                state.grid.updateRow(at: $0, to: .empty())
                state.grid[$0+1] = row
            }
        }

        print(completedRowIndexes)

        return .init(value: .addShape)

    case .doubleTap:
        if state.isRunning {
            state.isRunning = false
            return .cancel(id: TimerId())
        } else {
            return .init(value: .setTimer(state.frequency))
        }

    case let .setTimer(every):
        state.isRunning = true

        return
            .concatenate(
                .cancel(id: TimerId()),

                Effect.timer(id: TimerId(), every: every, on: environment.mainQueue)
                    .map { _ in .timerTicked }
            )

    case .tap:
        return .init(value: .tryRotateShape)

    case .timerTicked:
        guard let activeShape = state.activeShape,
              let activeCoord = state.activeCoord else {
            return Effect(value: .addShape)
        }

        return .init(value: .tryMoveShape(activeShape,
                                           to: activeCoord.incrementY(),
                                           failureCase: Effect(value: .check)))

    case let .tryMoveShape(shape, toCoord, failureCase):
        guard let activeShape = state.activeShape,
              let activeCoord = state.activeCoord else {
            return .none
        }

        let fromCoords = Set(activeShape.position.map(to: activeCoord))
        let toCoords = Set(shape.position.map(to: toCoord))

        let outOfBoundsCoords = toCoords.map(\.x).filter { $0 >= state.numberOfColumns || $0 < 0 }
        guard outOfBoundsCoords.isEmpty else { return .none }

        let checkCoords = Array(toCoords.subtracting(fromCoords))

        if state.grid.isEmptyAt(coords: checkCoords) {
            state.activeCoord = toCoord
            state.activeShape = shape
            state.grid.set(coords: Array(fromCoords), to: .empty())
            state.grid.set(coords: Array(toCoords), to: .block(.block(shape.color)))
            return .none
        }

        return failureCase

    case .tryRotateShape:
        guard let activeShape = state.activeShape,
              let activeCoord = state.activeCoord else {
            return .none
        }

        return .init(value: .tryMoveShape(activeShape.rotate(), to: activeCoord))

    case let .userDirection(direction):
        guard let activeShape = state.activeShape,
              let activeCoord = state.activeCoord else {
            return .none
        }

        switch direction {
        case .north, .south: return .none
        case .east:
            return .init(value: .tryMoveShape(activeShape, to: activeCoord.incrementX()))
        case .west:
            return .init(value: .tryMoveShape(activeShape, to: activeCoord.decrementX()))
        }
    }
}

struct GridView: View {

    enum Design {
        enum Grid {
            static let horizontalPadding: CGFloat = 50
            static let spacing: CGFloat = 1
            static let color: Color = .gray.opacity(0.3)
        }
    }

    let store: Store<GridState, GridAction>
    let columns: [GridItem]

    @State var lastDragLocation: CGPoint?

    init(screenWidth: CGFloat, store: Store<GridState, GridAction>, columns: Int) {
        let columnWidth: CGFloat = (screenWidth - (Design.Grid.horizontalPadding * 2) ) / CGFloat(columns)
        self.columns = .init(repeating: GridItem(.fixed(columnWidth), spacing: Design.Grid.spacing), count: columns)
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: Design.Grid.spacing) {
                    ForEach(0..<viewStore.numberOfRows) { rowIndex in
                        ForEach(0..<viewStore.numberOfColumns) { colIndex in
                            switch viewStore.grid[rowIndex][colIndex] {
                            case let .block(.block(color)):
                                Rectangle()
                                    .foregroundColor(color)
                                    .aspectRatio(1, contentMode: .fill)

                            case let .empty(.color(color)):
                                Rectangle()
                                    .foregroundColor(color)
                                    .aspectRatio(1, contentMode: .fill)

                            case .empty:
                                Rectangle()
                                    .foregroundColor(Design.Grid.color)
                                    .aspectRatio(1, contentMode: .fill)
                            }
                        }
                    }
                }
                Spacer()
            }
            .background(Color.black)
            .onTapGesture(count: 2) {
                viewStore.send(.doubleTap)
            }
            .onTapGesture(count: 1) {
                viewStore.send(.tap)
            }
            .gesture(
                DragGesture(minimumDistance: 1, coordinateSpace: .global)
                    .onChanged { action in
                        let lastDragLocation = lastDragLocation ?? action.startLocation
                        let direction = lastDragLocation.x > action.location.x ? CardinalDirection.west : .east
                        self.lastDragLocation = action.location

                        viewStore.send(.userDirection(direction))
                    }
            )
            .onAppear {
                viewStore.send(.appear)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView(screenWidth: UIScreen.main.bounds.size.width,
//                 state: (1...200).map { _ in
//            Block(color: [.red, .blue, .green, .orange, .yellow, .purple].randomElement()!)
//        })
//    }
//}

