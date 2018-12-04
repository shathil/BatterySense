//
//  BatterySenseConstants.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 07/03/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    static let batteryWidth = 200.0
    static let chargingMaxSOC : Int = 80
    static let puCurrent = 470 //mA
    static let SQLITE_STATIC = unsafeBitCast(0, sqlite3_destructor_type.self)
    static let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    static let onePercent: Int = 36
    
    static let screenWidth = UIScreen.mainScreen().bounds.width
    static let screenHeight = UIScreen.mainScreen().bounds.height
    
    static let batterySenseDB = "batterysense.sqlite"
    static let chargingTable = "cahrging"
    static let batteryTable = "battery"
    static let locationTable = "clocation"

    
    
    /* This will be  fixed. later on we can add more columns based on requirement. The id in the first table represents the
    timestamp */
    
    

    static let  chargingColumns : [String] = ["timestamp integer primary key", "localtime text", "batterylevel integer", "rate real", "chargingevent integer"]
    

    
    /* The id in the second table represents the charging event id which is a incremental primary key */
    static let  batteryColumns : [String] = ["chargingevent integer primary key", "timestamp integer", "localtime text","beginlevel integer", "endlevel integer", "ccphase integer", "batterycapacity integer", "acrate real", "usbrate real", "chargingcycle integer", "charger text"]
    
}
