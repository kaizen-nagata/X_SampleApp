//
//  X_SampleAppTests.swift
//  X_SampleAppTests
//
//  Created by r.nagata on 2024/11/26.
//

import XCTest
@testable import X_SampleApp

class X_SampleAppTests: XCTestCase {
    func testContentTrue() throws {
        let pv = PostViewController()
        let postData = PostDataModel()
        postData.username = "TestUser"
        postData.content = "Test Content"
        pv.postData = postData

        let result1 = pv.checkContentValidity(postData.content)
        XCTAssertTrue(result1)
    }
    
    func testContentFalse() throws {
        let pv = PostViewController()
        let postData = PostDataModel()
        postData.username = "TestUser"
        postData.content = "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"
        pv.postData = postData

        let result2 = pv.checkContentValidity(postData.content)
        XCTAssertFalse(result2)
    }

}
