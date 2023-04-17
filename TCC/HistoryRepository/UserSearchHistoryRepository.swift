import Foundation

protocol UserSearchHistoryRepositoryProtocol {
    func saveInHistory(text: String)
    func getUserHistory() -> [String]
    func clearFromHistory(value: String)
}

final class UserSearchHistoryRepository: UserSearchHistoryRepositoryProtocol {
    
    let historyKey = "History"
    
    let userDefaults: UserDefaults
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    func saveInHistory(text: String) {
        guard !text.isEmpty else { return }
        
        if var actualList = userDefaults.object(forKey: historyKey) as? [String] {
            actualList.append(text)
            userDefaults.set(actualList, forKey: historyKey)
        } else {
            userDefaults.set([text], forKey: historyKey)
        }
    }
    
    func getUserHistory() -> [String] {
        if let actualList = userDefaults.object(forKey: historyKey) as? [String] {
            return actualList
        } else {
            return []
        }
    }
    
    func clearFromHistory(value: String) {
        var list = getUserHistory()
        
        if let index = list.firstIndex(of: value) {
            list.remove(at: index)
        }
        userDefaults.set(list, forKey: historyKey)
        
    }
}
