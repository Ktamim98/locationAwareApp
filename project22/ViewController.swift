//
//  ViewController.swift
//  project22
//
//  Created by Tamim Khan on 20/3/23.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    var loacationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loacationManager = CLLocationManager()
        loacationManager?.delegate = self
        loacationManager?.requestAlwaysAuthorization()
        
        
        view.backgroundColor = .gray
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "myBeacon")
        
        
        loacationManager?.startMonitoring(for: beaconRegion)
        loacationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    
    func update(distance: CLProximity){
        UIView.animate(withDuration: 0.8){
            switch distance{
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first{
            update(distance: beacon.proximity)
        }else{
            update(distance: .unknown)
        }
    }


}

