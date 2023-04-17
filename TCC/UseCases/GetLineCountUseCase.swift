import Foundation

protocol GetLineCountUseCase {
    func execute(with cell: BrailleCellProtocol, and sheet: PrinterSheetProtocol) -> Int
}

final class GetLineCount: GetLineCountUseCase {
    let pixelConverter: ConvertPixelsByMMUseCase
    
    init(pixelConverter: ConvertPixelsByMMUseCase = ConvertPixelsByMM()) {
        self.pixelConverter = pixelConverter
    }
    
    func execute(with cell: BrailleCellProtocol, and sheet: PrinterSheetProtocol) -> Int {
        let sheetHeight = pixelConverter.execute(mm: sheet.heightInMM, dpi: sheet.resolutionInDpi)
        let topMargin = pixelConverter.execute(mm: sheet.topMargin, dpi: sheet.resolutionInDpi)
        let bottomMargin = pixelConverter.execute(mm: sheet.bottomMargin, dpi: sheet.resolutionInDpi)
        
        let usefulHeightInPixels = sheetHeight - topMargin - bottomMargin
        
        let spaceBetweenLinesInPixels = pixelConverter.execute(mm: Double(cell.spaceBetweenLines), dpi: sheet.resolutionInDpi)
        
        return Int(usefulHeightInPixels / spaceBetweenLinesInPixels)
    }
}
