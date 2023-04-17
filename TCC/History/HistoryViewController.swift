import Foundation
import UIKit

protocol FillHistorySearchDelegate: AnyObject {
    func fillSearchBar(with text: String)
}

final class HistoryViewController: UIViewController {
    
    var customView: HistoryViewProtocol
    let viewModel: HistoryViewModelProtocol
    let router: HistoryRoutingLogic
    
    weak var delegate: FillHistorySearchDelegate?
    var selectedItem: String?
    
    init(
        customView: HistoryViewProtocol,
        viewModel: HistoryViewModelProtocol,
        router: HistoryRoutingLogic
    ) {
        self.customView = customView
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        isModalInPresentation = false
        view = HistoryView(dataSourceDelegate: self)
    }
    
    override func viewDidLoad() {
        let historyList = viewModel.getHistoryList()
        customView.displayedCells = historyList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIView.setViewTitleForNavigation("HISTÓRICO")
        navigationController?.setNavigationBarHidden(false, animated: false)
        edgesForExtendedLayout = .top
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            delegate?.fillSearchBar(with: selectedItem ?? "")
        }
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customView.displayedCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellValue = customView.displayedCells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = customView.displayedCells[indexPath.row]
        selectedItem = value
        router.routeToBraille(with: value)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

        let value = customView.displayedCells[indexPath.row]
        viewModel.clearFromHistory(value: value)
        customView.displayedCells.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    }
}
