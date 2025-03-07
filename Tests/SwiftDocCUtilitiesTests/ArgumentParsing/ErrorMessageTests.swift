/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import XCTest
import Foundation
@testable import SwiftDocCUtilities

class ErrorMessageTests: XCTestCase {
    
    func testInvalidParameterMessageError() throws {
        // create source bundle directory
        let sourceURL = Foundation.URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("documentation")
        try FileManager.default.createDirectory(at: sourceURL, withIntermediateDirectories: true, attributes: nil)
        defer {
            try? FileManager.default.removeItem(at: sourceURL)
        }
        try "".write(to: sourceURL.appendingPathComponent("Info.plist"), atomically: true, encoding: .utf8)
        
        // create renderer template directory
        let rendererDirectory = Foundation.URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: rendererDirectory, withIntermediateDirectories: true, attributes: nil)
        defer {
            try? FileManager.default.removeItem(at: rendererDirectory)
        }
        try "".write(to: rendererDirectory.appendingPathComponent("index.html"), atomically: true, encoding: .utf8)
        
        do {
            setenv(TemplateOption.environmentVariableKey, rendererDirectory.path, 1)
            let _ = try Docc.Convert.parse([
                sourceURL.path,
            ])
        } catch {
            // TODO: This catch isn't thrown. This test should be fixed.
            XCTAssertEqual(error.localizedDescription, "Invalid value for parameter 'html-template-dir'. /non_existing_folder is not a directory.")
        }
        
    }

}
