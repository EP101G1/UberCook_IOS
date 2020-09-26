//
//  ChefGoogleMapVC.swift
//  UberCook
//
//  Created by Kathy Huang on 2020/9/16.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class ChefGoogleMapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {
    @IBOutlet weak var mapView: UIView!
    var locationManager: CLLocationManager!
    var permissionFlag: Bool!
    var currentLocation: CLLocation!
    var googleMaps: GMSMapView!
    var origin: CLLocationCoordinate2D!
    var destination: CLLocationCoordinate2D!
    var geocoder : CLGeocoder!
    let userDefault = UserDefaults()
    var address: String!
    var latitude : Double!
    var longitude : Double!
    var message : String!
    var customer_User_no : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geocoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    //        @IBAction func Direct(_ sender: Any) {
    //            //saddr：設定路線搜尋的的起點,如果值是空白,則會使用使用者的目前位置
    //            //daddr：設定路線搜尋的終點
    //            let url = URL(string: "comgooglemaps://?saddr=&daddr=\(destination.latitude),\(destination.longitude)&directionsmode=driving")
    //
    //            if UIApplication.shared.canOpenURL(url!) {
    //                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    //            } else {
    //                // 若手機沒安裝 Google Map App 則導到 App Store(id443904275 為 Google Map App 的 ID)
    //                let appStoreGoogleMapURL = URL(string: "itms-apps://itunes.apple.com/app/id585027354")!
    //                UIApplication.shared.open(appStoreGoogleMapURL, options: [:], completionHandler: nil)
    //            }
    //        }
    
    //show myLocation
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
        
        //        self.destination = CLLocationCoordinate2D(latitude: 24.9667468, longitude: 121.1900786)
        //        let marker = GMSMarker()
        //        marker.position = self.destination
        //        marker.title = "destination"
        //        marker.map = self.googleMaps
        
        
        address = userDefault.value(forKey: "custom_adrs") as? String
        //        print("========address : \(address ?? "no detail")")
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if placemarks != nil && placemarks!.count > 0 {
                
                if let placemark = placemarks!.first {
                    
                    if let coordinate = placemark.location?.coordinate {
                        
                        self.destination = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        
                        let marker = GMSMarker()
                        marker.position = self.destination
                        marker.title = "destination"
                        self.getPath()
                    }
                }
            }
        }
        
        
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
        SendReadChatMessage()
    }
    
    //socket : chef send currentLocation to user
    
    func SendReadChatMessage(){
        let customer_User_no = userDefault.value(forKey: "customer_User_no") as! String
        let message = String(currentLocation.coordinate.latitude)+","
            + String(currentLocation.coordinate.longitude)
        let chatMessage = ChatMessage(chatRoom: 0,type: "map", sender: "", receiver: customer_User_no, message: message,read: "",base64: "",dateStr: "",myName: "")
        
        if let jsonData = try? JSONEncoder().encode(chatMessage) {
            let text = String(data: jsonData, encoding: .utf8)
            GlobalVariables.shared.socket.write(string: text!)
            // debug用
            print("send messages: \(text!)")
        }
    }
    
    
    func getPath(){
        if permissionFlag{
            let origin  = "\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)"
            let destination = "\(self.destination.latitude),\(self.destination.longitude)"
            let key = "AIzaSyCRK1Iozkdnpu9ojMqwEOTqduzz6SFDTtE"
            guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternatives=true&key=\(key)") else { return  }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            DispatchQueue.main.async {
                session.dataTask(with: url) { (data, response, error) in
                    guard data != nil else {
                        return
                    }
                    do {
                        
                        let route = try JSONDecoder().decode(MapPath.self, from: data!)
                        
                        if let points = route.routes?.first?.overview_polyline?.points {
                            self.drawPath(with: points)
                        }
                    } catch let error {
                        
                        print("Failed to draw ",error.localizedDescription)
                    }
                }.resume()
            }
        }
    }
    
    func drawPath(with points : String){
        
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5.0
            polyline.strokeColor = .red
            polyline.map = self.googleMaps
        }
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

