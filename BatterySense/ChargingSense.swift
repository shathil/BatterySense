//
//  ChargingSense.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 31/01/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//
//


/* 
    This class is to find the charging anomalies
*/

import Foundation


class coefficients {
    var a = 0.0
    var b = 0.0
    var c = 0.0
    var d = 0.0
    var r = 0.0
    
    let oneLoss : Int = 25 // %cycles
    
    init (aa: Double, bb: Double, cc: Double, dd: Double, rn: Double) {
        self.a   = aa
        self.b = bb
        self.c  = cc
        self.d = dd
        self.r = rn
    }
    
    
    
    func capacityNowExp(rinc : Double) -> Double{
        
        
        let capnow = a * exp(b * rinc) + c * exp(d * rinc)
        return capnow
    }

    
    func capacityNowRatio(fccnew : Int, rnow : Double) -> Double{
        
        
        let capnow = Double(self.r/rnow) * Double(fccnew)
        
        return capnow
    }

    func newBatteryRate () -> Double{
        return r
    }
    
    func cyclesNow(loss : Double) -> Int {
    
       
        let cycles = Int (Double(oneLoss) * loss)
        return cycles
    }
}
