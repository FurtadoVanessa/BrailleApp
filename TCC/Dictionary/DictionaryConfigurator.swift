import UIKit

protocol DictionaryConfiguratorProtocol {
    func resolve() -> UIViewController
}

final class DictionaryConfigurator: DictionaryConfiguratorProtocol {
    
    func resolve() -> UIViewController {
        let brailleConfiguration = BraillePageConfiguration.shared
        
        let createBrailleSheetUseCase = CreateBrailleSheetUseCaseConfigurator().resolve()
        
        let view = DictionaryView()
        let viewModel = DictionaryViewModel(
            dictionaryRepository: brailleConfiguration.getAlphabet(),
            createBrailleSheetUseCase: createBrailleSheetUseCase
        )
        
        let viewController = DictionaryViewController(
            customView: view,
            viewModel: viewModel
        )
        
        return viewController
    }
}
