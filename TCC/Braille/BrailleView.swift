import Cartography
import UIKit

protocol BrailleViewProtocol {
    func updateImageView(with image: UIImage)
    func inputHistoryText(_ text: String)
    
    var delegate: BrailleViewDelegate? { get set }
}

protocol BrailleViewDelegate: AnyObject {
    func didTapSearchButton(with text: String)
    func didTapCreationButton(with text: String)
    func didTapHistoryButton()
    func didTapDictionaryButton()
}

final class BrailleView: UIView, BrailleViewProtocol {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 22
        return stack
    }()
    
    private let searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 12
        return stack
    }()
    
    private let searchBar: UITextField = {
       let textView = UITextField()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = UIFont(name: "Helvetica", size: 14)
        textView.placeholder = "Digite um trecho para transcrever"
        textView.tintColor = .black
        textView.textColor = .black
        textView.leftViewMode = .always
        
        let searchIcon = UIImage(systemName: "magnifyingglass")!
        
        let imageView = UIImageView(image: searchIcon)
        imageView.contentMode = .center
        imageView.tintColor = .black
        
        textView.leftView = imageView
        
        textView.addTarget(self, action: #selector(editingChanged), for: .allEditingEvents)
        return textView
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 234/255, green: 176/255, blue: 176/255, alpha: 1)
        button.setTitle("Gerar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = false
        button.alpha = 0.5
        
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    private let optionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let dictionaryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dicionário", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 199/255, green: 215/255, blue: 248/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapDictionaryButton), for: .touchUpInside)
        return button
    }()
    
    private let historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Histórico", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 234/255, green: 176/255, blue: 176/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapHistoryButton), for: .touchUpInside)
        return button
    }()
    
    private let creationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        button.tintColor = .black
        button.setTitle("Modo Criação", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "trapezoid.and.line.vertical"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.frame.size = CGSize(width: 82, height: 34)
        button.imageEdgeInsets.left = 0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapCreationButton), for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 6.0
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.flashScrollIndicators()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.clipsToBounds = false
        return image
    }()
    
    weak var delegate: BrailleViewDelegate?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)

        setupView()
        constrainView()
        constrainSearchBar()
        constrainOptionsView()
        constraintScrollAndImage()
//        searchBar.adoptHeight()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func setupView() {
        searchStackView.addArrangedSubview(searchBar)
        searchStackView.addArrangedSubview(searchButton)
        
        stackView.addArrangedSubview(searchStackView)
        
        optionsStackView.addArrangedSubview(dictionaryButton)
        optionsStackView.addArrangedSubview(historyButton)
        
        stackView.addArrangedSubview(optionsStackView)
        
        stackView.addArrangedSubview(creationButton)

        addSubview(stackView)
        
        scrollView.addSubview(imageView)
        
        
        addSubview(scrollView)
        backgroundColor = .white
        
        scrollView.delegate = self
    }
    
    private func constrainSearchBar() {
        constrain(stackView, searchStackView, searchBar, searchButton) { superview, stack, bar, button in
            stack.leading == superview.leading
            stack.trailing == superview.trailing
            stack.top == superview.top
            
            bar.height == 36
            button.width == 50
//            searchBar.heightConstraint = bar.height == searchBar.minHeight
            
            stack.height == bar.height
        }
    }
    
    private func constrainOptionsView() {
        
        constrain(stackView, optionsStackView, dictionaryButton, historyButton) { stack, options, dictionary, history in
            options.leading == stack.leading
            options.trailing == stack.trailing
            
            dictionary.height == 64
            history.height == 64
            options.height == 64
        }
    }
    
    private func constrainView() {
        
        constrain(self, stackView, scrollView) { superview, stack, image in
            stack.top == superview.safeAreaLayoutGuide.top + 20
            stack.leading == superview.leading + 20
            stack.trailing == superview.trailing - 20
            
            image.top == stack.bottom + 24
            image.bottom == superview.bottom - 12
            image.leading == superview.leading + 20
            image.trailing == superview.trailing - 20
        }
        
        constrain(stackView, creationButton) { stack, creation in
            creation.leading == stack.leading
            creation.trailing == stack.trailing
            creation.height == 34
        }
    }
    
    private func constraintScrollAndImage() {
        
        constrain(scrollView, imageView) { scroll, image in
            image.edges == scroll.edges
        }
    }
    
    @objc private func didTapSearchButton() {
        delegate?.didTapSearchButton(with: searchBar.text ?? "")
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
    
    @objc private func didTapCreationButton() {
        delegate?.didTapCreationButton(with: searchBar.text ?? "")
    }
    
    @objc private func didTapHistoryButton() {
        delegate?.didTapHistoryButton()
    }
    
    @objc private func didTapDictionaryButton() {
        delegate?.didTapDictionaryButton()
    }
    
    func updateImageView(with image: UIImage) {
        imageView.image = image
    }
    
    func inputHistoryText(_ text: String) {
        searchBar.text = text
        delegate?.didTapSearchButton(with: text)
    }
}

extension BrailleView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
