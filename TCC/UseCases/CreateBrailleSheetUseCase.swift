import Foundation
import UIKit

protocol CreateBrailleSheetDataStoreProtocol {
    var brailleCell: BrailleCellProtocol { get set }
    var printerSheet: PrinterSheetProtocol { get set }
}

final class CreateBrailleSheetDataStore: CreateBrailleSheetDataStoreProtocol {
    var brailleCell: BrailleCellProtocol
    var printerSheet: PrinterSheetProtocol
    
    init(
        brailleCell: BrailleCellProtocol,
        printerSheet: PrinterSheetProtocol
    ) {
        self.brailleCell = brailleCell
        self.printerSheet = printerSheet
    }
}

protocol CreateBrailleSheetUseCase {
    func execute(for sheet: BrailleSheet, isPdfCreation: Bool) -> UIImage
    func execute(for letter: BrailleLetter) -> UIImage
}

final class CreateBrailleSheet: CreateBrailleSheetUseCase {
    let convertPixelsUseCase: ConvertPixelsByMMUseCase
    let convertBrailleCellToPixelsUseCase: ConvertBrailleCellToPixelsUseCase
    let convertPrintSheetToPixelsUseCase: ConvertPrinterSheetToPixelsUseCase
    let getLineSizeUseCase: GetLineSizeUseCase
    
    var dataStore: CreateBrailleSheetDataStoreProtocol
    
    var letterShift: Int = 0
    
    init(
        convertPixelsUseCase: ConvertPixelsByMMUseCase = ConvertPixelsByMM(),
        convertBrailleCellToPixelsUseCase: ConvertBrailleCellToPixelsUseCase = ConvertBrailleCellToPixels(),
        convertPrintSheetToPixelsUseCase: ConvertPrinterSheetToPixelsUseCase = ConvertPrinterSheetToPixels(),
        getLineSizeUseCase: GetLineSizeUseCase = GetLineSize(),
        dataStore: CreateBrailleSheetDataStoreProtocol
    ) {
        self.convertPixelsUseCase = convertPixelsUseCase
        self.convertBrailleCellToPixelsUseCase = convertBrailleCellToPixelsUseCase
        self.convertPrintSheetToPixelsUseCase = convertPrintSheetToPixelsUseCase
        self.getLineSizeUseCase = getLineSizeUseCase
        self.dataStore = dataStore
    }
    
    func execute(for sheet: BrailleSheet, isPdfCreation: Bool = true) -> UIImage {
        
        if !isPdfCreation {
            dataStore.printerSheet.resetMargins(for: dataStore.brailleCell.dotDiameter)
        }
        
        let backgroundImage: UIImage = UIImage(named: "sheet")!
        
        UIGraphicsBeginImageContext(backgroundImage.size)

        // Draw the starting image in the current context as background
        backgroundImage.draw(at: CGPoint.zero)

        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        for(index, line) in sheet.lines.enumerated() {
            drawLine(line, at: index, using: context)
        }
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return myImage ?? UIImage()
    }
    
    func execute(for letter: BrailleLetter) -> UIImage {
        
        let backgroundImage: UIImage = UIImage(named: "singleCell")!
        
        UIGraphicsBeginImageContext(backgroundImage.size)

        // Draw the starting image in the current context as background
        backgroundImage.draw(at: CGPoint.zero)

        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        drawLetter(using: letter, startingAt: CGPoint(x: dataStore.brailleCell.dotDiameter, y: dataStore.brailleCell.dotDiameter), with: context)
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return myImage ?? UIImage()
    }
    
    private func drawLine(_ line: BrailleLine, at index: Int, using context: CGContext) {
        letterShift = 0
        for word in line.words {
            drawWord(word, at: index, using: context)
        }
    }
    
    private func drawWord(_ word: BrailleWord, at line: Int, using context: CGContext) {
        for letter in word.letters {
            let brailleCellWidth = dataStore.brailleCell.spaceBetweenCells
            let brailleLineHeight = dataStore.brailleCell.spaceBetweenLines
            
            let sheetStartingPoint = CGPoint(
                x: dataStore.printerSheet.leftMargin + (Double(letterShift) * brailleCellWidth),
                y: dataStore.printerSheet.topMargin + (Double(line - 1) * brailleLineHeight)
            )
            
            drawLetter(using: letter, startingAt: sheetStartingPoint, with: context)
            letterShift += 1
        }
    }
    
    private func drawLetter(using letter: [Int], startingAt: CGPoint, with context: CGContext) {
        
        drawColumn(1, using: letter, at: startingAt, with: context)
        drawColumn(2, using: letter, at: startingAt + CGPoint(x: dataStore.brailleCell.spaceBetweenDots, y: 0), with: context)
        
    }
    
    private func drawColumn(_ index: Int, using letter: [Int], at point: CGPoint, with context: CGContext) {
        let startingLine = (3 * (index - 1)) + 1
        let endingLine = (3 * (index - 1)) + 3
        
        for dot in startingLine...endingLine {
            let startPoint = point + CGPoint(x: 0, y: ((dot + 2) % 3) * Int(dataStore.brailleCell.spaceBetweenDots))
            
            if letter.contains(dot) {
                drawCircle(using: context, startPoint: startPoint, using: .black)
            } else {
                drawCircle(using: context, startPoint: startPoint, using: .lightGray)
            }
            
        }
    }
    
    private func drawCircle(using context: CGContext, startPoint: CGPoint, using color: UIColor) {
        context.setStrokeColor(color.cgColor)
        context.setAlpha(1)
        context.setLineWidth(5.0)
        context.addArc(center: startPoint, radius: dataStore.brailleCell.dotDiameter / 2, startAngle: deg2rad(0), endAngle: deg2rad(360), clockwise: true)
        context.setFillColor(color.cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

extension CGPoint {
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
