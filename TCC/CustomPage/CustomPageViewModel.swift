import Foundation

protocol CustomPageViewModelProtocol {
    func loadConfiguration() -> CustomPageDisplayViewModel
    func saveNewConfiguration(_ config: CustomPageDisplayViewModel)
}

final class CustomPageViewModel: CustomPageViewModelProtocol {
    
    let brailleConfiguration: BraillePageConfigurationProtocol
    
    init(brailleConfiguration: BraillePageConfigurationProtocol = BraillePageConfiguration.shared) {
        self.brailleConfiguration = brailleConfiguration
    }

    func loadConfiguration() -> CustomPageDisplayViewModel {
        let brailleCellConfiguration = brailleConfiguration.getBrailleCellConfiguration()
        let pageConfiguration = brailleConfiguration.getPrinterSheetConfiguration()
        
        return CustomPageDisplayViewModel(brailleConfiguration: brailleCellConfiguration, pageConfiguration: pageConfiguration)
    }
    
    func saveNewConfiguration(_ config: CustomPageDisplayViewModel) {
        brailleConfiguration.saveBrailleConfiguration(using: config.brailleConfiguration)
        brailleConfiguration.savePrinterSheetConfiguration(using: config.pageConfiguration)
    }
}
