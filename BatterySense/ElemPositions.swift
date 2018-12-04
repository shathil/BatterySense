//
//  ElemPositions.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 14/02/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import Foundation

class ElemDiagonalPositions{

    let smallest = 5
    var screenWidth : Float = 0.0
    var screenHeight : Float = 0.0
    
    init(width : Float, height : Float){
    
        screenHeight = height
        screenWidth = width
    }

    
    func getFirstPosition () -> (Float, Float){
        
      return (screenWidth * 0.25, screenHeight * 0.15)
    }

    func getSecondPosition () -> (Float, Float){

        return (screenWidth * 0.5, screenHeight * 0.5)
    }
    
    
    func getThirdPosition () -> (Float, Float){
        
        return (screenWidth * 0.75,screenHeight*0.85)
    }

}