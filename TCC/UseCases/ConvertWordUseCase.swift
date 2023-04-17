import Foundation

protocol ConvertWordUseCase {
    func execute(using word: String) -> BrailleWord
}

final class ConvertWord: ConvertWordUseCase {
    static let capsIdentifier = "CAPS"
    static let numberIdentifier = "NUM"
    
    private let alphabet: AlphabetServiceProtocol
    
    init(alphabet: AlphabetServiceProtocol) {
        self.alphabet = alphabet
    }
    
    func execute(using word: String) -> BrailleWord {
        var transcriptedWord = [[Int]]()
        
        let isWordFullUppercased = isWordFullUppercased(word)
        
        if isWordFullUppercased {
            let uppercaseBrailleIdentifier = alphabet.getLetter(ConvertWord.capsIdentifier)
            transcriptedWord.append(uppercaseBrailleIdentifier)
            transcriptedWord.append(uppercaseBrailleIdentifier)
            // marcador de palavra inteira em braille sao dois sinais simples
        }
        
        for letter in word {
            if letter.isNumber {
                let numberBrailleIdentifier = alphabet.getLetter(ConvertWord.numberIdentifier)
                transcriptedWord.append(numberBrailleIdentifier)
            }
            
            if letter.isUppercase, !isWordFullUppercased {
                let uppercaseBrailleIdentifier = alphabet.getLetter(ConvertWord.capsIdentifier)
                transcriptedWord.append(uppercaseBrailleIdentifier)
            }
            
            let letterBrailleIdentifier = alphabet.getLetter(String(letter.lowercased()))
            transcriptedWord.append(letterBrailleIdentifier)
        }
        
        if isWordFullUppercased {
            let uppercaseBrailleIdentifier = alphabet.getLetter(ConvertWord.capsIdentifier)
            transcriptedWord.append(uppercaseBrailleIdentifier)
            transcriptedWord.append(uppercaseBrailleIdentifier)
            // marcador de palavra inteira em braille sao dois sinais simples
        }
        
        return BrailleWord(letters: transcriptedWord)
    }
    
    private func isWordFullUppercased(_ word: String) -> Bool {
        var isWordFullUppercased = false
        
        for letter in word {
            if letter.isUppercase {
                isWordFullUppercased = true
            } else {
                return false
            }
        }
        
        return isWordFullUppercased
    }
}
