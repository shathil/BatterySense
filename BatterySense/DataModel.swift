//
//  DataModel.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 20/02/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import Foundation


class ChargingData : NSObject {

    
    var timestamp : Int64 = 0
    var localtime : String = ""
    var batterylevel : Int = 0
    var rate : Float = 0.0
    var chargingevent : Int = 0
    
}

class BatteryData : NSObject{
    
    // Cahrger 0 -- USB
    // Charger 1 -- AC
    
    var chargingevent : Int = 0
    var timestamp : Int64 = 0
    var localtime : String = ""
    var beginlevel : Int = 0
    var endlevel : Int = 0
    var ccphase : Int = 0
    var batterycapacity : Int = 0
    var acrate : Float = 0.0
    var usbrate : Float = 0.0
    var chargingcycle : Int = 0
    var charger : String = ""
}


class LocationData : NSObject{
    var chargingevent : Int = 0
    var speed : Int = 0
    var coordinates : Int = 0
}