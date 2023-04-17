struct BrailleSheet {
    let lines: [BrailleLine]
}

struct BrailleLine {
    let words: [BrailleWord]
}

struct BrailleWord {
    let letters: [BrailleLetter]
}

typealias BrailleLetter = [Int]
