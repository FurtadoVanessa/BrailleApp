import Foundation
import UIKit

final class DictionaryViewController: UIViewController {
    
    var customView: DictionaryView
    let viewModel: DictionaryViewModelProtocol
    
    init(
        customView: DictionaryView,
        viewModel: DictionaryViewModelProtocol
    ) {
        self.customView = customView
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        isModalInPresentation = false
        view = DictionaryView(dataSourceDelegate: self)
    }
    
    override func viewDidLoad() {
        let dictionary = viewModel.getDictionary()
        customView.displayedCells = dictionary
        for letter in dictionary.keys.sorted(by: { $0.key < $1.key } ) {
            customView.keys.append(letter.key)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIView.setViewTitleForNavigation("DICIONÁRIO")
        navigationController?.setNavigationBarHidden(false, animated: false)
        edgesForExtendedLayout = .top
    }
}

extension DictionaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customView.displayedCells?.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = customView.keys[indexPath.row]
        let value = customView.displayedCells?.keys[key] ?? UIImage()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DictionaryCell
        cell.configure(with: key, and: value)
        
        
        return cell
    }
}
