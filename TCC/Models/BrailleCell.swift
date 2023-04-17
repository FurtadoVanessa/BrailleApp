protocol BrailleCellProtocol: Codable {
    var dotDiameter: Double { get set }
    var spaceBetweenDots: Double { get set }
    var spaceBetweenCells: Double { get set }
    var spaceBetweenLines: Double { get set }
}

struct BrailleCell: BrailleCellProtocol {
    var dotDiameter: Double
    var spaceBetweenDots: Double
    var spaceBetweenCells: Double
    var spaceBetweenLines: Double
}

struct DefaultBrailleCell: BrailleCellProtocol {
    var dotDiameter: Double
    var spaceBetweenDots: Double
    var spaceBetweenCells: Double
    var spaceBetweenLines: Double
    
    init() {
        self.dotDiameter = 1.2
        self.spaceBetweenDots = 2.5
        self.spaceBetweenCells = 6
        self.spaceBetweenLines = 10
    }
}
