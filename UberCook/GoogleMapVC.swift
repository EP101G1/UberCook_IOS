//
//  GoogleMapVC.swift
//  UberCook
//
//  Created by Kira on 2020/9/15.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class GoogleMapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager: CLLocationManager!
    var permissionFlag: Bool!
    var currentLocation: CLLocation!
    var chefLocation: CLLocationCoordinate2D!
    var googleMaps: GMSMapView!
    let userDefault = UserDefaults()
    var address: String!
    var latitude : Double!
    var longitude : Double!
    var message : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        addSocketCallBacks()
    }
    
    //socket : receive chef currentLocation
    func addSocketCallBacks() {
        GlobalVariables.shared.socket.onText = { [self] (text: String) in
            if let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: text.data(using: .utf8)!) {
                //                let sender = chatMessage.sender
                let type = chatMessage.type
                if type == "map"{
                    latitude = Double (chatMessage.message.prefix(0))
                    longitude = Double(chatMessage.message.suffix(1))
                    
                    if chefLocation != nil {
                        googleMaps.clear()
                    }else{
                        chefLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let marker = GMSMarker()
                        marker.position = self.chefLocation
                        marker.title = "chefLocation"
                        marker.map = self.googleMaps
                    }
                    
                }
            }
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        googleMaps.camera = camera
        googleMaps.mapType = .normal
        //        print(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
        return true
    }
    
    func recenterMaps(){
        googleMaps = GMSMapView(frame: self.mapView.frame)
        googleMaps.settings.scrollGestures = true
        googleMaps.settings.zoomGestures = true
        googleMaps.settings.myLocationButton = true
        googleMaps.isMyLocationEnabled = true
        view.addSubview(googleMaps)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        googleMaps.camera = camera
        googleMaps.mapType = .normal
        googleMaps.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("EROOR \(error)")
        
        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted{
            redirectToSettings()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status{
        
        case .authorizedAlways:
            if manager.location != nil{
                self.permissionFlag = true
                self.currentLocation = manager.location
                recenterMaps()
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            break
            
        case .authorizedWhenInUse:
            if manager.location != nil{
                self.permissionFlag = true
                self.currentLocation = manager.location
                recenterMaps()
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            break
            
        case .notDetermined:
            self.permissionFlag = false
            redirectToSettings()
            break
            
        case .denied:
            self.permissionFlag = false
            redirectToSettings()
            break
            
        case .restricted:
            self.permissionFlag = false
            redirectToSettings()
            break
            
        default:
            print("ERROR_TRY_AGAIN_LATER")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
    }
    
    func redirectToSettings(){
        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted{
            self.permissionFlag = false
            let alertController = UIAlertController(title: "Location Access Denied or Restricted",
                                                    message: "Please enable location and try again",
                                                    preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
                if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: { _ in
                        })
                        self.dismiss(animated: true, completion: nil)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.clear()
                    } else {
                        UIApplication.shared.openURL(appSettings as URL)
                        self.dismiss(animated: true, completion: nil)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.clear()
                    }
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                _ in
                self.dismiss(animated: true, completion: {
                    print("DISMISSING_VIEWCONTROLLER")
                })
            })
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
