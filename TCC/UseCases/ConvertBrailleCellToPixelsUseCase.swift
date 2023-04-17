protocol ConvertBrailleCellToPixelsUseCase {
    func execute(_ cell: BrailleCellProtocol, with resolution: Int) -> BrailleCellProtocol
}

final class ConvertBrailleCellToPixels: ConvertBrailleCellToPixelsUseCase {
    let convertPixelsUseCase: ConvertPixelsByMMUseCase
    
    init(convertPixelsUseCase: ConvertPixelsByMMUseCase = ConvertPixelsByMM()) {
        self.convertPixelsUseCase = convertPixelsUseCase
    }
    
    func execute(_ brailleCell: BrailleCellProtocol, with resolution: Int) -> BrailleCellProtocol {
        BrailleCell(
            dotDiameter: Double(convertPixelsUseCase.execute(
                mm: brailleCell.dotDiameter,
                dpi: resolution
            )),
            spaceBetweenDots: Double(convertPixelsUseCase.execute(
                mm: brailleCell.spaceBetweenDots,
                dpi: resolution
            )),
            spaceBetweenCells: Double(convertPixelsUseCase.execute(
                mm: brailleCell.spaceBetweenCells,
                dpi: resolution
            )),
            spaceBetweenLines: Double(convertPixelsUseCase.execute(
                mm: brailleCell.spaceBetweenLines,
                dpi: resolution
            ))
        )
    }
}
