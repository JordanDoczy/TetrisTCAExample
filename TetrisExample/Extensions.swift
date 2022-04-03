extension Array where Element == [BlockType] {
    mutating func set(coords: [Coordinate], to blockType: BlockType) {
        coords.forEach {
            self[$0.y][$0.x] = blockType
        }
    }

    func isEmptyAt(coord: Coordinate) -> Bool {
        guard coord.y < self.count, coord.x < self[coord.y].count else { return false }
        if case .empty = self[coord.y][coord.x] { return true }
        return false
    }

    func isEmptyAt(coords: [Coordinate]) -> Bool {
        !coords.map(isEmptyAt).contains(false)
    }

    mutating func updateRow(at row: Int, to blockType: BlockType) {
        guard row < count else { return }

        (0..<self[row].count).forEach {
            self[row][$0] = blockType
        }

    }
}

extension Array where Element == BlockType {
    func isFull() -> Bool {
        self.filter {
            if case .block = $0 { return true }
            return false
        }.count == count
    }
}

extension Array where Element == Coordinate {
    func map(to global: Coordinate) -> Self {
        map( { $0.map(to: global) })
    }
}
