import Foundation

protocol ConvertPixelsByMMUseCase {
    func execute(mm: Double, dpi: Int) -> Int
}

final class ConvertPixelsByMM: ConvertPixelsByMMUseCase {
    
    func execute(mm: Double, dpi: Int) -> Int {
        let pixels = Int((Double(dpi) * mm) / (25.4))
        return pixels
    }
}
