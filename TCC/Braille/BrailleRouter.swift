import Foundation
import UIKit

protocol BrailleRoutingLogic {
    func routeToCreationMode(using text: String)
    func routeToHistory()
    func routeToDictionary()
    var view: UIViewController? { get set }
}

final class BrailleRouter: BrailleRoutingLogic {
    weak var view: UIViewController?
    
    func routeToCreationMode(using text: String) {
        let creationViewController = CreationModeConfigurator().resolve(using: text)
        
        view?.navigationController?.pushViewController(creationViewController, animated: true)
    }
    
    func routeToHistory() {
        let historyViewController = HistoryConfigurator().resolve() as! HistoryViewController
        historyViewController.delegate = view as? FillHistorySearchDelegate
        
        view?.navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    func routeToDictionary() {
        let dictionaryViewController = DictionaryConfigurator().resolve()
        
        view?.navigationController?.pushViewController(dictionaryViewController, animated: true)
    }
}
