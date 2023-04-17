import Foundation
import UIKit

protocol CreationModeConfiguratorProtocol {
    func resolve(using text: String) -> UIViewController
}

final class CreationModeConfigurator: CreationModeConfiguratorProtocol {
    
    func resolve(using text: String) -> UIViewController {
        let dataStore = CreationModeDataStore(text: text)
        
        let createBraillePageUseCase = CreateBraillePagesUseCaseConfigurator().resolve()
        
        let viewModel = CreationModeViewModel(createBraillePagesUseCase: createBraillePageUseCase, dataStore: dataStore)
        
        let view = CreationModeView()
        
        let viewController = CreationModeViewController(customView: view, viewModel: viewModel)
        
        return viewController
    }
}
