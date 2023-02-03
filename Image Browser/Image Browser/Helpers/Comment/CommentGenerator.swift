//
//  CommentGenerator.swift
//  Image Browser
//
//  Created by Giri Bahari on 04/02/23.
//

import Foundation

class CommentGenerator {

    private var nounsPath: String!
    private var verbsPath: String!
    private var lastNamesPath: String!
    private var firstNamesPath: String!
    private let limitWords = Int.random(in: 0..<15)

    init() {
        nounsPath = Bundle(for: type(of: self)).path(forResource: "nouns", ofType: "json")
        verbsPath = Bundle(for: type(of: self)).path(forResource: "verbs", ofType: "json")
        lastNamesPath = Bundle(for: type(of: self)).path(forResource: "lastNames", ofType: "json")
        firstNamesPath = Bundle(for: type(of: self)).path(forResource: "firstNames", ofType: "json")
    }

    func generateComment() -> Comment {
        return Comment(author: generateFullName(), text: generateText())
    }

    func generateFullName() -> String {
        let firstNameData = try! Data(contentsOf: URL(fileURLWithPath: firstNamesPath))
        let lastNameData = try! Data(contentsOf: URL(fileURLWithPath: lastNamesPath))

        let firstName = try! decodeJSONArray(from: firstNameData)
        let lastName = try! decodeJSONArray(from: lastNameData)

        return "\(firstName.randomElement()!) \(lastName.randomElement()!)"
    }

    func generateText() -> String {
        let nounsData = try! Data(contentsOf: URL(fileURLWithPath: nounsPath))
        let verbsData = try! Data(contentsOf: URL(fileURLWithPath: verbsPath))

        let nouns = try! decodeJSONArray(from: nounsData)
        let verbs = try! decodeJSONArray(from: verbsData)

        var comment = ""
        for _ in 0..<limitWords {
            let randomNoun = nouns.randomElement()!
            let randomVerb = verbs.randomElement()!
            comment += "\(randomNoun) \(randomVerb) "
        }
        return comment
    }

    private func decodeJSONArray(from data: Data) throws -> [String] {
        return try JSONDecoder().decode([String].self, from: data)
    }
}
