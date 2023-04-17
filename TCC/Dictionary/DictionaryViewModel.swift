import Foundation
import UIKit

protocol DictionaryViewModelProtocol {
    func getDictionary() -> Dictionary
}

final class DictionaryViewModel: DictionaryViewModelProtocol {
    private let dictionaryRepository: AlphabetServiceProtocol
    private let createBrailleSheetUseCase: CreateBrailleSheetUseCase
    
    init(
        dictionaryRepository: AlphabetServiceProtocol,
        createBrailleSheetUseCase: CreateBrailleSheetUseCase
    ) {
        self.dictionaryRepository = dictionaryRepository
        self.createBrailleSheetUseCase = createBrailleSheetUseCase
    }
    
    func getDictionary() -> Dictionary {
        let alphabet = dictionaryRepository.getAlphabet()
        
        var keys = [String : UIImage]()
        
        for (key, value) in alphabet.letters {
            let image = createBrailleSheetUseCase.execute(for: value)
            keys[key] = image
        }
        
        
        
        return Dictionary(keys: keys)
    }
}
