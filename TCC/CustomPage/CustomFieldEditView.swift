import Cartography
import Foundation
import UIKit

final class CustomFieldEditView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let customValue: UITextField = {
       let textView = UITextField()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Helvetica", size: 14)
        textView.tintColor = .black
        textView.textColor = .black
        textView.leftViewMode = .never
        textView.textAlignment = .center

        return textView
    }()
    
    convenience init(label: String, custonValue: String) {
        self.init(frame: UIScreen.main.bounds)
        
        setup(labelText: label, custonValueText: custonValue)
        constrainViews()
    }
    
    convenience init(label: String) {
        self.init(frame: UIScreen.main.bounds)
        
        setup(labelText: label)
        constrainViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func setup(labelText: String, custonValueText: String) {
        addSubview(label)
        addSubview(customValue)
        
        label.text = labelText
        customValue.text = custonValueText
    }
    
    private func setup(labelText: String) {
        addSubview(label)
        addSubview(customValue)
        
        label.text = labelText
    }
    
    private func constrainViews() {
        constrain(self, label, customValue) { superview, label, value in
            label.top == superview.top + 8
            label.bottom == superview.bottom - 8
            
            label.leading == superview.leading + 8
            label.trailing == value.leading - 30
            
            value.top == superview.top + 8
            value.bottom == superview.bottom - 8
            value.trailing == superview.trailing - 8
            value.height == 30
            value.width == 50
        }
    }
    
    func configure(labelText: String, custonValueText: String) {
        label.text = labelText
        customValue.text = custonValueText
    }
    
    func getPropertyValue() -> String {
        customValue.text ?? ""
    }
}
