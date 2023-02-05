//
//  ResourceCommentTest.swift
//  Image BrowserTests
//
//  Created by Giri Bahari on 04/02/23.
//

import XCTest
@testable import Image_Browser

final class ResourceCommentTest: XCTestCase {

    func test_resource_nouns_exist() {
        // given
        let bundle = Bundle(for: type(of: self))

        // when
        guard let nounsPath = bundle.path(forResource: "nouns", ofType: "json") else {
            XCTFail("JSON file does not exist in bundle")
            return
        }

        // result
        XCTAssertTrue(FileManager.default.fileExists(atPath: nounsPath),
                      "JSON file does not exist at path \(nounsPath)")
    }

    func test_resource_verbs_exist() {
        // given
        let bundle = Bundle(for: type(of: self))

        // when
        guard let verbsPath = bundle.path(forResource: "verbs", ofType: "json") else {
            XCTFail("JSON file does not exist in bundle")
            return
        }

        // result
        XCTAssertTrue(FileManager.default.fileExists(atPath: verbsPath),
                      "JSON file does not exist at path \(verbsPath)")
    }

    func test_resource_lastNames_exist() {
        // given
        let bundle = Bundle(for: type(of: self))

        // when
        guard let lastNamesPath = bundle.path(forResource: "lastNames", ofType: "json") else {
            XCTFail("JSON file does not exist in bundle")
            return
        }

        // result
        XCTAssertTrue(FileManager.default.fileExists(atPath: lastNamesPath),
                      "JSON file does not exist at path \(lastNamesPath)")
    }

    func test_resource_firstNames_exist() {
        // given
        let bundle = Bundle(for: type(of: self))

        // when
        guard let firstNamesPath = bundle.path(forResource: "firstNames", ofType: "json") else {
            XCTFail("JSON file does not exist in bundle")
            return
        }

        // result
        XCTAssertTrue(FileManager.default.fileExists(atPath: firstNamesPath),
                      "JSON file does not exist at path \(firstNamesPath)")
    }

}
