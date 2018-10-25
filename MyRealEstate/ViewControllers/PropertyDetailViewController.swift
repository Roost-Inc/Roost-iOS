//
//  PropertyDetailViewController.swift
//  MyRealEstate
//
//  Created by Raz Friman on 10/20/15.
//  Copyright © 2015 Raz Friman. All rights reserved.
//

import UIKit
import MapKit

class PropertyDetailViewController: UIViewController {
    
    var property: Property? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if property != nil {
            
            titleLabel.text = property!.title
            addressLabel.text = property!.address
            cityLabel.text = property!.city
            valueLabel.text = "\(property!.value)"
            totalRentPaidLabel.text = "\(property!.totalRentPaid)"
            monthsPaidLabel.text = "\(property!.monthsPaid)"
            rentPaymentLabel.text = "\(property!.rentPayment)"
            returnOnInvestmentLabel.text = "\(property!.returnOnInvestment)"
            dateLastPaidLabel.text = property!.dateLastPaid
            
            request(.GET, property!.image).response { (request, response, data, error) in
                self.imageView.image = UIImage(data: data!, scale:1)
            }
            
            let address = property!.address
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
                
                if let placemark = placemarks?[0] {
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    self.centerMapOnLocation(placemark.location!)
                }
            }
        }
        
        
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var totalRentPaidLabel: UILabel!
    @IBOutlet weak var monthsPaidLabel: UILabel!
    @IBOutlet weak var rentPaymentLabel: UILabel!
    @IBOutlet weak var returnOnInvestmentLabel: UILabel!
    @IBOutlet weak var dateLastPaidLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mapView: MKMapView!

    // TODO: TENANT INFO??
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}