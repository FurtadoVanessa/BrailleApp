import Foundation
import UIKit

class BrailleViewController: UIViewController {
    typealias CustomView = BrailleView
    
    private var customView: (UIView & BrailleViewProtocol)
    private let viewModel: BrailleViewModel
    private var router: BrailleRoutingLogic
    
    init(
        customView: (UIView & BrailleViewProtocol),
        viewModel: BrailleViewModel,
        router: BrailleRoutingLogic
    ) {
        self.customView = customView
        self.viewModel = viewModel
        self.router = router

        super.init(nibName: nil, bundle: nil)
        
        self.customView.delegate = self
        self.router.view = self
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override public func loadView() {
        isModalInPresentation = false
        view = customView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIView.setViewTitleForNavigation("TRANSCREVER TRECHO")
        navigationController?.setNavigationBarHidden(false, animated: false)
        edgesForExtendedLayout = .top
    }
}

extension UIView {
    static func setViewTitleForNavigation(_ title: String) -> UIView {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 2
        titleLabel.text = title
        titleLabel.tintColor = .black
        titleLabel.sizeToFit()

        return titleLabel
    }
}

extension BrailleViewController: BrailleViewDelegate {
    func didTapCreationButton(with text: String) {
        router.routeToCreationMode(using: text)
    }
    
    func didTapSearchButton(with text: String) {
        let image = viewModel.createBrailleImage(using: text)
        
        customView.updateImageView(with: image)
    }
    
    func didTapHistoryButton() {
        router.routeToHistory()
    }
    
    func didTapDictionaryButton() {
        router.routeToDictionary()
    }
}

extension BrailleViewController: FillHistorySearchDelegate {
    func fillSearchBar(with text: String) {
        customView.inputHistoryText(text)
    }
}
