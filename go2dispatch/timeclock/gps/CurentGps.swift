//
//  CurentGps.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/28/21.
//

import Foundation
import CoreLocation
import SwiftLocation

struct CurrentGpsModel {
    let addressComplete  : String?
    let zone : String?
    let state : String?
    let city : String?
    let latitude : Double?
    let longitude : Double?
}
class CurrentGps  {
    

    static func get_location_and_address(handler : @escaping (_ error: String?, _ addressLocation : CurrentGpsModel?)->()) {
        
        let locationManager = CLLocationManager()
        if locationManager.authorizationStatus  == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            handler("🔥 not have permission the take location", nil)
            
        } else if locationManager.authorizationStatus == .authorizedWhenInUse  ||  locationManager.authorizationStatus  == .authorizedAlways {
            
            let getLocation = GetLocation()
            getLocation.run {
                if let location = $0 {
                      print("location tomada = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                let latitude  =  location.coordinate.latitude
                let longitude =  location.coordinate.longitude
                    
                    let geocoder = CLGeocoder()
                    let location =  CLLocation(latitude: latitude, longitude: longitude)
                    //
                    let location2d = CLLocationCoordinate2DMake(latitude, longitude)
                    geocoder.reverseGeocodeLocation(location , completionHandler: {
                        (placemarks, error) in
                        if placemarks != nil {
                            let placemark = placemarks?.first!
                            print("todo \(String(describing: placemark))")
                            
                            let address = placemark?.name! ?? "none"
                            let ciudad = placemark?.locality! ?? "none"
                            let country = placemark?.isoCountryCode! ?? "none"
                            let estado =  placemark?.administrativeArea! ??  "none"
                            var zone = ""
                            if let z  = placemark?.postalCode {
                                zone =  z
                            }
                            
                            let AddressComplete = "\(address), \(ciudad), \(estado) \(zone) , \(country)"
                            
                            print("direccion is  : \(placemark?.name! ?? "none")" )
                            print("postal Code : \(zone)" )
                            print("country is : \(country)")
                            print("locality is : \(placemark?.locality! ?? "none")")
                            
                            print("ISOcountryCode is : \(placemark?.isoCountryCode! ?? "none")")
                            
                            handler(nil, CurrentGpsModel(addressComplete: AddressComplete, zone: zone, state: estado, city: ciudad, latitude: latitude, longitude: longitude))
                            
                        } else {
                            print("Error in capture geocode no se pudo obtener la direccion")
                            
                            
                            let options = GeofencingOptions(circleWithCenter:location2d, radius: 100)

                            SwiftLocation.geofenceWith(options).then {
                                result in
                                guard let event = result.data else { return }

                                switch event {
                                case .didEnteredRegion(let r):
                                    print("Triggered region entering! \(r)")
                                case .didExitedRegion(let r):
                                    print("Triggered region exiting! \(r)")
                                default:
                                    break
                                }

                                
                            }
                            
                        }
                    })
                  } else {
                    print("Get Location failed \(getLocation.didFailWithError.debugDescription)")
                  }
            }
            
            
            
//
//            SwiftLocation.gpsLocation().then {
//                guard let latitude  =  $0.location?.coordinate.latitude else {
//                    print("no found the latitude")
//                    handler("no found the latitude",nil)
//                    return
//                }
//                guard let longitude =  $0.location?.coordinate.longitude else {
//                    print("no found the longitude")
//                    handler("no found the longitude",nil)
//                    return
//                }
//
//
//
//            }
            
            
           
        }
        
    }
    
    
    
     
    
}

