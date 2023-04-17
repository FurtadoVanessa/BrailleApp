import Foundation

protocol CreationModeDataStoreProtocol {
    var text: String { get }
}

final class CreationModeDataStore: CreationModeDataStoreProtocol {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
