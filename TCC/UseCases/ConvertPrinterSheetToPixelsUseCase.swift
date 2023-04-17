protocol ConvertPrinterSheetToPixelsUseCase {
    func execute(_ printerSheet: PrinterSheetProtocol) -> PrinterSheetProtocol
}

final class ConvertPrinterSheetToPixels: ConvertPrinterSheetToPixelsUseCase {
    
    let convertPixelsUseCase: ConvertPixelsByMMUseCase
    
    init(convertPixelsUseCase: ConvertPixelsByMMUseCase = ConvertPixelsByMM()) {
        self.convertPixelsUseCase = convertPixelsUseCase
    }
    
    func execute(_ printerSheet: PrinterSheetProtocol) -> PrinterSheetProtocol {
        let resolution = printerSheet.resolutionInDpi
        
        return PrinterSheet(
            widthInMM: Double(convertPixelsUseCase.execute(
                mm: printerSheet.widthInMM,
                dpi: resolution
            )),
            heightInMM: Double(convertPixelsUseCase.execute(
                mm: printerSheet.heightInMM,
                dpi: resolution
            )),
            resolutionInDpi: resolution,
            leftMargin: Double(convertPixelsUseCase.execute(
                mm: printerSheet.leftMargin,
                dpi: resolution
            )),
            rightMargin: Double(convertPixelsUseCase.execute(
                mm: printerSheet.rightMargin,
                dpi: resolution
            )),
            topMargin: Double(convertPixelsUseCase.execute(
                mm: printerSheet.topMargin,
                dpi: resolution
            )),
            bottomMargin: Double(convertPixelsUseCase.execute(
                mm: printerSheet.bottomMargin,
                dpi: resolution
            ))
        )
    }
}
