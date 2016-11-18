//
//  DecypherTests.swift
//  DecypherTests
//
//  Created by Lúcio Pereira Franco on 11/11/16.
//  Copyright © 2016 'team'. All rights reserved.
//

import XCTest
@testable import Decypher
import Parse

class DecypherTests: XCTestCase {
    
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
    
    func testIfUserIsInRoom(){
        
        let expectationk = expectation(description: "hahah")

        WebServiceManager.checkIfUserIsInRoom("zjwlCno2dv", roomId: "o0dHqtaOK5") { (bool) in
            
            if bool{
                XCTAssert(true)
                expectationk.fulfill()
            }
            else{
                XCTAssert(false)
            }
        }
        waitForExpectations(timeout: 40.0, handler:nil)

    }
    
    func testUserPlayTime(){
        let expectationk = expectation(description: "hahah")
        
        WebServiceManager.checkUserPlayTimer("zjwlCno2dv", roomId: "o0dHqtaOK5") { (bool, int) in
            
            if bool{
                XCTAssert(true)
                expectationk.fulfill()
            }
            else{
                XCTAssert(false)
            }
        }

        waitForExpectations(timeout: 40.0, handler:nil)

    }
    
    func testCheckUserMatrix(){
        
        let expectationk = expectation(description: "hahah")

        
        WebServiceManager.checkUserMatrix("zjwlCno2dv", roomId: "o0dHqtaOK5", playerMatrixArray: [2,2,2,1,2,3,3,2,3]) { (array, string, object) in
            if (array == nil) && (string != nil){
                XCTAssert(true)
                expectationk.fulfill()
            }
            else{
                XCTAssert(false)
            }
        }
        
        waitForExpectations(timeout: 40.0, handler:nil)

    }
}
