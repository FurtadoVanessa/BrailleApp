import Cartography
import Foundation
import UIKit

final class HistoryCell: UITableViewCell {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(messageLabel)
        
        constrain(self, messageLabel) { superview, label in
            label.top == superview.top + 4
            label.leading == superview.leading + 4
            label.bottom == superview.bottom - 4
            label.trailing == superview.trailing - 4
        }
    }
    
    func configure(with text: String) {
        messageLabel.text = text
    }
}
