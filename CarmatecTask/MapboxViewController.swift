//
//  ViewController.swift
//  CarmatecTask
//
//  Created by Jayantkarthic on 08/05/24.
//

import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxMaps
import Turf
import FirebaseCore
import FirebaseDatabase

// Step 2: Define a structure or class to represent your data
struct Location {
    let currentlatitude: Double
    let currentlongitude: Double
    let currentaddress: String
    let endLatitude : Double
    let endLongitude : Double
    let endAddress : String
    
    // Convert location to dictionary for Firebase
    func toDictionary() -> [String: Any] {
        return ["currentlatitude": currentlatitude,
                "currentlongitude": currentlongitude,
                "currentaddress": currentaddress,
                "endLatitude" : endLatitude,
                "endLongitude" : endLongitude,
                "endAddress" : endAddress
                
        ]
    }
}



class MapboxViewController: UIViewController {

    var navigationMapView: NavigationMapView!
    var navigationViewController: NavigationViewController!
    var routeOptions: NavigationRouteOptions?
    var routeResponse: RouteResponse?
    var startButton: UIButton!
    
    
    @IBOutlet weak var zoomoutBtn: UIButton!
    @IBOutlet weak var zoomInBtn: UIButton!

    let ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSetup()
 
    }
  

    // Step 4: Store latitude and longitude coordinates
    func saveLocationToFirebase(latitude: Double, longitude: Double,address:String,endLatitude : Double,endlongitude : Double,endAddress : String) {
        let location = Location(currentlatitude: latitude, currentlongitude: longitude, currentaddress: address,endLatitude: endLatitude,endLongitude: endlongitude,endAddress: endAddress)
        ref.child("locations").childByAutoId().setValue(location.toDictionary()) { error, _ in
            if let error = error {
                print("Error adding location to Firebase: \(error.localizedDescription)")
            } else {
                print("Location added successfully!")
            }
        }
    }

    
    
    func uiSetup(){
        navigationMapView = NavigationMapView(frame: view.bounds)
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navigationMapView)
        
        let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
        navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        
        navigationMapView.userLocationStyle = .puck2D()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        navigationMapView.addGestureRecognizer(longPress)
        
        displayStartButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButton.layer.cornerRadius = startButton.bounds.midY
        startButton.clipsToBounds = true
        startButton.setNeedsDisplay()
    }
    
    func displayStartButton() {
        startButton = UIButton()
        
        startButton.setTitle("Start Navigation", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = .blue
        startButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        startButton.addTarget(self, action: #selector(tappedButton(sender:)), for: .touchUpInside)
        startButton.isHidden = true
        view.addSubview(startButton)
        
        startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.setNeedsLayout()
    }
    // MARK:  Long Presee
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let point = sender.location(in: navigationMapView)
        let coordinate = navigationMapView.mapView.mapboxMap.coordinate(for: point)
     
        
        if let origin = navigationMapView.mapView.location.latestLocation?.coordinate {
            calculateRoute(from: origin, to: coordinate)
            // Example usage
            let latitude = 37.7749 // Example latitude value
            let longitude = -122.4194 // Example longitude value
            
            getAddressFromLatLon(latitude: origin.latitude, longitude: origin.longitude) { address in
                if let address = address {
                    self.getAddressFromLatLon(latitude: coordinate.latitude, longitude: coordinate.longitude) { endaddress in
                        if let endaddress = endaddress {
                         
                    print("EndAddress: \(endaddress)")
                    print("Address: \(address)")
                    self.saveLocationToFirebase(latitude: origin.latitude, longitude: origin.longitude, address: address,endLatitude: coordinate.latitude,endlongitude: coordinate.longitude,endAddress: endaddress)
                        }
                    }
                    
                } else {
                    print("Failed to get address.")
                }
            }
            
        } else {
            print("Failed to get user location, make sure to allow location access for this application.")
        }
    }

    // Define a function to get address from latitude and longitude
    func getAddressFromLatLon(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Reverse geocoding failed with error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let address = "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                completion(address)
            } else {
                print("No placemarks found.")
                completion(nil)
            }
        }
    }
    
    @objc func tappedButton(sender: UIButton) {
        guard let routeResponse = routeResponse, let navigationRouteOptions = routeOptions else { return }
        
        navigationViewController = NavigationViewController(for: routeResponse, routeIndex: 0,
                                                            routeOptions: navigationRouteOptions)
        navigationViewController.modalPresentationStyle = .fullScreen
        
        present(navigationViewController, animated: true, completion: nil)
    }
    // MARK:  Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
                
                strongSelf.routeResponse = response
                strongSelf.routeOptions = routeOptions
                strongSelf.startButton?.isHidden = false
                strongSelf.drawRoute(route: route)
                strongSelf.navigationMapView.showWaypoints(on: route)
            }
        }
    }
    // MARK:  Draw Route
    func drawRoute(route: Route) {
        guard let routeShape = route.shape, routeShape.coordinates.count > 0 else { return }
        guard let mapView = navigationMapView.mapView else { return }
        let sourceIdentifier = "routeStyle"
        
        let feature = Feature(geometry: .lineString(LineString(routeShape.coordinates)))
        
        if mapView.mapboxMap.style.sourceExists(withId: sourceIdentifier) {
            try? mapView.mapboxMap.style.updateGeoJSONSource(withId: sourceIdentifier, geoJSON: .feature(feature))
        } else {
            var geoJSONSource = GeoJSONSource()
            geoJSONSource.data = .feature(feature)
            try? mapView.mapboxMap.style.addSource(geoJSONSource, id: sourceIdentifier)
            
            var lineLayer = LineLayer(id: "routeLayer")
            lineLayer.source = sourceIdentifier
            lineLayer.lineColor = .constant(.init(UIColor(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 2.0)))
            lineLayer.lineWidth = .constant(3)
            
            try? mapView.mapboxMap.style.addLayer(lineLayer)
        }
    }
    
    @IBAction func zoomOutAction(_ sender: Any) {
        print("zoomout pressed")
        // Example usage
//        let latitude = 37.7749 // Example latitude value
//        let longitude = -122.4194 // Example longitude value
//        saveLocationToFirebase(latitude: latitude, longitude: longitude, address: "")

        
        
    }
    @IBAction func zoomInAction(_ sender: Any) {
        print("zoomin pressed")
    }
}
