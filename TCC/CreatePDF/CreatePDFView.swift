import Cartography
import Foundation
import UIKit

protocol CreatePDFViewDelegate: AnyObject {
    func didTapCreatePDF(with text: String, naming name: String)
}

protocol CreatePDFViewProtocol {
    var delegate: CreatePDFViewDelegate? { get set }
}

final class CreatePDFView: UIView, CreatePDFViewProtocol {
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.isDirectionalLockEnabled = true
        scroll.contentSize = CGSize(width: scroll.contentSize.width, height: scroll.frame.size.height)
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome do arquivo"
        label.textColor = .black
        label.font = UIFont(name: "Helvetica", size: 18)
        
        return label
    }()
    
    private let inputNameBar: UITextField = {
       let textView = UITextField()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Helvetica", size: 14)
        textView.placeholder = "Digite o nome que deseja pro PDF"
        textView.tintColor = .black
        textView.textColor = .black
        textView.leftViewMode = .always
        
        let searchIcon = UIImage(systemName: "square.and.pencil")!
        
        let imageView = UIImageView(image: searchIcon)
        imageView.contentMode = .center
        imageView.tintColor = .black
        
        textView.leftView = imageView
        
        textView.addTarget(self, action: #selector(editingChanged), for: .allEditingEvents)
        return textView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Conteúdo a ser transcrito"
        label.textColor = .black
        label.font = UIFont(name: "Helvetica", size: 18)
        
        return label
    }()
    
//    private let searchStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.alignment = .top
//        stack.axis = .horizontal
//        stack.spacing = 12
//        return stack
//    }()
    
    private let searchBar: UITextView = {
       let textView = UITextView()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Helvetica", size: 14)
        textView.tintColor = .black
        textView.textColor = .black
        textView.isEditable = true
        textView.isScrollEnabled = true

        return textView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 234/255, green: 176/255, blue: 176/255, alpha: 1)
        button.setTitle("Gerar PDF", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = true
        button.alpha = 1.0
        
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CreatePDFViewDelegate?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        setup()
        constrainViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func setup() {
//        searchStackView.addArrangedSubview(searchBar)
//        searchStackView.addArrangedSubview(searchButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(inputNameBar)
        contentView.addSubview(contentLabel)
        contentView.addSubview(searchBar)

        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
        addSubview(searchButton)
    }
    
    private func constrainViews() {
        constrain(self, scrollView, searchButton) { superview, scroll, searchButton in
            scroll.top == superview.top + 12
            scroll.leading == superview.leading + 12
            scroll.trailing == superview.trailing - 12
            
            searchButton.top == scroll.bottom + 12
            searchButton.leading == superview.leading + 12
            searchButton.trailing == superview.trailing - 12
            searchButton.bottom == superview.bottom - 12
        }
        
        constrain(scrollView, contentView) { superview, content in
            content.edges == superview.edges
            content.center == superview.center
        }
        
        constrain(contentView, titleLabel, inputNameBar, contentLabel, searchBar) { superview, titleLabel, title, contentLabel, content in
            titleLabel.top == superview.top + 24
            titleLabel.leading == superview.leading
            titleLabel.trailing == superview.trailing
            
            title.top == titleLabel.bottom + 12
            title.leading == superview.leading
            title.trailing == superview.trailing
            title.height == 30
            
            contentLabel.top == title.bottom + 20
            contentLabel.leading == superview.leading
            contentLabel.trailing == superview.trailing
            
            content.top == contentLabel.bottom + 12
            content.leading == superview.leading
            content.trailing == superview.trailing
            content.bottom == superview.bottom

        }
        
//        constrain(searchStackView, searchBar, searchButton) { stack, bar, button in
//            bar.leading == stack.leading + 12
//            bar.trailing == button.leading - 12
//            button.trailing == stack.trailing - 12
//
//            bar.height >= 300
//            button.width >= 50
//        }
    }
    
    @objc private func didTapSearchButton() {
        delegate?.didTapCreatePDF(with: searchBar.text ?? "", naming: inputNameBar.text ?? "Converted-Braille")
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            searchButton.isEnabled = false
            searchButton.alpha = 0.5
        } else {
            searchButton.isEnabled = true
            searchButton.alpha = 1.0
        }
    }
}
