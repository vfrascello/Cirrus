//
//  ForecastController.swift
//  Cirrus
//
//  Created by Vincent Frascello on 12/27/20.
//

import Foundation
import UIKit

class ForecastController
: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var FiveDayTable: UITableView!
    
    var forecastData: OneCallResponse!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("forecast loaded")
        configureForecastTable()
        print("Forecast Controller", forecastData.daily.count)
    }
    
    private func configureForecastTable(){
        FiveDayTable.delegate = self
        FiveDayTable.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fiveDayForecast = 5
        return fiveDayForecast
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = FiveDayTable.dequeueReusableCell(withIdentifier: "fcCell", for: indexPath)
        let highTemp: String = ForecastHelper.convertKelvinToCelsius(temp: self.forecastData.daily[indexPath.row].tempRange.max)
        let lowTemp: String = ForecastHelper.convertKelvinToCelsius(temp: self.forecastData.daily[indexPath.row].tempRange.min)
        let dayOfWeek: String = ForecastHelper.getDayOfWeek(epochValue: forecastData.daily[indexPath.row].epochDate)
       
        cell.textLabel?.text = "\(dayOfWeek): High: \(highTemp) Low: \(lowTemp)"
        print(cell.description)
        return cell
    }
}
