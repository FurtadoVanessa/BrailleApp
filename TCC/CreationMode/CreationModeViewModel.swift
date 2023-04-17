import Foundation
import UIKit

protocol CreationModeViewModelProtocol {
    func createBrailleImage() -> UIImage
}

final class CreationModeViewModel: CreationModeViewModelProtocol {
    
    let dataStore: CreationModeDataStoreProtocol
    let createBraillePagesUseCase: CreateBraillePagesUseCase
    
    init(
        createBraillePagesUseCase: CreateBraillePagesUseCase,
        dataStore: CreationModeDataStoreProtocol
    ) {
//        let localAlphabet = LocalAlphabetService()
//        let wordConverterUseCase = ConvertWord(alphabet: localAlphabet)
//        let convertPixelsUseCase = ConvertPixelByMM()
//
//        let brailleCell = BrailleCell(
//            dotDiameter: 1.2,
//            spaceBetweenDots: 2.5,
//            spaceBetweenCells: 6,
//            spaceBetweenLines: 10
//        )
//        let printerSheet = PrinterSheet(widthInMM: 210, heightInMM: 297, resolutionInDpi: 300, leftMargin: 15, rightMargin: 10, topMargin: 15, bottomMargin: 10)
        
        self.createBraillePagesUseCase = createBraillePagesUseCase
        self.dataStore = dataStore
    }
    
    func createBrailleImage() -> UIImage {
        createBraillePagesUseCase.execute(for: dataStore.text, isPdfCreation: false).first ?? UIImage()
    }
}
