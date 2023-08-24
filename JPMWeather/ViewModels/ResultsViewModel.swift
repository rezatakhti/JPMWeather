//
//  ResultsViewModel.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import Foundation

//Super simple viewModel. Obviously as complexity grows this class will grow as well 
class ResultsViewModel {
    var results: [GeoLocation] = []
    func formatCellText(for i: Int) -> String {
        return results[i].name + ", " + results[i].state + ", " + results[i].country
    }
}
