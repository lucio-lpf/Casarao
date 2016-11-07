//
//  casaraoTests.swift
//  casaraoTests
//
//  Created by Lúcio Pereira Franco on 19/07/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import XCTest
import Parse

class casaraoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testWebRequestToGameRooms() {
        
    let expectationk = expectation(description: "hahah")

        let parseQuery = PFQuery(className: "GameRoom")
        parseQuery.whereKey("obejctId", equalTo: "QOCtu5drLf")
        parseQuery.findObjectsInBackground { (PFObjects, error) in
            if let e = error{
                print(e.localizedDescription)
            }else{
                print(PFObjects ?? 10)
                XCTAssert(true)
                expectationk.fulfill()
                
            }
            
        }
        waitForExpectations(timeout: 40.0, handler:nil)
    }
    
}
