//
//  DeviceSSense.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 31/01/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import Foundation

class DeviceSSense{
    
    
    static func getDeviceModel () ->String!{
    
        var systemInfo = [UInt8](count: sizeof(utsname), repeatedValue: 0)
        
        let model = systemInfo.withUnsafeMutableBufferPointer { (inout body: UnsafeMutableBufferPointer<UInt8>) -> String? in
            if uname(UnsafeMutablePointer(body.baseAddress)) != 0 {
                return nil
            }
            return String.fromCString(UnsafePointer(body.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))))
        }
        
        return model
    }
    
    
    static func getReadableModelName(device:String)->String!
    {
        var model = "unknown"
        var batteryModels = [String: String]()
        
        //batteryModels.updateValue("iPod Touch 5", forKey: "iPod5,1")
        //batteryModels.updateValue("iPod Touch 6", forKey: "iPod7,1")
        batteryModels.updateValue("iPhone 4", forKey: "iPhone3,1")
        batteryModels.updateValue("iPhone 4", forKey: "iPhone3,2")
        batteryModels.updateValue("iPhone 4", forKey: "iPhone3,3")
        batteryModels.updateValue("iPhone 4s", forKey: "iPhone4,1")
        
        batteryModels.updateValue("iPhone 5", forKey: "iPhone5,1")
        batteryModels.updateValue("iPhone 5", forKey: "iPhone5,2")
        batteryModels.updateValue("iPhone 5c", forKey: "iPhone5,3")
        batteryModels.updateValue("iPhone 5c", forKey: "iPhone5,4")
        
        batteryModels.updateValue("iPhone 5s", forKey: "iPhone6,1")
        batteryModels.updateValue("iPhone 5s", forKey: "iPhone6,2")
        
        batteryModels.updateValue("iPhone 6 Plus", forKey: "iPhone7,1")
        batteryModels.updateValue("iPhone 6", forKey: "iPhone7,2")
        
        batteryModels.updateValue("iPhone 6s", forKey: "iPhone8,1")
        batteryModels.updateValue("iPhone 6s Plus", forKey: "iPhone8,2")
        
        
        batteryModels.updateValue("iPad 2", forKey: "iPad2,1")
        batteryModels.updateValue("iPad 2", forKey: "iPad2,2")
        batteryModels.updateValue("iPad 2", forKey: "iPad2,3")
        batteryModels.updateValue("iPad 2", forKey: "iPad2,4")
        
        batteryModels.updateValue("iPad 3", forKey: "iPad3,1")
        batteryModels.updateValue("iPad 3", forKey: "iPad3,2")
        batteryModels.updateValue("iPad 3", forKey: "iPad3,3")
        
        batteryModels.updateValue("iPad 4", forKey: "iPad3,4")
        batteryModels.updateValue("iPad 4", forKey: "iPad3,5")
        batteryModels.updateValue("iPad 4", forKey: "iPad3,6")
        
        batteryModels.updateValue("iPad Air", forKey: "iPad4,1")
        batteryModels.updateValue("iPad Air", forKey: "iPad4,2")
        batteryModels.updateValue("iPad Air", forKey: "iPad4,3")
        
        batteryModels.updateValue("iPad Air 2", forKey: "iPad5,3")
        batteryModels.updateValue("iPad Air 2", forKey: "iPad5,4")
        
        batteryModels.updateValue("iPad Mini", forKey: "iPad2,5")
        batteryModels.updateValue("iPad Mini", forKey: "iPad2,6")
        batteryModels.updateValue("iPad Mini", forKey: "iPad2,7")
        
        batteryModels.updateValue("iPad Mini 2", forKey: "iPad4,4")
        batteryModels.updateValue("iPad Mini 2", forKey: "iPad4,5")
        batteryModels.updateValue("iPad Mini 2", forKey: "iPad4,6")
        
        batteryModels.updateValue("iPad Mini 3", forKey: "iPad4,7")
        batteryModels.updateValue("iPad Mini 3", forKey: "iPad4,8")
        batteryModels.updateValue("iPad Mini 3", forKey: "iPad4,9")
        
        batteryModels.updateValue("iPad Mini 4", forKey: "iPad5,1")
        batteryModels.updateValue("iPad Mini 4", forKey: "iPad5,2")
        
        batteryModels.updateValue("iPad Pro", forKey: "iPad6,7")
        batteryModels.updateValue("iPad Pro", forKey: "iPad6,8")
        
        if (batteryModels[device] != nil){
            model = batteryModels[device]!
        }
        
        
        return model
        
    }
    
    
    


}