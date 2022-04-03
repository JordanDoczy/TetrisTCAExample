import SwiftUI

enum BlockType: Hashable {
    case block(Block)
    case empty(Empty? = nil)

    enum Block: Hashable {
        case block(Color)
        // case offSetBlock???
    }

    enum Empty: Hashable {
//        case rowCompletion
        case color(Color)
    }
}

enum CardinalDirection {
    case north
    case south
    case east
    case west
}

enum Shape: Hashable {

    enum Colors {
        static let gray = Color.gray.opacity(0.25)
        static let red = Color.red
        static let orange = Color.orange
        static let yellow = Color.yellow
        static let green = Color.green
        static let blue = Color.blue
        static let purple = Color.purple
        static let pink = Color.pink
    }

    case square(CardinalDirection)
    case line(CardinalDirection)
    case s(CardinalDirection)
    case z(CardinalDirection)
    case j(CardinalDirection)
    case l(CardinalDirection)
    case t(CardinalDirection)

    var position: [Coordinate] {
        switch self {
        case let .line(direction):
            switch direction {
            case .north, .south:
                return [.init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 1, y: 3)]
            case .east, .west:
                return [.init(x: 0, y: 0),
                        .init(x: 1, y: 0),
                        .init(x: 2, y: 0),
                        .init(x: 3, y: 0)]
            }

        case .square(_):
            return [.init(x: 0, y: 0),
                    .init(x: 0, y: 1),
                    .init(x: 1, y: 0),
                    .init(x: 1, y: 1)]

        case let .j(direction):
            switch direction {
            case .north:
                return [.init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 0, y: 2)]
            case .south:
                return [.init(x: 1, y: 0),
                        .init(x: 0, y: 0),
                        .init(x: 0, y: 1),
                        .init(x: 0, y: 2)]
            case .east:
                return [.init(x: 0, y: 1),
                        .init(x: 0, y: 2),
                        .init(x: 1, y: 2),
                        .init(x: 2, y: 2)]
            case .west:
                return [.init(x: 0, y: 0),
                        .init(x: 1, y: 0),
                        .init(x: 2, y: 0),
                        .init(x: 2, y: 1)]
            }

        case let .l(direction):
            switch direction {
            case .north:
                return [.init(x: 0, y: 0),
                        .init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2)]
            case .south:
                return [.init(x: 0, y: 0),
                        .init(x: 0, y: 1),
                        .init(x: 0, y: 2),
                        .init(x: 1, y: 2)]
            case .east:
                return [.init(x: 0, y: 2),
                        .init(x: 1, y: 2),
                        .init(x: 2, y: 1),
                        .init(x: 2, y: 2)]
            case .west:
                return [.init(x: 0, y: 0),
                        .init(x: 0, y: 1),
                        .init(x: 1, y: 0),
                        .init(x: 2, y: 0)]
            }

        case let .s(direction):
            switch direction {
            case .north:
                return [.init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 2, y: 1),
                        .init(x: 2, y: 2)]
            case .south:
                return [.init(x: 0, y: 0),
                        .init(x: 0, y: 1),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2)]
            case .east:
                return [.init(x: 0, y: 2),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 2, y: 1)]
            case .west:
                return [.init(x: 2, y: 0),
                        .init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 0, y: 1)]

            }

        case let .z(direction):
            switch direction {
            case .north:
                return [.init(x: 2, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 2, y: 1),
                        .init(x: 1, y: 2)]
            case .south:
                return [.init(x: 0, y: 2),
                        .init(x: 0, y: 1),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 0)]
            case .east:
                return [.init(x: 0, y: 1),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 2, y: 2)]
            case .west:
                return [.init(x: 0, y: 0),
                        .init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 2, y: 1)]
            }

        case let .t(direction):
            switch direction {
            case .north:
                return [.init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 2, y: 1)]
            case .south:
                return [.init(x: 1, y: 0),
                        .init(x: 1, y: 1),
                        .init(x: 1, y: 2),
                        .init(x: 0, y: 1)]
            case .east:
                return [.init(x: 0, y: 1),
                        .init(x: 1, y: 1),
                        .init(x: 2, y: 1),
                        .init(x: 1, y: 2)]
            case .west:
                return [.init(x: 0, y: 1),
                        .init(x: 1, y: 1),
                        .init(x: 2, y: 1),
                        .init(x: 1, y: 0)]
            }
        }
    }

    var color: Color {
        switch self {
        case .line: return Colors.red
        case .square: return Colors.orange
        case .j: return Colors.yellow
        case .l: return Colors.green
        case .s: return Colors.blue
        case .z: return Colors.purple
        case .t: return Colors.pink
        }
    }

    func rotate() -> Self {
        switch self {
        case let .line(direction):
            switch direction {
            case .north, .south: return .line(.west)
            case .west, .east: return .line(.north)
            }
        case .square(_):
            return self
        case let .j(direction):
            switch direction {
            case .west: return .j(.north)
            case .north: return .j(.east)
            case .east: return .j(.south)
            case .south: return .j(.west)
            }
        case let .l(direction):
            switch direction {
            case .west: return .l(.north)
            case .north: return .l(.east)
            case .east: return .l(.south)
            case .south: return .l(.west)
            }
        case let .s(direction):
            switch direction {
            case .west: return .s(.north)
            case .north: return .s(.east)
            case .east: return .s(.south)
            case .south: return .s(.west)
            }
        case let .z(direction):
            switch direction {
            case .west: return .z(.north)
            case .north: return .z(.east)
            case .east: return .z(.south)
            case .south: return .z(.west)
            }
        case let .t(direction):
            switch direction {
            case .west: return .t(.north)
            case .north: return .t(.east)
            case .east: return .t(.south)
            case .south: return .t(.west)
            }
        }
    }

    static func randomElement() -> Self {
        [.line(.west), .square(.west), .j(.west), .l(.west), .s(.west), .z(.west), .t(.west)].randomElement()!
    }

}

struct Coordinate: Hashable {
    var x: Int
    var y: Int

    static let zero: Self = .init(x: 0, y: 0)

    func decrementY(by amount: Int = 1) -> Self {
        return Self(x: x, y: y - amount)
    }

    func incrementY(by amount: Int = 1) -> Self {
        return Self(x: x, y: y + amount)
    }

    func decrementX(by amount: Int = 1) -> Self {
        return Self(x: x - amount, y: y)
    }

    func incrementX(by amount: Int = 1) -> Self {
        return Self(x: x + amount, y: y)
    }

    func map(to global: Self) -> Self {
        Self(x: global.x + x, y: global.y + y)
    }
}
