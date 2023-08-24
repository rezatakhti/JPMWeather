//
//  JPMWeatherTests.swift
//  JPMWeatherTests
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import XCTest
@testable import JPMWeather

//the most basic of tests. Just testing basic string formatting
//would've loved to do more mocking and advances tests for the different functions given more time
final class MainViewModelTests: XCTestCase {
    
    var viewModel : MainViewModel!

    override func setUpWithError() throws {
        viewModel = MainViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFormatHighLowLabel() throws {
        
        let weatherResponse = WeatherResponse(weather: [], main: Main(temp: 55, feelsLike: 45, tempMin: 35, tempMax: 65), name: "")
        XCTAssertEqual(viewModel.formatHighLowLabel(response: weatherResponse), "H:65° L:35°")
    }
}
