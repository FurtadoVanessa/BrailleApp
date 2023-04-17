import Cartography
import Foundation
import UIKit

protocol HistoryFooterViewDelegate: AnyObject {
    func didTapClearHistory()
}

final class HistoryFooterView: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("Limpar Histórico", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 234/255, green: 176/255, blue: 176/255, alpha: 1)
        button.addTarget(self, action: #selector(didTapClearHistory), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: HistoryFooterViewDelegate?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func setup() {
        addSubview(button)
        
        constrain(self, button) { superview, button in
            button.top == superview.top + 4
            button.leading == superview.leading + 4
            button.trailing == superview.trailing - 4
            button.bottom == superview.bottom - 4
            
            button.height >= 30
        }
    }
    
    @objc private func didTapClearHistory() {
        delegate?.didTapClearHistory()
    }
}
