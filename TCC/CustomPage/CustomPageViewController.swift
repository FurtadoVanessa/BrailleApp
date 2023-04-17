import Foundation
import UIKit

final class CustomPageViewController: UIViewController {
    let viewModel: CustomPageViewModelProtocol
    
    var customView: (UIView & CustomPageViewProtocol)
    
    init(
        customView: (UIView & CustomPageViewProtocol),
        viewModel: CustomPageViewModelProtocol
    ) {
        self.customView = customView
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
        self.customView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override public func loadView() {
        isModalInPresentation = false
        view = customView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIView.setViewTitleForNavigation("CONFIGURAR MEDIDAS")
        navigationController?.setNavigationBarHidden(false, animated: false)
        edgesForExtendedLayout = []
        
        let configuration = viewModel.loadConfiguration()
        customView.configure(using: configuration)
    }
}

extension CustomPageViewController: CustomPageViewDelegate {
    func didTapSaveConfiguration(using config: CustomPageDisplayViewModel) {
        viewModel.saveNewConfiguration(config)
    }
}
