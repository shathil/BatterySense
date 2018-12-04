//
//  BatteryProperty.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 31/01/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import Foundation

class BatteryProperty{
    var model = ""
    var batteryCapacity = [String:Int]()
    //var batteryCoefficients = [String : coefficients]()
    var batteryModels = [String: Int]()
    let oneLoss = 25
    let displayOne = 50 //mA
    let displayTwo = 50 //mA
    let displayThree = 100 //mA
    init (mod : String){
        self.model = mod
        initBatteryCapacity()
        //initBatteryCoefficients()
        initModelChargerCurrent()
        
    }
    
    

    func getBatteryCapacity() -> Int{
        var capacity : Int = 0
        if (batteryCapacity[self.model] != nil){
            capacity = batteryCapacity[self.model]!
        }
        
        return capacity
    }
    
    func getChargingCurrent() -> Int{

        var current : Int = 0
        if (batteryModels[self.model] != nil){
            current = batteryModels[self.model]!
        }
        
        
        return current
        

    }
    
    /*
    func getBatteryCoffecents() -> coefficients{
        
       
        var newcoff : coefficients = coefficients(aa: 0,bb: 0,cc: 0,dd: 0, rn: 0)
        
        if (batteryCoefficients[self.model] != nil){
            newcoff = batteryCoefficients[self.model]!
        }
        
        
        return newcoff
    }*/
    
    func getBatteryCrate() -> Double{
    
         return Double(getChargingCurrent()) / Double(getBatteryCapacity())
    }
    
    
    func getPresentBatteryCapacity (nowRate  : Double ) -> Int{
    
         return  Int(Double(self.getBatteryCapacity()) * (getBatteryCrate()/nowRate))
    }
    
    
    func cyclesNow(loss : Double) -> Int {
        
        
        let cycles = Int (Double(oneLoss) * loss)
        return cycles
    }

    
    func initBatteryCapacity()
    {
        
        batteryCapacity.updateValue(1030, forKey: "iPod5,1")
        batteryCapacity.updateValue(1043, forKey: "iPod7,1")
        batteryCapacity.updateValue(1420, forKey: "iPhone3,1")
        batteryCapacity.updateValue(1420, forKey: "iPhone3,2")
        batteryCapacity.updateValue(1420, forKey: "iPhone3,3")
        batteryCapacity.updateValue(1432, forKey: "iPhone4,1")
        batteryCapacity.updateValue(1440, forKey: "iPhone5,1")
        batteryCapacity.updateValue(1440, forKey: "iPhone5,2")
        batteryCapacity.updateValue(1510, forKey: "iPhone5,3")
        batteryCapacity.updateValue(1510, forKey: "iPhone5,4")
        
        batteryCapacity.updateValue(1560, forKey: "iPhone6,1")
        batteryCapacity.updateValue(1560, forKey: "iPhone6,2")
        
        batteryCapacity.updateValue(2915, forKey: "iPhone7,1")
        batteryCapacity.updateValue(1810, forKey: "iPhone7,2")
        
        batteryCapacity.updateValue(1715, forKey: "iPhone8,1")
        batteryCapacity.updateValue(2750, forKey: "iPhone8,2")
        
        
        batteryCapacity.updateValue(6930, forKey: "iPad2,1")
        batteryCapacity.updateValue(6930, forKey: "iPad2,2")
        batteryCapacity.updateValue(6930, forKey: "iPad2,3")
        batteryCapacity.updateValue(6930, forKey: "iPad2,4")
        
        batteryCapacity.updateValue(11560, forKey: "iPad3,1")
        batteryCapacity.updateValue(11560, forKey: "iPad3,2")
        batteryCapacity.updateValue(11560, forKey: "iPad3,3")
        batteryCapacity.updateValue(11560, forKey: "iPad3,4")
        batteryCapacity.updateValue(11560, forKey: "iPad3,5")
        batteryCapacity.updateValue(11560, forKey: "iPad3,6")
        
        
        batteryCapacity.updateValue(8820, forKey: "iPad4,1")
        batteryCapacity.updateValue(8820, forKey: "iPad4,2")
        batteryCapacity.updateValue(8820, forKey: "iPad4,3")
        batteryCapacity.updateValue(8820, forKey: "iPad5,3")
        batteryCapacity.updateValue(8820, forKey: "iPad5,4")
        
        
        batteryCapacity.updateValue(4490, forKey: "iPad2,5")
        batteryCapacity.updateValue(4490, forKey: "iPad2,6")
        batteryCapacity.updateValue(4490, forKey: "iPad2,7")
        
        batteryCapacity.updateValue(6470, forKey: "iPad4,4")
        batteryCapacity.updateValue(6470, forKey: "iPad4,5")
        batteryCapacity.updateValue(6470, forKey: "iPad4,6")
        
        batteryCapacity.updateValue(6470, forKey: "iPad4,7")
        batteryCapacity.updateValue(6470, forKey: "iPad4,8")
        batteryCapacity.updateValue(6470, forKey: "iPad4,9")
        
        batteryCapacity.updateValue(5124, forKey: "iPad5,1")
        batteryCapacity.updateValue(5124, forKey: "iPad5,2")
        
        batteryCapacity.updateValue(10307, forKey: "iPad6,7")
        batteryCapacity.updateValue(10307, forKey: "iPad6,8")
    }
    
    /*
    func initBatteryCoefficients(){
    
        
        
        var newcoff : coefficients = coefficients(aa: 0,bb: 0,cc: 0,dd: 0, rn: 0)
    
        




        //batteryCoefficients.updateValue(1030, forKey: "iPod5,1")
      //  batteryCoefficients.updateValue(1043, forKey: "iPod7,1")
        
        
        /*iphone 3.1-4.1
        a =       720.6  (714, 727.2)
        b =      -2.171  (-2.199, -2.143)
        c =       693.3  (686, 700.6)
        d =     -0.3217  (-0.326, -0.3175)
        */
        
        newcoff = coefficients(aa: 720.6, bb: -2.171 , cc: 693.3, dd: -0.3217, rn: 0)

        batteryCoefficients.updateValue(newcoff, forKey: "iPhone3,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone3,2")
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone3,3")
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone4,1")
        
        /*iphone 5
        a =       734.3  (727.6, 741)
        b =      -2.191  (-2.22, -2.163)
        c =       699.7  (692.3, 707.1)
        d =      -0.324  (-0.3283, -0.3197)
        */
        
        newcoff = coefficients(aa: 734.3, bb: -2.191 , cc: 699.7, dd: -0.324, rn: 0.69)


        batteryCoefficients.updateValue(newcoff, forKey: "iPhone5,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone5,2")
        
        
        //5c
        /*iphone 5C 1510
        a =       778.4  (771.3, 785.5)
        b =      -2.254  (-2.284, -2.224)
        c =       719.7  (711.8, 727.6)
        d =     -0.3312  (-0.3357, -0.3266)
        */
        newcoff = coefficients(aa: 778.4, bb: -2.254 , cc: 719.7, dd: -0.3312, rn: 0.66)
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone5,3")
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone5,4")
        
        //5s
        /*iphone 6,1. 6,2 1560
        a =       810.3  (802.8, 817.7)
        b =      -2.299  (-2.33, -2.268)
        c =       733.8  (725.6, 742.1)
        d =     -0.3361  (-0.3408, -0.3315)
        */
        
        newcoff = coefficients(aa: 810.3, bb: -2.299, cc:  733.8, dd: -0.3361, rn: 0.64)
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone6,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone6,2")
        
        //iphone6plus 2915 iphone 7,1
        /*iphone 6Plus
        a =        1794  (1776, 1812)
        b =      -3.447  (-3.511, -3.383)
        c =        1071  (1052, 1090)
        d =     -0.4487  (-0.4576, -0.4398)
        */
        
        newcoff = coefficients(aa: 1794, bb: -3.447, cc: 1071, dd: -0.4487, rn: 0.34)
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone7,1")
        
        /*iphone 7.2 1810
        a =       985.4  (976.3, 994.6)
        b =      -2.532  (-2.569, -2.495)
        c =       806.2  (796.1, 816.3)
        d =     -0.3613  (-0.3668, -0.3559)
        */

        newcoff = coefficients(aa: 985.4, bb: -2.532, cc: 806.2, dd: -0.3613, rn: 0.55)
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone7,2")
        
        
        /*iphone 8,1
        a =       920.5  (912, 928.9)
        b =      -2.448  (-2.483, -2.413)
        c =       780.3  (770.9, 789.7)
        d =     -0.3524  (-0.3576, -0.3472)
        
        */

        newcoff = coefficients(aa: 920.5, bb: (-2.448), cc: 780.3, dd: -0.3524, rn: 0.58)
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone8,1")
        
        /*iphone 8,2
        a =        1674  (1657, 1690)
        b =      -3.322  (-3.382, -3.262)
        c =        1036  (1019, 1054)
        d =     -0.4377  (-0.4461, -0.4292)
        */
        newcoff = coefficients(aa: 1674, bb: (-3.322), cc: 1036, dd: -0.4377, rn: 0.36)
        batteryCoefficients.updateValue(newcoff, forKey: "iPhone8,2")
        
        
        /*ipad2,1;2,2;2,3;2,4
        a =        4327  (4284, 4371)
        b =      -3.716  (-3.789, -3.644)
        c =        2401  (2356, 2446)
        d =     -0.4716  (-0.4816, -0.4616)
        
        */
        newcoff  = coefficients(aa: 4327,bb: (-3.716),cc: 2401,dd: (-0.4716), rn: 0.3)
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,2")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,3")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,4")

        /*ipad 3.1,3.2,3.3
        a =        7834  (7741, 7927)
        b =      -5.239  (-5.365, -5.113)
        c =        3193  (3112, 3274)
        d =     -0.5855  (-0.6018, -0.5693)
        
        */
        newcoff  = coefficients(aa: 7834,bb: (-5.239),cc: 3193, dd: (-0.5855), rn: 0.18)
        batteryCoefficients.updateValue(newcoff, forKey: "iPad3,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad3,2")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad3,3")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad3,4")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad3,5")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad3,6")
        

        /*ipad 4.1,4.2,4.3
        a =        5698  (5637, 5760)
        b =      -4.338  (-4.431, -4.244)
        c =        2737  (2678, 2797)
        d =     -0.5209  (-0.5334, -0.5083)
        
        */
        newcoff  = coefficients(aa: 5698,bb: (-4.338),cc: 2737, dd: (-0.5209), rn: 0.24)
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,2")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,3")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad5,3")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad5,4")
        
        
        /*ipad 2.5,2.6,2.7 --- 4490
        a =        2526  (2503, 2550)
        b =      -2.799  (-2.843, -2.754)
        c =        1862  (1836, 1888)
        d =     -0.3886  (-0.395, -0.3821)
        
        */
        
        newcoff  = coefficients(aa: 2526, bb: (-2.799), cc: 1862, dd: (-0.3886), rn: 0.47)
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,5")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,6")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad2,7")
        
        /*iPad4,4  6470
        a =        4053  (4013, 4094)
        b =      -3.586  (-3.654, -3.518)
        c =        2328  (2286, 2370)
        d =     -0.4607  (-0.4701, -0.4512)
        
        */

        newcoff  = coefficients(aa: 4053, bb: (-3.586), cc: 2328, dd: (-0.4607), rn: 0.32)
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,4")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,5")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,6")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,7")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,8")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad4,9")
        
        
        /*iPad51 --- 5124
        a =        2996  (2967, 3024)
        b =      -3.054  (-3.106, -3.003)
        c =        2018  (1987, 2049)
        d =     -0.4132  (-0.4207, -0.4058)
        
        */

        newcoff  = coefficients(aa: 2996, bb: (-3.054), cc: 2018, dd: (-0.4132), rn: 0.41)

        batteryCoefficients.updateValue(newcoff, forKey: "iPad5,1")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad5,2")
        
        /*iPad67 10307
        a =        6916  (6837, 6995)
        b =      -4.859  (-4.971, -4.747)
        c =        3005  (2933, 3077)
        d =     -0.5591  (-0.5738, -0.5444)
        
        */

        newcoff  = coefficients(aa: 6916, bb: (-4.859), cc: 3005, dd: (-0.5591), rn: 0.20)
        batteryCoefficients.updateValue(newcoff, forKey: "iPad6,7")
        batteryCoefficients.updateValue(newcoff, forKey: "iPad6,8")

    
    }
    */
    
    func initModelChargerCurrent()
    {
        
        //batteryModels.updateValue("iPod Touch 5", forKey: "iPod5,1")
        //batteryModels.updateValue("iPod Touch 6", forKey: "iPod7,1")
        
        batteryModels.updateValue(925-displayOne, forKey: "iPhone3,1")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone3,2")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone3,3")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone4,1")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone5,1")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone5,2")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone5,3")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone5,4")
        
        batteryModels.updateValue(925-displayOne, forKey: "iPhone6,1")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone6,2")
        
        batteryModels.updateValue(925-displayOne, forKey: "iPhone7,1")
        batteryModels.updateValue(925-displayOne, forKey: "iPhone7,2")
        
        batteryModels.updateValue(925-displayTwo, forKey: "iPhone8,1")
        batteryModels.updateValue(925-displayTwo, forKey: "iPhone8,2")
        
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,1")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,2")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,3")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,4")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad3,1")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad3,2")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad3,3")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad3,4")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad3,5")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad3,6")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,1")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,2")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,3")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad5,3")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad5,4")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,5")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,6")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad2,7")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,4")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,5")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,6")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,7")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,8")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad4,9")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad5,1")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad5,2")
        
        batteryModels.updateValue(2100-displayThree, forKey: "iPad6,7")
        batteryModels.updateValue(2100-displayThree, forKey: "iPad6,8")
        
    }

}