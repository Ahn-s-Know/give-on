import Foundation
import CoreLocation

class FarmLocationRegistrationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var searchText = ""
    @Published var selectedLocation = ""
    @Published var currentLocation: CLLocationCoordinate2D?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    func searchAddress(_ query: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { [weak self] placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                self?.currentLocation = location.coordinate
                self?.selectedLocation = query
            }
        }
    }

    func confirmLocation() {
        // Implementation for confirming location
    }
}
