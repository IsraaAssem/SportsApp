//
//  SportsAppUITests.swift
//  SportsAppUITests
//
//  Created by Israa Assem on 11/05/2024.
//

import XCTest
@testable import SportsApp
final class SportsAppUITests: XCTestCase {

    var mockNetwork:NetworkService!
    override func setUpWithError() throws {
        mockNetwork=NetworkService()
    }
    override func tearDownWithError() throws {
        mockNetwork=nil
    }
    func testFetchMockData() {
        let testExpectation=expectation(description: "waiting for api...")
        mockNetwork.fetchData(url: URL(string: "https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db")!, completion: { (result: Result<FootballLeageResponse, Error>) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data, "Data should not be nil on success")
                testExpectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil on failure")
                testExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5)
    }

    
    func testFetchMockData2(){
        let testExpectation=expectation(description: "https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db")
        mockNetwork.fetchData(url: URL(string: "https://www.icloud.com")!, completion: {(result:Result<FootballLeageResponse,Error>) in
            switch result{
            case .success(let data):
                XCTAssertNil(data)
                testExpectation.fulfill()
            case .failure(_):
                XCTAssertNotNil(result)
                testExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5)
    }
    func testResponseDecoding() {
        let testExpectation=expectation(description: "waiting for api...")
        mockNetwork.fetchData(url: URL(string: "https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db")!) { (result: Result<FootballLeageResponse, Error>) in
            switch result {
            case .success(let data):
                XCTAssertTrue(data is FootballLeageResponse, "Data should be decoded as FootballLeageResponse")
                testExpectation.fulfill()
            case .failure:
                XCTFail("Decoding should succeed and return FootballLeageResponse")
                testExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }
    func testResponseContent() {
        let testExpectation=expectation(description: "waiting for api...")
        mockNetwork.fetchData(url: URL(string: "https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=6d60bf6e27a572a97102e5f66104859253bf28f7bdd70dddef1405e12a5052db")!) { (result: Result<FootballLeageResponse, Error>) in
            switch result {
            case .success(let data):
                XCTAssertNotEqual(data.result.count, 2, "There should be 2 leagues in the response")
                XCTAssertEqual(data.result[0].leagueName, "UEFA Europa League", "The first league should be Premier League")
                testExpectation.fulfill()
            case .failure:
                XCTFail("Response content should match the expected data")
                testExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 20)
    }
}
