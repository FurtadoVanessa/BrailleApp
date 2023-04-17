import Firebase
import Foundation

final class RemoteAlphabetService: AlphabetServiceProtocol {
    var alphabet: BrailleAlphabet = BrailleAlphabet(letters: [:])
    
    func getAlphabet() -> BrailleAlphabet {
        return alphabet
    }
    
    func getLetter(_ letter: String) -> [Int] {
        if alphabet.letters.isEmpty {
            alphabet = getRemoteAlphabet()
        }
        print(alphabet)
        
        return alphabet.letters[letter] ?? []
    }
    
    private func getRemoteAlphabet() -> BrailleAlphabet {
        let databaseReference = Database.database().reference()
        var convertedValues = BrailleAlphabet(letters: [:])
        
        databaseReference.child("letters").getData() { error, snapshot in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            let data = snapshot.value as! [String: String]
            
            do {
                for (key, value) in data {
                    let convertedValue = try JSONDecoder().decode([Int].self, from: value.data(using: .ascii)!)
                    convertedValues.letters[key] = convertedValue
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        print("converted values \(convertedValues)")
        return convertedValues
    }
}
