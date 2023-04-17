import Foundation
import UIKit

protocol HistoryConfiguratorProtocol {
    func resolve() -> UIViewController
}

final class HistoryConfigurator: HistoryConfiguratorProtocol {
    func resolve() -> UIViewController {
        let view = HistoryView()
        
        let repository = UserSearchHistoryRepository()
        
        let viewModel = HistoryViewModel(historyRepository: repository)
        
        let router = HistoryRouter()
        
        let viewController = HistoryViewController(customView: view, viewModel: viewModel, router: router)
        
        router.view = viewController
        
        view.setupDelegatesAndDataSources(dataSourceDelegate: viewController)

        return viewController
    }
}
