//
//  TestMockNetwork.swift
//  SportsAppTests
//
//  Created by Israa Assem on 15/05/2024.
//


import XCTest
@testable import SportsApp
final class TestMockNetwork:XCTestCase{
    var mockNetwork:NetworkServiceMock!
    override func setUpWithError() throws {
        mockNetwork=NetworkServiceMock(shouldReturnError: false)
    }
    override func tearDownWithError() throws {
        mockNetwork=nil
    }

    func testFetchMockData() {
        mockNetwork.fetchData(url: URL(string: "https://www.icloud.com")!, completion: { (result: Result<FootballLeageResponse, Error>) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data, "Data should not be nil on success")
            case .failure(let error):
                XCTAssertNotNil(error, "Error should not be nil on failure")
            }
        })
    }

    
    func testFetchMockData2(){
        mockNetwork=NetworkServiceMock(shouldReturnError: true)
        mockNetwork.fetchData(url: URL(string: "https://www.icloud.com")!, completion: {(result:Result<FootballLeageResponse,Error>) in
            switch result{
            case .success(let data):
                XCTAssertNil(data)
            case .failure(_):
                XCTAssertNotNil(result)
            }
        })
    }
    func testResponseDecoding() {
        mockNetwork.fetchData(url: URL(string: "https://www.icloud.com")!) { (result: Result<FootballLeageResponse, Error>) in
            switch result {
            case .success(let data):
                XCTAssertTrue(data is FootballLeageResponse, "Data should be decoded as FootballLeageResponse")
            case .failure:
                XCTFail("Decoding should succeed and return FootballLeageResponse")
            }
        }
    }
    func testResponseContent() {
        mockNetwork.fetchData(url: URL(string: "https://www.icloud.com")!) { (result: Result<FootballLeageResponse, Error>) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.result.count, 2, "There should be 2 leagues in the response")
                XCTAssertEqual(data.result[0].leagueName, "Premier League", "The first league should be Premier League")
            case .failure:
                XCTFail("Response content should match the expected data")
            }
        }
    }

}

