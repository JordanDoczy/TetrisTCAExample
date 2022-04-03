import SwiftUI

@main
struct TetrisExampleApp: App {

    enum Design {
        static let columns = 10
        static let rows = 20
    }

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                GridView(screenWidth: geometry.size.width,
                         store: .init(initialState: try! .init(grid: grid),
                                      reducer: gridReducer,
                                      environment: .init(mainQueue: .main)
                                     ),
                         columns: Design.columns
                )
            }
        }
    }
}

extension TetrisExampleApp {
    var grid: [[BlockType]] {
        var grid = [[BlockType]]()
        (1...Design.rows).forEach { _ in
            var row = [BlockType]()
            (1...Design.columns).forEach { _ in
                row.append(.empty())
            }
            grid.append(row)
        }

        grid[19] = [.block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .empty()
        ]

        grid[18] = [.block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .empty(),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .empty()
        ]

        grid[17] = [.block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .empty()
        ]

        grid[16] = [.block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .empty(),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .block(.block(.red)),
                    .empty()
        ]

        grid[15] = [.block(.block(.blue)),
                    .empty(),
                    .empty(),
                    .block(.block(.blue)),
                    .empty(),
                    .block(.block(.blue)),
                    .block(.block(.blue)),
                    .block(.block(.blue)),
                    .block(.block(.blue)),
                    .empty()
        ]

        grid[14] = [.block(.block(.blue)),
                    .block(.block(.blue)),
                    .empty(),
                    .block(.block(.blue)),
                    .block(.block(.blue)),
                    .block(.block(.blue)),
                    .empty(),
                    .block(.block(.blue)),
                    .empty(),
                    .empty(),
        ]

        grid[13] = [.empty(),
                    .block(.block(.blue)),
                    .empty(),
                    .block(.block(.blue)),
                    .empty(),
                    .block(.block(.blue)),
                    .empty(),
                    .block(.block(.blue)),
                    .empty(),
                    .empty(),
        ]


        return grid
    }
}
