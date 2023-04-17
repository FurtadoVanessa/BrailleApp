import Foundation
import UIKit

protocol CreatePDFConfiguratorProtocol {
    func resolve() -> UIViewController
}

final class CreatePDFConfigurator: CreatePDFConfiguratorProtocol {
    func resolve() -> UIViewController {
        
        let createBraillePageUseCase = CreateBraillePagesUseCaseConfigurator().resolve()
        
        let viewModel = CreatePDFViewModel(createBraillePagesUseCase: createBraillePageUseCase)
        
        let view = CreatePDFView()
        
        let viewController = CreatePDFViewController(customView: view, viewModel: viewModel)
        
        return viewController
    }
}
