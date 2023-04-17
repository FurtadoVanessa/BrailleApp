import Cartography
import Foundation
import UIKit

protocol CustomPageViewProtocol {
    func configure(using display: CustomPageDisplayViewModel)
    var delegate: CustomPageViewDelegate? { get set }
}

protocol CustomPageViewDelegate: AnyObject {
    func didTapSaveConfiguration(using config: CustomPageDisplayViewModel)
}

final class CustomPageView: UIView, CustomPageViewProtocol {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let brailleLabel: UILabel = {
        let label = UILabel()
        label.text = "BRAILLE (em mm)"
        return label
    }()
    
    private let brailleSpacing: UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let brailleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let dotDiameterCell = CustomFieldEditView(label: "Diametro")
    private let spaceBetweenDotsCell = CustomFieldEditView(label: "Entre pontos")
    private let spaceBetweenCellsCell = CustomFieldEditView(label: "Entre celas")
    private let spaceBetweenLinesCell = CustomFieldEditView(label: "Entre linhas")
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "FOLHA (em mm)"
        return label
    }()
    
    private let pageSpacing: UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let pageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let topMarginCell = CustomFieldEditView(label: "Margem topo")
    private let bottomMarginCell = CustomFieldEditView(label: "Margem fim")
    private let leftMarginCell = CustomFieldEditView(label: "Margem esquerda")
    private let rightMarginCell = CustomFieldEditView(label: "Margem direita")
    private let heightInMMCell = CustomFieldEditView(label: "Altura")
    private let widthInMMCell = CustomFieldEditView(label: "Largura")
    private let resolutionInDpiCell = CustomFieldEditView(label: "Resolução DPI")
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 234/255, green: 176/255, blue: 176/255, alpha: 1)
        button.setTitle("Salvar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = false
        button.alpha = 1.0
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(didTapSaveConfiguration), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CustomPageViewDelegate?
    
    var brailleProperties: [CustomFieldEditView] = []
    var pageProperties: [CustomFieldEditView] = []
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        setup()
        constrainViews()
        constrainSection(label: brailleLabel, spacing: brailleSpacing, stackView: brailleStackView)
        constrainSection(label: pageLabel, spacing: pageSpacing, stackView: pageStackView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func setup() {
        stackView.addArrangedSubview(brailleLabel)
        stackView.addArrangedSubview(brailleSpacing)
        stackView.addArrangedSubview(brailleStackView)
        stackView.addArrangedSubview(pageLabel)
        stackView.addArrangedSubview(pageSpacing)
        stackView.addArrangedSubview(pageStackView)
        
        stackView.setCustomSpacing(12, after: brailleStackView)
        
        contentView.addSubview(stackView)
        
        scrollView.addSubview(contentView)
        
        scrollView.contentSize = contentView.frame.size
        
        addSubview(scrollView)
        addSubview(button)
        
        setupBrailleProperties()
        setupPageProperties()
    }
    
    private func setupBrailleProperties() {
        brailleStackView.addArrangedSubview(dotDiameterCell)
        brailleStackView.addArrangedSubview(spaceBetweenDotsCell)
        brailleStackView.addArrangedSubview(spaceBetweenCellsCell)
        brailleStackView.addArrangedSubview(spaceBetweenLinesCell)
    }
    
    private func setupPageProperties() {
        pageStackView.addArrangedSubview(topMarginCell)
        pageStackView.addArrangedSubview(bottomMarginCell)
        pageStackView.addArrangedSubview(leftMarginCell)
        pageStackView.addArrangedSubview(rightMarginCell)
        pageStackView.addArrangedSubview(heightInMMCell)
        pageStackView.addArrangedSubview(widthInMMCell)
        pageStackView.addArrangedSubview(resolutionInDpiCell)
    }
    
    private func constrainSection(label: UILabel, spacing: UIView, stackView: UIStackView) {
        constrain(stackView, label, spacing, stackView) { superview, label, spacing, stack in
            label.leading == superview.leading
            label.trailing == superview.trailing
            
            spacing.leading == superview.leading
            spacing.trailing == superview.trailing
            spacing.height == 1
            
            stack.leading == superview.leading
            stack.trailing == superview.trailing
        }
    }
    
    private func constrainViews() {
        constrain(contentView, stackView) { content, stack in
            stack.edges == content.edges
        }
        
        constrain(self, scrollView, contentView, button) { superview, scroll, stack, button in
            scroll.top == superview.top + 12
            scroll.leading == superview.leading + 12
            scroll.trailing == superview.trailing - 12

            scroll.bottom == button.top - 12

            button.leading == superview.leading + 12
            button.trailing == superview.trailing - 12
            button.bottom == superview.bottom - 12
            
            stack.leading == scroll.leading
            stack.trailing == scroll.trailing
            stack.top == scroll.top
            stack.bottom == scroll.bottom
        
            stack.width == scroll.width
        }
    }
    
    @objc private func didTapSaveConfiguration() {
        let brailleProperties = getBrailleProperties()
        let pageProperties = getPageProperties()
        
        delegate?.didTapSaveConfiguration(using: CustomPageDisplayViewModel(brailleConfiguration: brailleProperties, pageConfiguration: pageProperties))
    }
    
    func configure(using display: CustomPageDisplayViewModel) {
        configureBrailleProperties(display.brailleConfiguration)
        
        configurePageProperties(display.pageConfiguration)
    }
    
    private func configureBrailleProperties(_ brailleConfiguration: BrailleCellProtocol) {
        dotDiameterCell.configure(labelText: "Diametro", custonValueText: String(brailleConfiguration.dotDiameter))
        spaceBetweenDotsCell.configure(labelText: "Entre pontos", custonValueText: String(brailleConfiguration.spaceBetweenDots))
        spaceBetweenCellsCell.configure(labelText: "Entre celas", custonValueText: String(brailleConfiguration.spaceBetweenCells))
        spaceBetweenLinesCell.configure(labelText: "Entre linhas", custonValueText: String(brailleConfiguration.spaceBetweenLines))
    }
    
    private func configurePageProperties(_ pageConfiguration: PrinterSheetProtocol) {
        topMarginCell.configure(labelText: "Margem topo", custonValueText: String(pageConfiguration.topMargin))
        bottomMarginCell.configure(labelText: "Margem fim", custonValueText: String(pageConfiguration.bottomMargin))
        leftMarginCell.configure(labelText: "Margem esquerda", custonValueText: String(pageConfiguration.leftMargin))
        rightMarginCell.configure(labelText: "Margem direita", custonValueText: String(pageConfiguration.rightMargin))
        heightInMMCell.configure(labelText: "Altura", custonValueText: String(pageConfiguration.heightInMM))
        widthInMMCell.configure(labelText: "Largura", custonValueText: String(pageConfiguration.widthInMM))
        resolutionInDpiCell.configure(labelText: "Resolução DPI", custonValueText: String(pageConfiguration.resolutionInDpi))
    }
    
    private func getBrailleProperties() -> BrailleCellProtocol {
        
        let dotDiameterCellValue = dotDiameterCell.getPropertyValue()
        let spaceBetweenDotsCellValue = spaceBetweenDotsCell.getPropertyValue()
        let spaceBetweenCellsCellValue = spaceBetweenCellsCell.getPropertyValue()
        let spaceBetweenLinesCellValue = spaceBetweenLinesCell.getPropertyValue()
        
        
        let brailleCell = BrailleCell(
            dotDiameter: Double(dotDiameterCellValue) ?? 0,
            spaceBetweenDots: Double(spaceBetweenDotsCellValue) ?? 0,
            spaceBetweenCells: Double(spaceBetweenCellsCellValue) ?? 0,
            spaceBetweenLines: Double(spaceBetweenLinesCellValue) ?? 0
        )
        
        return brailleCell
    }
    
    private func getPageProperties() -> PrinterSheetProtocol {
        
        let topMarginCellValue = topMarginCell.getPropertyValue()
        let bottomMarginCellValue = bottomMarginCell.getPropertyValue()
        let leftMarginCellValue = leftMarginCell.getPropertyValue()
        let rightMarginCellValue = rightMarginCell.getPropertyValue()
        let heightInMMCellValue = heightInMMCell.getPropertyValue()
        let widthInMMCellValue = widthInMMCell.getPropertyValue()
        let resolutionInDpiCellValue = resolutionInDpiCell.getPropertyValue()
        
        let printerSheet = PrinterSheet(
            widthInMM: Double(widthInMMCellValue) ?? 0,
            heightInMM: Double(heightInMMCellValue) ?? 0,
            resolutionInDpi: Int(resolutionInDpiCellValue) ?? 0,
            leftMargin: Double(leftMarginCellValue) ?? 0,
            rightMargin: Double(rightMarginCellValue) ?? 0,
            topMargin: Double(topMarginCellValue) ?? 0,
            bottomMargin: Double(bottomMarginCellValue) ?? 0
        )
        
        return printerSheet
    }
}
