import Cartography
import Foundation
import UIKit

final class DictionaryCell: UITableViewCell {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    private lazy var cellImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
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
        stackView.addArrangedSubview(cellImageView)
        stackView.addArrangedSubview(messageLabel)
        
        addSubview(stackView)
        
        constrain(stackView, self) { stack, superview in
            stack.edges == superview.edges
        }
    }
    
    func configure(with text: String, and image: UIImage) {
        if text == " " {
            messageLabel.text = "Espaço"
        } else if text == "CAPS" {
            messageLabel.text = "Maíusculo"
        } else if text == "NUM" {
            messageLabel.text = "Número"
        } else {
            messageLabel.text = text
        }
        cellImageView.image = image
    }
}
