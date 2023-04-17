protocol GetBrailleLinesDataStoreProtocol {
    var brailleCell: BrailleCellProtocol { get set }
    var printerSheet: PrinterSheetProtocol { get set }
}

final class GetBrailleLinesDataStore: GetBrailleLinesDataStoreProtocol {
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

protocol GetBrailleLinesUseCase {
    func execute(for text: String) -> [BrailleLine]
}

final class GetBrailleLines: GetBrailleLinesUseCase {
    
    let convertWordUseCase: ConvertWordUseCase
    let getLineSizeUseCase: GetLineSizeUseCase
    let dataStore: GetBrailleLinesDataStoreProtocol
    
    init(
        convertWordUseCase: ConvertWordUseCase,
        getLineSizeUseCase: GetLineSizeUseCase,
        dataStore: GetBrailleLinesDataStoreProtocol
    ) {
        self.convertWordUseCase = convertWordUseCase
        self.getLineSizeUseCase = getLineSizeUseCase
        self.dataStore = dataStore
    }
    
    func execute(for text: String) -> [BrailleLine] {
        let stringWords = text.split(separator: " ")
        
        var brailleWords: [BrailleWord] = [BrailleWord]()
        
        for word in stringWords {
            let convertedWord = convertWordUseCase.execute(using: String(word))
            brailleWords.append(convertedWord)
        }
        
        var wordLines = [BrailleLine]()
        var currentLine = [BrailleWord]()
        
        let lineSize = getLineSizeUseCase.execute(with: dataStore.brailleCell, and: dataStore.printerSheet)
        
        for word in brailleWords {
            if (getLineSum(currentLine) + word.letters.count) <= lineSize {
                currentLine.append(word)
                currentLine.append(addSpaceBrailleCell())
            } else {
                let newBrailleLine = BrailleLine(words: currentLine)
                wordLines.append(newBrailleLine)
                currentLine = [BrailleWord]()
                currentLine.append(word)
                currentLine.append(addSpaceBrailleCell())
            }
        }
        let newBrailleLine = BrailleLine(words: currentLine)
        wordLines.append(newBrailleLine)
        
        return wordLines
    }
    
    private func getLineSum(_ line: [BrailleWord]) -> Int {
        var count = 0
        
        for word in line {
            if word.letters.isEmpty {
                count += 1
            } else {
                count += word.letters.count
            }
        }

        return count
    }
    
    private func addSpaceBrailleCell() -> BrailleWord {
        convertWordUseCase.execute(using: " ")
    }
}
