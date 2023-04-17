import Foundation
import UIKit

protocol CustomPageConfiguratorProtocol {
    func resolve() -> UIViewController
}

final class CustomPageConfigurator: CustomPageConfiguratorProtocol{
    func resolve() -> UIViewController {
        let view = CustomPageView()
        let viewModel = CustomPageViewModel()
        
        let viewController = CustomPageViewController(customView: view, viewModel: viewModel)
        view.delegate = viewController
        
        return viewController
    }
}
