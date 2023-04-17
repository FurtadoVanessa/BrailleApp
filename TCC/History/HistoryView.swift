import Cartography
import Foundation
import UIKit

protocol HistoryViewProtocol {
    func deleteRows(at indexPath: [IndexPath])
    
    var displayedCells: [String] { get set }
    var tableView: UITableView { get set }
}

final class HistoryView: UIView, HistoryViewProtocol {
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionFooterHeight = 80
        return tableView
    }()
    
    var displayedCells: [String] = []
    
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
    
    func deleteRows(at indexPath: [IndexPath]) {
//        var paths = [IndexPath]()
//        for row in 0 ..< displayedCells.count {
//            let indexPath = IndexPath(row: row, section: 0)
//            paths.append(indexPath)
//        }
//        
        
//        tableView.beginUpdates()
        displayedCells.remove(at: indexPath[0].row)
        tableView.reloadData()
//        tableView.deleteRows(at: indexPath, with: .automatic)
//        tableView.reloadRows(at: indexPath, with: .automatic)
//        tableView.endUpdates()
//        tableView.reloadRows(at: paths, with: .bottom)
//        for item in displayedCells {
//            print("removing item \(item)")
//            displayedCells.removeFirst()
//            tableView.reloadData()
//        }
        
//        displayedCells.removeAll()
//
//        DispatchQueue.main.async {
////            self.tableView.beginUpdates()
//            self.tableView.reloadRows(at: indexPath, with: .automatic)
////            self.tableView.endUpdates()
//        }
        
    }
}
