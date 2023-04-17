protocol CreateBrailleSheetUseCaseConfiguratorProtocol {
    func resolve() -> CreateBrailleSheetUseCase
}

final class CreateBrailleSheetUseCaseConfigurator: CreateBrailleSheetUseCaseConfiguratorProtocol {
    func resolve() -> CreateBrailleSheetUseCase {
        let braillePageConfiguration = BraillePageConfiguration.shared
        
        let brailleCell = braillePageConfiguration.getBrailleCellConfiguration()
        let printerSheet = braillePageConfiguration.getPrinterSheetConfiguration()
        
        let convertBrailleCellToPixelsUseCase = ConvertBrailleCellToPixels()
        let convertPrintSheetToPixelsUseCase = ConvertPrinterSheetToPixels()
        
        let convertedBrailleCell = convertBrailleCellToPixelsUseCase.execute(brailleCell, with: printerSheet.resolutionInDpi)
        let convertedPrinterSheet = convertPrintSheetToPixelsUseCase.execute(printerSheet)
        
        let createBrailleSheetDataStore = CreateBrailleSheetDataStore(
            brailleCell: convertedBrailleCell,
            printerSheet: convertedPrinterSheet
        )
        
        let createBrailleSheetUseCase = CreateBrailleSheet(
            dataStore: createBrailleSheetDataStore
        )
        
        return createBrailleSheetUseCase
    }
}
