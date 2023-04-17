import Foundation

protocol GetBrailleSheetsDataStoreProtocol {
    var brailleCell: BrailleCellProtocol { get set }
    var printerSheet: PrinterSheetProtocol { get set }
}

final class GetBrailleSheetsDataStore: GetBrailleSheetsDataStoreProtocol {
    var brailleCell: BrailleCellProtocol
    var printerSheet: PrinterSheetProtocol
    
    init(
        brailleCell: BrailleCellProtocol,
        printerSheet: PrinterSheetProtocol
    ) {
        self.brailleCell = brailleCell
        self.printerSheet = printerSheet
    }
}

protocol GetBrailleSheetsUseCase {
    func execute(for text: String) -> [BrailleSheet]
}

final class GetBrailleSheets: GetBrailleSheetsUseCase {
    let getBrailleLinesUseCase: GetBrailleLinesUseCase
    let getLineCountUseCase: GetLineCountUseCase
    let dataStore: GetBrailleSheetsDataStoreProtocol
    
    init(
        getBrailleLinesUseCase: GetBrailleLinesUseCase,
        getLineCountUseCase: GetLineCountUseCase,
        dataStore: GetBrailleSheetsDataStoreProtocol
    ) {
        self.getBrailleLinesUseCase = getBrailleLinesUseCase
        self.getLineCountUseCase = getLineCountUseCase
        self.dataStore = dataStore
    }
    
    func execute(for text: String) -> [BrailleSheet] {
        let lineCount = getLineCountUseCase.execute(with: dataStore.brailleCell, and: dataStore.printerSheet)
        let brailleLines = getBrailleLinesUseCase.execute(for: text)
        
        var brailleSheets = [BrailleSheet]()
        
        var currentBrailleSheetLines = [BrailleLine]()
        
        for line in brailleLines {
            if currentBrailleSheetLines.count <= lineCount {
                currentBrailleSheetLines.append(line)
            }
            else {
                let newBrailleSheet = BrailleSheet(lines: currentBrailleSheetLines)
                brailleSheets.append(newBrailleSheet)
                
                currentBrailleSheetLines = [BrailleLine]()
                currentBrailleSheetLines.append(line)
            }
        }
        
        if brailleSheets.isEmpty {
            return [BrailleSheet(lines: currentBrailleSheetLines)]
        } else {
            return brailleSheets
        }
    }
}
