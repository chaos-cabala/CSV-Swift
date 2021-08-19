//
//  csv.swift
//
//
//  Created by Chaos on 2021/8/19.
//
import Foundation

struct  CSV {
    static let comma: Character = ","
    let enumeratedRows:[[String]]
    let namedRows: [[String : String]]

    public init(string: String, delimiter: Character = comma) {
        self.enumeratedRows = Self.parserToArray(text: string, delimiter: delimiter) //一次性读取全部
        self.namedRows = Self.parserToDictionary( body:self.enumeratedRows)
    }
    static private func numberOfSuffixQuotes(_ chip:String)->Int{
        var len = 0
        while len < chip.count {
            let quotes = String(repeating: "\"", count: len + 1)
            guard chip.hasSuffix(quotes) else {
                return len
            }
            len += 1
        }
        return len
    }
   static private func parserToDictionary(body: [[String]])->[[String: String]]{
        let header = body.first ?? []
        var rows = [[String: String]]()
        let enumeratedHeader = header.enumerated()
        guard body.count > 1 else { return rows }
     
        body[1 ..< body.count].forEach { fields in
            var dict = [String: String]()
            for (index, head) in enumeratedHeader {
                dict[head] = index < fields.count ? fields[index] : ""
            }
            rows.append(dict)
        }
        return rows
    }
    static private func parserToArray(text: String, delimiter: Character)-> [[String]] {

        var rows = [[String]]()
        let delimiters:CharacterSet =  CharacterSet(charactersIn: "\(delimiter)")
        var isEndField = true //开始新field
        var isEndLine = true //开始新一行
        var field = ""
        var fields = [String]()
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            if line.isEmpty && isEndLine  { continue }
            let chips = line.components(separatedBy: delimiters)

            for chip in chips{
                if isEndField {
                    field.append(chip)
                    if chip.hasPrefix("\""){
                        field.removeFirst()
                        let number = numberOfSuffixQuotes(chip)
                        if number < chip.count{
                            if number % 2 == 0  { isEndField = false }
                        }else{
                            if number % 2 == 1  { isEndField = false }
                        }
                        if isEndField {
                            field.removeLast()
                            field = field.replacingOccurrences(of: "\"\"", with: "\"")
                        }
                    }
                }else{
                    if isEndLine {
                        field.append(delimiter)
                    }else{
                        field.append("\n")
                        isEndLine = true
                    }
                    
                    field.append(chip)
                    let number = numberOfSuffixQuotes(chip)
                    if number % 2 == 1  {
                        isEndField = true
                        field.removeLast()
                        field = field.replacingOccurrences(of: "\"\"", with: "\"")
                    }
                }
                if isEndField {
                    fields.append(field)
                    field.removeAll()
                }
            }
            if isEndField {
                rows.append(fields)
                fields.removeAll()
            }else{
                isEndLine = false
            }
        }
        return rows
    }
}
