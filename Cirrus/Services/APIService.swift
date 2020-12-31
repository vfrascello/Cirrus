//
//  APIService.swift
//  Cirrus
//
//  Created by Vincent Frascello on 12/25/20.
//

import Foundation

class APIService{
    
    static func getOneCallResponse(latitude: String, longitude: String, completion: @escaping (OneCallResponse) -> Void){  //Our function is a void funtion (doesn't return the class), the completion handler is also a Void function (that requires a OneCallResponse object).  We actually define the completion handler as a closure in the view controller, which is where the data is assigned to the storyboard objects. Am I right?
        
        let APIUrl: URL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&appid=\(Constants.APIKey)")!
        
        URLSession.shared.dataTask(with: APIUrl, completionHandler: {data, response, error in
            
            //This closure IS the completion handler were passing to dataTask, correct?  So basically datatTask does the APICall and when it's complete, it runs this code to store the result into my class, and THEN we call our OWN completion handler on line 27 so our program knows it's APIService function is complete. LMK if I understand this correctly.
            
            
            guard let shilling = data, error == nil else //is data = data an assignment or a boolean check?  I understand the second part is ensuring that no error was thrown, what is the purpose of the first check?
            {
                return
            }
            
            do {
                let oneCallResponse: OneCallResponse = try JSONDecoder().decode(OneCallResponse.self, from: shilling)  //Why do we need the tuples after JSONDecoder?
                completion(oneCallResponse) // is this a func call to our completion handler, letting it know that we've completed the API call?
                print("[SUCCESS] JSONDecoder()", oneCallResponse.daily.count)
                
            } catch{
                //is this where we would error handle if the JSONDecoder fails?
            }
        }).resume()
        
        //Whats the shortcut for cleaning code and lining up brackets, deleting empty lines etc?
    }
    
    
    
    
}
