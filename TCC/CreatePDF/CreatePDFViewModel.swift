import Foundation
import UIKit

protocol CreatePDFViewModelProtocol {
    func createBrailleImage(using text: String) -> [UIImage]
}

final class CreatePDFViewModel: CreatePDFViewModelProtocol {
    let createBraillePagesUseCase: CreateBraillePagesUseCase
    
    init(
        createBraillePagesUseCase: CreateBraillePagesUseCase
    ) {
        self.createBraillePagesUseCase = createBraillePagesUseCase
    }
    
    func createBrailleImage(using text: String) -> [UIImage] {
        createBraillePagesUseCase.execute(for: text, isPdfCreation: true)
    }
}
