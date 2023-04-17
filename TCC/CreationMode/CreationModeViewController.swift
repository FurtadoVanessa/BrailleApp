import Foundation
import UIKit

final class CreationModeViewController: UIViewController {
    
    let customView: (UIView & CreationModeViewProtocol)
    let viewModel: CreationModeViewModelProtocol
    
    init(
        customView: (UIView & CreationModeViewProtocol),
        viewModel: CreationModeViewModelProtocol
    ) {
        self.customView = customView
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override public func loadView() {
        isModalInPresentation = false
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.setupFurtherRight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        
        navigationItem.titleView = UIView.setViewTitleForNavigation("CRIAR FOLHA BRAILLE")
        navigationController?.setNavigationBarHidden(false, animated: false)
        edgesForExtendedLayout = .top
        
        let image = viewModel.createBrailleImage()
        customView.updateImageView(with: image.withHorizontallyFlippedOrientation())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
