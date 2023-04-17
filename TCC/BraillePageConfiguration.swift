import Foundation

protocol BraillePageConfigurationProtocol {
    func getAlphabet() -> AlphabetServiceProtocol
    func getBrailleCellConfiguration() -> BrailleCellProtocol
    func getPrinterSheetConfiguration() -> PrinterSheetProtocol
    func saveBrailleConfiguration(using brailleConfiguration: BrailleCellProtocol)
    func savePrinterSheetConfiguration(using printerSheetConfiguration: PrinterSheetProtocol)
}

final class BraillePageConfiguration: BraillePageConfigurationProtocol {
    
    static let shared = BraillePageConfiguration()
    
    let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    func getAlphabet() -> AlphabetServiceProtocol {
        return LocalAlphabetService()
    }
    
    func getBrailleCellConfiguration() -> BrailleCellProtocol {
        do {
            let customBrailleCell = try userDefaults.getObject(forKey: "BrailleCell", castTo: BrailleCell.self)
            return customBrailleCell
        }  catch {
            return DefaultBrailleCell()
        }
    }
    
    func getPrinterSheetConfiguration() -> PrinterSheetProtocol {
        do {
            let customPrinterSheet = try userDefaults.getObject(forKey: "PrinterSheet", castTo: PrinterSheet.self)
            return customPrinterSheet
        } catch {
            return DefaultPrinterSheet()
        }
    }
    
    func saveBrailleConfiguration(using brailleConfiguration: BrailleCellProtocol) {
        do {
            try userDefaults.setCustomObject(brailleConfiguration as! BrailleCell, forKey: "BrailleCell")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func savePrinterSheetConfiguration(using printerSheetConfiguration: PrinterSheetProtocol) {
        do {
            try userDefaults.setCustomObject(printerSheetConfiguration as! PrinterSheet, forKey: "PrinterSheet")
        } catch {
            print(error.localizedDescription)
        }
    }
}

protocol ObjectSavable {
    func setCustomObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setCustomObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
