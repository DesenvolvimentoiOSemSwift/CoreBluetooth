//
//  ViewController.swift
//  BeaconTrasmitter
//
//  Created by Maurício T. Zaquia on 8/11/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

let uuid = NSUUID(UUIDString: "1A8D83AD-44EC-42F9-A5A9-989B2477D800")
let identifier = "beacon.identifier"

class ViewController: UIViewController, CBPeripheralManagerDelegate {

	var peripheralManager: CBPeripheralManager?
	var beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 2, minor: 1, identifier: identifier)

	override func viewDidLoad() {
		super.viewDidLoad()
		peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())

		var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "changeRegion", userInfo: nil, repeats: true)
	}

	//MARK: CBPeripheralDelegate
	func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
		switch (peripheral.state) {
			case .PoweredOn:
				var peripheralData = beaconRegion.peripheralDataWithMeasuredPower(-59)
				peripheralManager!.startAdvertising(peripheralData)
			default:
				break
		}
	}

	func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
		println("Peripheral started with error: \(error?.localizedDescription)")
	}

	func changeRegion() {
		var nextMajor = Int(beaconRegion.major) + 2 as UInt16
		var nextMinor = Int(beaconRegion.major) + 1 as UInt16
		beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: nextMajor, minor: nextMinor, identifier: identifier)
	}

}

