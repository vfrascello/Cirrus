
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var currentFeelsLikeLabel: UILabel!
    @IBOutlet weak var currentActualTempLabel: UILabel!
    @IBOutlet weak var manualLocationButton: UIButton!
    

    
    var oneCallResponse: OneCallResponse!
    var locationManager: CLLocationManager!
    var userLatitude: String!
    var userLongitude: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        
    }
    
    private func configureLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self   //is this setting the delegate for LocationMangager to ViewController?
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        else {
          //Would be cool to pop up a dumb alert here saying "Shilling you were dumb to deny location services access
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        
        self.locationManager.stopUpdatingLocation()
        
         userLatitude = userLocation.coordinate.latitude.description
         userLongitude = userLocation.coordinate.longitude.description
        
        APIService.getOneCallResponse(latitude: userLatitude, longitude: userLongitude, completion: { response in
            
            self.oneCallResponse = response
            
            DispatchQueue.main.async {
                
                let currentActualTemp = ForecastHelper.convertKelvinToCelsius(temp: self.oneCallResponse.current.temp)
                let currentFeelsLike = ForecastHelper.convertKelvinToCelsius(temp: self.oneCallResponse.current.feelsLike)
               
                self.currentActualTempLabel.text = currentActualTemp
                self.currentConditionsLabel.text = self.oneCallResponse.current.conditionDescription[0].description.capitalized
                self.currentFeelsLikeLabel.text = "Feels Like \(currentFeelsLike)"
            
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ForecastController {  //I want you to explain this line.  the as?  and etc.
            destination.forecastData = self.oneCallResponse
        }
    }
    
    @IBAction func segueToForecast(_sender: Any){  //I tried to write this from scratch but it wouldn't recognize performSegue.
        performSegue(withIdentifier: "forecastSegue", sender: _sender)
        
    }
    
    @IBAction func refreshButtonPush() -> Void {
        print("Button Pushed")
        let alertController = UIAlertController(title: "Enter Manual Coordinates", message: "", preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField{ (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Latitude"
            }
        let saveAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let manualLatitude = alertController.textFields![0].text!
            let manualLongitude = alertController.textFields![1].text!
            
            APIService.getOneCallResponse(latitude: manualLatitude, longitude: manualLongitude, completion: { response in
                
                self.oneCallResponse = response
                
                DispatchQueue.main.async {
                    //is it OK to redeclare these variables that are the same in locationManager because it's a different scope?  Or would it be better to declare them globally in the class and then reference?
                    let currentTemp = ForecastHelper.convertKelvinToCelsius(temp: self.oneCallResponse.current.temp)
                    let currentFeelsLike = ForecastHelper.convertKelvinToCelsius(temp: self.oneCallResponse.current.feelsLike)
                    self.currentActualTempLabel.text = currentTemp
                    self.currentConditionsLabel.text = self.oneCallResponse.current.conditionDescription[0].description.capitalized
                    self.currentFeelsLikeLabel.text = "Feels Like \(currentFeelsLike)"
                }
            })
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Longitude"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in })
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)    }
}


