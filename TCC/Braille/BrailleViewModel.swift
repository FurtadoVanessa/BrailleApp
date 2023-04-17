import Foundation
import UIKit

final class BrailleViewModel: ObservableObject {
    
    let createBraillePagesUseCase: CreateBraillePagesUseCase
    let userSearchHistoryRespository: UserSearchHistoryRepositoryProtocol
    
    init(
        createBraillePagesUseCase: CreateBraillePagesUseCase,
        userSearchHistoryRespository: UserSearchHistoryRepositoryProtocol
    ) {
        self.createBraillePagesUseCase = createBraillePagesUseCase
        self.userSearchHistoryRespository = userSearchHistoryRespository
    }
    
    func createBrailleImage(using text: String) -> UIImage {
        userSearchHistoryRespository.saveInHistory(text: text)
        return createBraillePagesUseCase.execute(for: text, isPdfCreation: false).first ?? UIImage()
    }
}
