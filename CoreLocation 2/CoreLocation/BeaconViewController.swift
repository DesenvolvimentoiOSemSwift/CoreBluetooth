//
//  SecondViewController.swift
//  CoreLocation
//
//  Created by Maurício T Zaquia on 9/10/14.
//  Copyright (c) 2014 zaquia. All rights reserved.
//

import UIKit
import CoreLocation

let uuid = NSUUID(UUIDString: "1A8D83AD-44EC-42F9-A5A9-989B2477D800")
let identifier = "beacon.identifier"

class BeaconViewController: UIViewController , UITableViewDataSource , CLLocationManagerDelegate {

	@IBOutlet weak var tableView: UITableView!
	var beaconsFound: [CLBeacon] = [CLBeacon]()
	let locationManager = CLLocationManager()
	var beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: identifier)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewDidAppear(animated: Bool) {

		locationManager.delegate = self
		locationManager.startMonitoringForRegion(beaconRegion)

	}

	override func viewWillDisappear(animated: Bool) {
		locationManager.stopRangingBeaconsInRegion(beaconRegion)
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return beaconsFound.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let identifier = "BeaconCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell

		let majorLabel = cell.viewWithTag(1) as! UILabel
		let minorLabel = cell.viewWithTag(2) as! UILabel
		let distanceLabel = cell.viewWithTag(3) as! UILabel

		let beacon = beaconsFound[indexPath.row]
		majorLabel.text = String(format: "%ld", arguments: [beacon.major.integerValue])
		minorLabel.text = String(format: "%ld", arguments: [beacon.minor.integerValue])

		var proximity: String
		switch (beacon.proximity) {
		case .Far: proximity = "Far"
		case .Immediate: proximity = "Immediate"
		case .Near: proximity = "Near"
		case .Unknown: proximity = "Unknown"
		}

		distanceLabel.text = proximity

		return cell
	}

	func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
		locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
	}

	func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
		locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
	}

	func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {

		if (beacons.count > 0) {
			beaconsFound = beacons as [CLBeacon]
			tableView.reloadData()
		}

	}



}

