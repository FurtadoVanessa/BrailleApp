import Foundation
import UIKit

protocol CreateBraillePagesUseCase {
    func execute(for text: String, isPdfCreation: Bool) -> [UIImage]
}

final class CreateBraillePages: CreateBraillePagesUseCase {
    let getBrailleSheetsUseCase: GetBrailleSheetsUseCase
    let createBrailleSheetUseCase: CreateBrailleSheetUseCase
    
    init(
        getBrailleSheetsUseCase: GetBrailleSheetsUseCase,
        createBrailleSheetUseCase: CreateBrailleSheetUseCase
    ) {
        self.getBrailleSheetsUseCase = getBrailleSheetsUseCase
        self.createBrailleSheetUseCase = createBrailleSheetUseCase
    }
    
    func execute(for text: String, isPdfCreation: Bool = true) -> [UIImage] {
        var createdImages: [UIImage] = []
        
        let braillePages = getBrailleSheetsUseCase.execute(for: text)
        
        for page in braillePages {
            let createdSheet = createBrailleSheetUseCase.execute(for: page, isPdfCreation: isPdfCreation)
            createdImages.append(createdSheet)
        }
        return createdImages
    }
}
