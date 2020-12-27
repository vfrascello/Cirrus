//
//  HelperFunctions.swift
//  Cirrus
//
//  Created by Vincent Frascello on 12/25/20.
//

import Foundation
class ForecastHelper{
    

    static func getDayOfWeek(epochValue: Int) -> String {
        
        let date = Date(timeIntervalSince1970: Double(epochValue))
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        //EEEE is the screech of a scared Shilling.  Was DateFormat written by Brenden?
        return df.string(from: date)
        
        
    }
    
    static func convertKelvinToCelsius(temp: Double) -> String {
        //why do we not need to guard/let / check for Nil value in Temp?
        let celsiusValue = (temp - 273.15).rounded()
        
        return "\(celsiusValue.description) deg C"
        
    }
    
}
