import Foundation
import UIKit

protocol HistoryRoutingLogic {
    func routeToBraille(with text: String)
}

final class HistoryRouter: HistoryRoutingLogic {
    
    weak var view: UIViewController?
    
    func routeToBraille(with text: String) {
        view?.navigationController?.popViewController(animated: true)
    }
}
