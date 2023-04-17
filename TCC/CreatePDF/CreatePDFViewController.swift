import PDFKit
import UIKit

final class CreatePDFViewController: UIViewController {
    
    private var customView: (UIView & CreatePDFViewProtocol)
    private let viewModel: CreatePDFViewModelProtocol
    
    init(
        customView: (UIView & CreatePDFViewProtocol),
        viewModel: CreatePDFViewModelProtocol
    ) {
        self.customView = customView
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
        self.customView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override public func loadView() {
        isModalInPresentation = false
        view = customView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIView.setViewTitleForNavigation("CRIAR PDF")
        navigationController?.setNavigationBarHidden(false, animated: false)
        edgesForExtendedLayout = .top
    }
}

extension CreatePDFViewController: CreatePDFViewDelegate {
    func didTapCreatePDF(with text: String, naming name: String) {
        let images = viewModel.createBrailleImage(using: text)

        // Create an empty PDF document
        let pdfDocument = PDFDocument()

        for (index, image) in images.enumerated() {
            // Create a PDF page instance from your image
            let pdfPage = PDFPage(image: image.withHorizontallyFlippedOrientation())

            // Insert the PDF page into your document
            pdfDocument.insert(pdfPage!, at: index)
        }

        // Get the raw data of your PDF document
        let data = pdfDocument.dataRepresentation()

        // The url to save the data to
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent("\(name).pdf")
        let outputFileURL: URL = docURL

        // Save the data to the url
        try! data!.write(to: outputFileURL)

        let dc = UIDocumentInteractionController(url: outputFileURL)
        dc.delegate = self
        dc.presentPreview(animated: true)
    }
}

extension CreatePDFViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
