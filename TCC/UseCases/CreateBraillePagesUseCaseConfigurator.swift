import Foundation

protocol CreateBraillePagesUseCaseConfiguratorProtocol {
    func resolve() -> CreateBraillePagesUseCase
}

final class CreateBraillePagesUseCaseConfigurator: CreateBraillePagesUseCaseConfiguratorProtocol {
    
    func resolve() -> CreateBraillePagesUseCase {
        
        let braillePageConfiguration = BraillePageConfiguration.shared
        
        let alphabet = braillePageConfiguration.getAlphabet()
        let brailleCell = braillePageConfiguration.getBrailleCellConfiguration()
        let printerSheet = braillePageConfiguration.getPrinterSheetConfiguration()
        
        let convertBrailleCellToPixelsUseCase = ConvertBrailleCellToPixels()
        let convertPrintSheetToPixelsUseCase = ConvertPrinterSheetToPixels()
        
        let convertedBrailleCell = convertBrailleCellToPixelsUseCase.execute(brailleCell, with: printerSheet.resolutionInDpi)
        let convertedPrinterSheet = convertPrintSheetToPixelsUseCase.execute(printerSheet)
        
        let convertWordUseCase = ConvertWord(alphabet: alphabet)
        
        let getLineSizeUseCase = GetLineSize()
        
        let getBrailleLinesDataStore = GetBrailleLinesDataStore(
            brailleCell: convertedBrailleCell,
            printerSheet: convertedPrinterSheet
        )
        
        let getBrailleLinesUseCase = GetBrailleLines(
            convertWordUseCase: convertWordUseCase,
            getLineSizeUseCase: getLineSizeUseCase,
            dataStore: getBrailleLinesDataStore
        )
        
        let getLineCountUseCase = GetLineCount()
        
        let getBrailleSheetsDataStore = GetBrailleSheetsDataStore(
            brailleCell: convertedBrailleCell,
            printerSheet: convertedPrinterSheet
        )
        
        let getBrailleSheetsUseCase = GetBrailleSheets(
            getBrailleLinesUseCase: getBrailleLinesUseCase,
            getLineCountUseCase: getLineCountUseCase,
            dataStore: getBrailleSheetsDataStore
        )

        
        let createBrailleSheetDataStore = CreateBrailleSheetDataStore(
            brailleCell: convertedBrailleCell,
            printerSheet: convertedPrinterSheet
        )
        
        let createBrailleSheetUseCase = CreateBrailleSheet(
            dataStore: createBrailleSheetDataStore
        )
        
        return CreateBraillePages(
            getBrailleSheetsUseCase: getBrailleSheetsUseCase,
            createBrailleSheetUseCase: createBrailleSheetUseCase
        )
    }
}
