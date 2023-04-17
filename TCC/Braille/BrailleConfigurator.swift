import Foundation
import UIKit

protocol BrailleConfiguratorProtocol {
    func resolve() -> UIViewController
}

final class BrailleConfigurator: BrailleConfiguratorProtocol {
    func resolve() -> UIViewController {
        
        let createBraillePagesUseCase = CreateBraillePagesUseCaseConfigurator().resolve()
        
        let view = BrailleView()
        
        let repository = UserSearchHistoryRepository()
        
        let viewModel = BrailleViewModel(createBraillePagesUseCase: createBraillePagesUseCase, userSearchHistoryRespository: repository)

        let router = BrailleRouter()
        
        return BrailleViewController(
            customView: view,
            viewModel: viewModel,
            router: router
        )
    }
}
