import Foundation

protocol GetLineSizeUseCase {
    func execute(with cell: BrailleCellProtocol, and sheet: PrinterSheetProtocol) -> Int
}

final class GetLineSize: GetLineSizeUseCase {
    let pixelConverter: ConvertPixelsByMMUseCase
    
    init(pixelConverter: ConvertPixelsByMMUseCase = ConvertPixelsByMM()) {
        self.pixelConverter = pixelConverter
    }
    
    func execute(with cell: BrailleCellProtocol, and sheet: PrinterSheetProtocol) -> Int {
        let sheetWidth = pixelConverter.execute(mm: sheet.widthInMM, dpi: sheet.resolutionInDpi)
        let leftMargin = pixelConverter.execute(mm: sheet.leftMargin, dpi: sheet.resolutionInDpi)
        let rightMargin = pixelConverter.execute(mm: sheet.rightMargin, dpi: sheet.resolutionInDpi)
        
        let usefulWidthInPixels = sheetWidth - leftMargin - rightMargin
        
        let dotDiameterInPixels = pixelConverter.execute(mm: Double(cell.dotDiameter), dpi: sheet.resolutionInDpi)
        let spaceBetweenCellsInPixels = pixelConverter.execute(mm: Double(cell.spaceBetweenCells), dpi: sheet.resolutionInDpi)
        
        let cellWidth = dotDiameterInPixels + spaceBetweenCellsInPixels
        // usando espaco entre celas como mostrado nos desenhos do google images
        
        return Int(usefulWidthInPixels / cellWidth)
    }
}
