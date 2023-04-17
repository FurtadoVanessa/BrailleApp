protocol PrinterSheetProtocol: Codable {
    var widthInMM: Double { get set }
    var heightInMM: Double { get set }
    var resolutionInDpi: Int { get set }
    var leftMargin: Double { get set }
    var rightMargin: Double { get set }
    var topMargin: Double { get set }
    var bottomMargin: Double { get set }
    
    mutating func resetMargins(for dotSize: Double)
}

struct PrinterSheet: PrinterSheetProtocol {
    var widthInMM: Double
    var heightInMM: Double
    var resolutionInDpi: Int
    var leftMargin: Double
    var rightMargin: Double
    var topMargin: Double
    var bottomMargin: Double
    
    mutating func resetMargins(for dotSize: Double) {
        leftMargin = dotSize
        topMargin = topMargin/5 + dotSize
    }
}

struct DefaultPrinterSheet: PrinterSheetProtocol {
    var widthInMM: Double
    var heightInMM: Double
    var resolutionInDpi: Int
    var leftMargin: Double
    var rightMargin: Double
    var topMargin: Double
    var bottomMargin: Double
    
    init() {
        self.widthInMM = 210
        self.heightInMM = 297
        self.resolutionInDpi = 300
        self.leftMargin = 15
        self.rightMargin = 10
        self.topMargin = 15
        self.bottomMargin = 10
    }
    
    mutating func resetMargins(for dotSize: Double) {
        leftMargin = dotSize
        topMargin = dotSize
    }
}
