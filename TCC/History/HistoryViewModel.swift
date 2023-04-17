import Foundation

protocol HistoryViewModelProtocol {
    func getHistoryList() -> [String]
    func didTapHistoryItem(_ item: String)
    func clearFromHistory(value: String)
}

final class HistoryViewModel: HistoryViewModelProtocol {
    let historyRepository: UserSearchHistoryRepositoryProtocol
    
    init(historyRepository: UserSearchHistoryRepositoryProtocol) {
        self.historyRepository = historyRepository
    }
    
    func getHistoryList() -> [String] {
        return historyRepository.getUserHistory()
    }
    
    func didTapHistoryItem(_ item: String) {
        print("clicou no item \(item)")
    }
    
    func clearFromHistory(value: String) {
        historyRepository.clearFromHistory(value: value)
    }
}
