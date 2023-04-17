import Cartography
import Foundation
import UIKit

final class DictionaryView: UIView {
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(DictionaryCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        return tableView
    }()
    
    var keys: [String] = []
    
    var displayedCells: Dictionary?
    
    convenience init(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate) {
        self.init(frame: UIScreen.main.bounds)

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    func setupDelegatesAndDataSources(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate) {
        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
    }

    private func setup() {
        addSubview(tableView)
        
        constrain(self, tableView) { superview, tableView in
            tableView.top == superview.top + 10
            tableView.leading == superview.leading
            tableView.trailing == superview.trailing
            tableView.bottom == superview.bottom
        }
    }
}
