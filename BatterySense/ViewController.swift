//
//  ViewController.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 27/01/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let batteryCapacity = UILabel()
    let batteryState = UILabel()
    let chargeCycle = UILabel()
    
    var batcapLayer = CAShapeLayer()
    var batstatLayer = CAShapeLayer()
    var chargeLayer = CAShapeLayer()
    
    var textFontSize = 20.0
    var uiLabelSize : Float = 120.0
    
    var firstTime : Bool = true
    var chargingCount : Int = 0
    var db : COpaquePointer = nil
    var statement : COpaquePointer = nil
    var tableBool : Bool = false
    
    var modelName = ""
    var chargingState = 0
    var chargeLevel : Int = 0
    
    var lastBatteryUpdate : Int64 = 0
    var firstBatteryUpdate : Int64 = 0
    var firstBatteryUpdateTime : String = ""
    var lastBatteryLevel : Int = 0
    var firstBatteryLevel : Int = 0
    
    var mybat: BatteryProperty?
    var batteryCofs : coefficients?

    var presentCapacity : Int = 0
    var initialCapacity : Int = 0
    var chargerType = ""
    var chargingCycles = 0
    var ccPhaseLenght = 0
    
    var screenPosition : ElemDiagonalPositions?
    var batteryDB : sqliteaccess?
    
    
    var capList = [Int] ()
    var rateList = [CGFloat] ()
    var socList = [Int] ()
    
    var acchargingrate : Float = 0.0
    var usbchargingrate : Float = 0.0
    
    var deviceName : String = ""

    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    
    
    var locatioCallFlag = false
    var locationManager:CLLocationManager!
    var updateTimer: NSTimer?
    var backgroundTask: UIBackgroundTaskIdentifier?
    var chargingBackgroundTimer : NSTimeInterval = 180

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        //setBatteryCapacity
        

        
    }
    
    /* The initial notification when the user first installs and open the application */
    
    override func viewDidAppear(animated: Bool) {
        
        var powerSave = ""
        if NSProcessInfo.processInfo().lowPowerModeEnabled {
            powerSave = "Please Disbale the Low Power Mode in Settings -> Battery \r\n\r\n"
        }
        
        var locString = ""
        
        if CLLocationManager.locationServicesEnabled() == false {
            
            locString = "Location Service is Disabled. Enable Location Service in Settings -> Privacy \r\n\r\n"
            
        } else {
            
            
            let authorizationStatus : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if (authorizationStatus == CLAuthorizationStatus.Denied) || (authorizationStatus == CLAuthorizationStatus.Restricted) {
                
                locString = "Enable Location Service in Settings -> Privacy -> BatterySense -> Always \r\n\r\n"
            }
        }
    

        
        let msg = "1. Estimates Present Battery Capacity, and Charging Cycles while Charging.\r\n\r\n 2. Requires Location Service to collect battery level updates while charging. It does not store user locations.\r\n\r\n" +
        
            "3. Always charge from  5% to a higher battery level for better estimates and longer battery life. \r\n\r\n" + "SETTINGS \r\n\r\n"  +  locString + powerSave + "Connect the AC  charger of \(self.deviceName) with cable from Apple and TURN OFF the display. \r\n\r\n ***BatterySense Cannot be Used for Any Battery Replacement Porgram."
        
        let newAlert = UIAlertController(title: "BatterySense", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        newAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
           NSLog("Handle Ok logic here")
        
        }))
        
        self.presentViewController(newAlert, animated: true, completion: nil)
        

    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        /* This will construct the DB or get pointer to the DB*/
        //self.batteryDB = sqliteaccess(dbname: Constants.batterySenseDB)
        //self.batteryDB?.sqliteSelect(Constants.chargingColumns, tableName: Constants.batteryTable)
        //self.batteryDB?.sqliteDropTable(Constants.batteryTable)
        //self.batteryDB?.sqliteDropTable(Constants.chargingTable)
        //self.batteryDB?.sqliteCreateTable(Constants.chargingTable, columns: Constants.chargingColumns)
        //self.batteryDB?.sqliteCreateTable(Constants.batteryTable, columns: Constants.batteryColumns)
        
        
        
        
        
        //we can think of this later on
        
        
        
        
        
        self.view.backgroundColor = UIColor.blackColor()
        
        
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        self.backgroundTask = UIBackgroundTaskInvalid
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.batteryStateDidChange(_:)), name: UIDeviceBatteryStateDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.batteryLevelDidChange(_:)), name: UIDeviceBatteryLevelDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.batterySenseDidBecomeActive), name: UIApplicationDidBecomeActiveNotification , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.batterySenseDidEnterBackground), name: UIApplicationDidEnterBackgroundNotification , object: nil)
        
        
        
        self.screenPosition = ElemDiagonalPositions(width: Float (Constants.screenWidth), height: Float(Constants.screenHeight))
        
        
        
        
        self.uiLabelSize = Float(Constants.screenWidth)/3
        if(Constants.screenWidth > 320){
            self.textFontSize = 20
        }
        
        
        
        
        
        
        
        
        self.chargeLevel = Int (UIDevice.currentDevice().batteryLevel*100)
        self.chargingState = UIDevice.currentDevice().batteryState.rawValue
        self.lastBatteryLevel = self.chargeLevel
        
        
        
        
        
        
        
        self.modelName = DeviceSSense.getDeviceModel()!
        self.deviceName = DeviceSSense.getReadableModelName(self.modelName)
        self.mybat = BatteryProperty(mod: modelName)
        self.batteryCofs = self.mybat!.getBatteryCoffecents(modelName)
        self.initialCapacity = self.mybat!.getBatteryCapacity(modelName)
        
        
        var (x,y) = (screenPosition?.getSecondPosition())!
        batteryState.center = CGPointMake(CGFloat(x),CGFloat(y))
        (x,y) = (screenPosition?.getFirstPosition())!
        batteryCapacity.center = CGPointMake(CGFloat(x),CGFloat(y))
        (x,y) = (screenPosition?.getThirdPosition())!
        chargeCycle.center = CGPointMake(CGFloat(x),CGFloat(y))
        
        let circlePath = UIBezierPath(arcCenter: CGPointMake(view.frame.minX, view.frame.minY), radius:210, startAngle: 0.0, endAngle: CGFloat(M_PI/2), clockwise: true)
        
        
        

        let cirleLayer = CAShapeLayer()
        cirleLayer.path = circlePath.CGPath
        cirleLayer.fillColor = UIColor.clearColor().CGColor
        cirleLayer.strokeColor = UIColor.greenColor().CGColor
        cirleLayer.lineWidth = 5.0;
        cirleLayer.strokeEnd = 1.0
        
        
        
        
        let circlePath3 =  UIBezierPath(arcCenter: CGPointMake(135,135), radius: 220, startAngle: CGFloat(M_PI), endAngle: CGFloat (M_PI*3 / 2), clockwise: true)
        

        
        NSLog("Coordinmates \(view.frame.maxX,view.frame.maxY)")
        
        let cirleLayer2 = CAShapeLayer()
        cirleLayer2.path = circlePath3.CGPath
        cirleLayer2.fillColor = UIColor.clearColor().CGColor
        cirleLayer2.strokeColor = UIColor.greenColor().CGColor
        cirleLayer2.lineWidth = 5.0;
        cirleLayer2.strokeEnd = 1.0
    
        
        let circleRadius : CGFloat = 300
        let circlePath2 = UIBezierPath(roundedRect: CGRectMake(0.0, 0.0, CGFloat(self.uiLabelSize), CGFloat(self.uiLabelSize)), cornerRadius:circleRadius)

        self.batcapLayer.path = circlePath2.CGPath
        self.batcapLayer.fillColor = UIColor.clearColor().CGColor
        self.batcapLayer.strokeColor = UIColor.customTwitterColor().CGColor
        self.batcapLayer.lineWidth = 30.0;
        self.batcapLayer.strokeEnd = 1.0

        //self.batstatLayer = circleLayer
        
        NSLog("Percenrage \(self.chargeLevel/100)")
        self.batstatLayer.path = circlePath2.CGPath
        self.batstatLayer.fillColor = UIColor.clearColor().CGColor
        self.batstatLayer.strokeColor = UIColor.customTwitterColor().CGColor
        self.batstatLayer.lineWidth = 40.0;
        self.batstatLayer.strokeEnd = CGFloat(UIDevice.currentDevice().batteryLevel)

        
        
        //self.chargeLayer = circleLayer
        
        self.chargeLayer.path = circlePath2.CGPath
        self.chargeLayer.fillColor = UIColor.clearColor().CGColor
        self.chargeLayer.strokeColor = UIColor.orangeColor().CGColor
        self.chargeLayer.lineWidth = 40.0;
        self.chargeLayer.strokeEnd = 1.0
        self.chargeLayer.backgroundColor = UIColor.clearColor().CGColor


         // Add the circleLayer to the view's layer's sublayers
        //batteryState.layer.addSublayer(circleLayer)
        //batteryCapacity.layer.addSublayer(circleLayer)
        
        //batteryState.layer.addSublayer(circleLayer)
        //batteryState.layer.mask =  circleLayer

        
        
        

        //self.updateBatteryCapacity()
        //self.updateChargingCycle()
        //self.updateChargingProperty()
        
        
        //self.fillsoccap()
        ///self.computeConstCurntPhase()
        
        /*
        let battOne = self.batteryDB?.sqliteGetLastRowId("chargingevent", tableName: Constants.batteryTable)
        if (battOne?.chargingevent > 0){
            self.firstTime = false
            NSLog("Last element found")
            
        }
        else{
        }
        */
        
        //self.presentCapacity = (battOne?.batterycapacity)!
        //self.chargingCycles = (battOne?.chargingcycle)!

        self.batterySenseDidBecomeActive()
        
        
        self.setLabelAnd(batteryCapacity, ulayer: self.batcapLayer)
        self.view.addSubview(batteryCapacity)
        batteryCapacity.layer.addSublayer(cirleLayer)
        

        
        self.setLabelAnd(batteryState, ulayer: self.batstatLayer)
        self.view.addSubview(batteryState)

        self.setLabelAnd(chargeCycle, ulayer: self.chargeLayer)
        self.view.addSubview(chargeCycle)
        chargeCycle.layer.addSublayer(cirleLayer2)

        //batteryState.layer.addSublayer(cirleLayer)//.addSublayer(circleLayer)
        
        
 
    }
    

    func setLabelAnd(oneL : UILabel, ulayer : CAShapeLayer){
        
        
        
    
        oneL.lineBreakMode = .ByWordWrapping
        oneL.numberOfLines = 0
        oneL.textColor = .whiteColor()
        oneL.textAlignment = .Center
        oneL.font = UIFont.systemFontOfSize(CGFloat(textFontSize))
        oneL.bounds = CGRectMake(0.0, 0.0, CGFloat(self.uiLabelSize), CGFloat(self.uiLabelSize))
        oneL.layer.cornerRadius = CGFloat(self.uiLabelSize) / 2
        oneL.layer.borderWidth = 3.0
        oneL.layer.backgroundColor = UIColor.customTwitterColor().CGColor
        //oneL.layer.addSublayer(<#T##layer: CALayer##CALayer#>)
        oneL.layer.borderColor = UIColor.whiteColor().CGColor
        
        oneL.layer.addSublayer(ulayer)
    

    
    }
    
    /*
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
    */
    
    func updateBatteryCapacity(){
        
        let stringCapacity = "\(self.deviceName)    \(self.initialCapacity) mAh     \(self.presentCapacity) mAh"
        batteryCapacity.text = stringCapacity
        self.batcapLayer.strokeEnd = CGFloat(self.presentCapacity/self.initialCapacity * 100)
        
    }
    
    
    
    func updateChargingProperty(){
        
        var propString = ""
        self.batstatLayer.strokeEnd = CGFloat(UIDevice.currentDevice().batteryLevel)
        self.chargeLevel = Int (UIDevice.currentDevice().batteryLevel * 100)
        
        
        if(self.chargingState == 2){
            propString = "\(self.chargeLevel)"
            self.batstatLayer.strokeColor = UIColor.customTwitterColor().CGColor
            
        
        }
        if(self.chargingState == 1){
            
            propString = "\(self.chargeLevel)"
            self.batstatLayer.strokeColor = UIColor.whiteColor().CGColor

            
        }
        
        
        if(self.chargingState == 3){
            propString = "FULL    Unplug"
            self.batstatLayer.strokeColor = UIColor.customTwitterColor().CGColor
        }
        
        batteryState.text = propString
        
    }
    
    
    func updateChargingCycle(){
        
        NSLog("setChargingCycle.....\(self.chargingCycles)")
        chargeCycle.text = "\(self.chargingCycles)        Cycles"
    }
    
    
    func  batteryLevelDidChange(notification: NSNotification){
        
        self.chargeLevel  = Int (UIDevice.currentDevice().batteryLevel*100)
        let currentTime : Int64 = Int64(NSDate.timeIntervalSinceReferenceDate());
        if (self.lastBatteryUpdate>0) && (self.chargingState == 2) {
            
            let deltaB  = self.chargeLevel-self.firstBatteryLevel
            let deltaS  = currentTime-self.firstBatteryUpdate
            let oneCrateTime  = Constants.onePercent * deltaB
            let rate = CGFloat(oneCrateTime) / CGFloat(deltaS)
            self.rateList.append(rate)
            self.socList.append(self.chargeLevel)
            var modelCrate = CGFloat((self.batteryCofs?.newBatteryRate())!)
            self.presentCapacity = Int ((self.batteryCofs?.capacityNowRatio(self.initialCapacity, rnow: Double(rate)))!)
            
            if ( self.socList.count  >= 5) && (self.chargeLevel % 5 == 0) && (self.chargeLevel <= Constants.chargingMaxSOC){
                
                
                modelCrate = self.computeConstCurntPhase()
                self.estimateCapAndCycles(rate, modelCrate: modelCrate)
                defaults.setInteger(self.presentCapacity, forKey: "presentcapacity")
                defaults.setInteger(self.chargingCycles, forKey: "cycle")
                defaults.setObject(self.chargerType, forKey: "charger")
                self.determinePhoneCharger(rate , modelCrate : modelCrate)
                if(self.chargerType == "AC")
                {
                    
                    defaults.setFloat(Float(rate), forKey: "acrate")
                    let usbRate = CGFloat(Constants.puCurrent)/CGFloat(self.initialCapacity)
                    defaults.setFloat(Float(usbRate), forKey: "usbrate")
                    
                }
            }
            
            self.lastBatteryUpdate = currentTime
            NSLog("\(modelCrate)    \(rate)   \(self.presentCapacity)  \(self.chargeLevel)")
            
        }
        
        if((self.lastBatteryUpdate == 0) && (self.firstBatteryUpdate == 0) && (self.chargingState == 2)){
            self.firstBatteryUpdate = currentTime
            self.lastBatteryUpdate = currentTime
            self.firstBatteryUpdateTime = self.getCurrentLocalTime()
            self.firstBatteryLevel = self.chargeLevel
        }
        
        //updateBatteryCapacity()
        updateChargingProperty()
        //updateChargingCycle()
        
    }


    func estimateCapAndCycles ( rate : CGFloat, modelCrate : CGFloat){
    
        /* Calculate the capacity according */
       
        self.presentCapacity = Int ((self.batteryCofs?.capacityNowRatio(self.initialCapacity, rnow: Double(rate)))!)
        let expCapacity = Int ((batteryCofs?.capacityNowExp(Double(rate - modelCrate)))!)
        let capLoss = ((self.initialCapacity - self.presentCapacity)*100) / self.initialCapacity
        let locCycles =  (batteryCofs?.cyclesNow(Double(capLoss)))!
        if (locCycles < 0)
        {
            self.chargingCycles = 25
        }
        else
        {
            self.chargingCycles = locCycles
        }
        
        NSLog("Present Capacity \(self.presentCapacity) \(expCapacity)  \(rate)")

    
    }
    
    
    func determinePhoneCharger ( rate : CGFloat, modelCrate : CGFloat){
    
    
        if(modelCrate-rate > 0.05) && (self.chargeLevel < Constants.chargingMaxSOC) {
            
            let usbRate = CGFloat(Constants.puCurrent)/CGFloat(self.initialCapacity)
            self.presentCapacity = Int((usbRate/rate) * CGFloat(self.initialCapacity))
            self.chargerType = "USB"
            
            
            //NSLog("update USB rate \(usbRate) and capacity \(self.presentCapacity) deltaS \(deltaS)")
            
            
        }else{
            
            self.chargerType = "AC"
            /* The phone is being chared with AC and
             We precompute the USB rate from the AC charging rate here */
            
            
        }
        
    
    }
    
    
    
    
    
    func batteryStateDidChange(notification: NSNotification) {
        
        self.chargingState = UIDevice.currentDevice().batteryState.rawValue
        
        if (self.chargingState >= 2){
            
            // retrieve last charging event number which should be the private variable
            
            // we need to initialize most of the variables here rather than at the viewDidLoad()
            
            
            
            
            let refreshAlert = UIAlertController(title: "\(self.deviceName) Charger", message: "You need to use \(self.deviceName) AC Charger and Proper Cable from Apple", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                NSLog("Handle Ok logic here")
                
            }))
            
            self.presentViewController(refreshAlert, animated: true, completion: nil)
            
        }
            
            
            
        else    {
            
            if (self.socList.count > 10) && (self.socList.last! < Constants.chargingMaxSOC){
                
                /*
                let onebattery = BatteryData()
                onebattery.chargingevent = self.chargingCount + 1
                onebattery.timestamp = self.firstBatteryUpdate
                onebattery.localtime = self.firstBatteryUpdateTime
                onebattery.ccphase = self.ccPhaseLenght
                onebattery.chargingcycle = self.chargingCycles
                onebattery.charger = self.chargerType
                onebattery.beginlevel = self.socList.first!
                onebattery.endlevel = self.socList.last!
                onebattery.batterycapacity = self.presentCapacity
                onebattery.acrate = self.acchargingrate
                onebattery.usbrate = self.usbchargingrate
                
                self.batteryDB?.sqliteInsertBattery(Constants.batteryTable, columns: Constants.batteryColumns, sample: onebattery)
                //batteryData.append(onebattery)
                */
                
            }else{
                
                
            }
            
            
            self.resetAllSenseVars()
            
            
        }
        self.updateChargingProperty();
        self.updateBatteryCapacity()
        self.updateChargingCycle()
        
        
        
        
    }
    

    
    func getCurrentLocalTime ()-> String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.stringFromDate(NSDate())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func computeConstCurntPhase() -> CGFloat {
        
        
        var i = 0
        let max = self.socList.count
        var window = 10
        var sorted : Bool = true
        
        while i < max {
            if ( max - i <= window ){
                
                window = max - i
                NSLog("\(window)")
            }
            
            for j in i  ..< (i + window-1)  {
                
                if self.rateList[j] <= self.rateList[j+1] {
                    
                    i = j+1
                    sorted = false
                    break
                }
                
            }
            if (sorted == true)
            {
                
                NSLog("serted true \(window)")
                break
            }
            sorted = true
            
            
            
        }
        
        //self.presentCapacity = self.capList[i]

        self.ccPhaseLenght = self.socList[i]
        //let ccc = self.socList[i]
        //NSLog("computeConstCurntPhase() \(i) \(self.presentCapacity)   \(ccc)")
        

        return self.rateList[i]
        
        
    }
    
    
    
    func fillsoccap() {
        var cap = 1500
        for i in 1...100 {
            //NSLog("Index \(i)")
            self.socList.append(i+1)
            
            if (i < 45){
            
                self.capList.append(1500)
            }
            else{
                cap = cap + 5
                self.capList.append(cap)
            }
            
            
        
        }
    }


    func resetAllSenseVars(){
    
        self.socList.removeAll()
        self.capList.removeAll()
        self.batteryDB?.sqliteCloseDb()
    }
    
    
    
    
    
    
    
    func retrieveElements(){
    
    
        if let caplocal: Int = defaults.integerForKey("presentcapacity") {
            self.presentCapacity = caplocal
            
        }
        
        if let cyclelocal : Int = defaults.integerForKey("cycles"){
            
            self.chargingCycles = cyclelocal
        }
        
        NSLog("retrieveElements   \(self.presentCapacity)   \(self.chargingCycles)")
    }
    
    
    
    func batterySenseDidEnterBackground() {
        
        if (UIDevice.currentDevice().batteryState.rawValue == 2){
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
            self.registerBackgroundTask()
            self.locatioCallFlag = true
        }
        
    }
    
    
    func batterySenseDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //self.senseViewCont?.setBatteryChargingStatus("1046")
        //self.senseViewCont?.setBatteryCapacity("\(self.presentCapacity)")
        //self.senseViewCont?.setChargingSycleNumber("\(self.chargingCycles)")
        
        
        NSLog("batterySenseDidBecomeActive")
        self.chargeLevel = Int (UIDevice.currentDevice().batteryLevel*100)
        
        if let caplocal: Int = defaults.integerForKey("presentcapacity") {
            self.presentCapacity = caplocal
            
        }
        
        if let cyclelocal : Int = defaults.integerForKey("cycle"){
            
            self.chargingCycles = cyclelocal
        }
        
        self.updateBatteryCapacity()
        self.updateChargingCycle()
        self.updateChargingProperty()
        

        
        NSLog("batterySenseBecameActive")
        if(self.locatioCallFlag == true){
            
            self.stopLocationTracking()
            NSLog("batterySenseBecameActive terminate location tracking")
            self.locatioCallFlag = false
            self.terminateBackgroundTask()
        }
        self.updateTimer = nil
        
        
    }

    
    
    
    
    func stopLocationDelayBy5Seconds() {
        locationManager.stopUpdatingLocation()
        NSLog("locationManager stop Updating after 5 seconds\n")
        locatioCallFlag = false
    }
    
    
    func stopLocationTracking () {
        print("stopLocationTracking\n")
        
        if self.updateTimer != nil {
            self.updateTimer!.invalidate()
            self.updateTimer = nil
            locatioCallFlag = false
            locationManager.stopUpdatingLocation()
            //self.terminateBackgroundTask()
            locatioCallFlag = false
        }
    }
    
    
    
    func startLocationTracking() {
        
        print("startLocationTracking\n")
        if CLLocationManager.locationServicesEnabled() == false {
            
            //print("locationServicesEnabled false\n")
            let servicesDisabledAlert = UIAlertController(title: "Location Services Disabled", message: "You currently have all location services for this device disabled", preferredStyle: UIAlertControllerStyle.Alert)
            
            servicesDisabledAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
                //UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
            self.presentViewController(servicesDisabledAlert, animated: true, completion: nil)
            
            
        } else {
            
            
            let authorizationStatus : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            
            if (authorizationStatus == CLAuthorizationStatus.Denied) || (authorizationStatus == CLAuthorizationStatus.Restricted) {
                
                let servicesDisabledAlert = UIAlertController(title: "Location Services Restricted", message: "You currently have all Location Service Disabled for BatterySense", preferredStyle: UIAlertControllerStyle.Alert)
                
                servicesDisabledAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    //UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                }))
                self.presentViewController(servicesDisabledAlert, animated: true, completion: nil)
                
                
                //print("authorizationStatus failed")
            } else {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.startUpdatingLocation()
            }
        }
    }

    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        print("locationManager didUpdateLocations\n")
        
        if self.updateTimer != nil {
            NSLog("Returning from locationManger")
            return
        }
        
        
        if(locations.count > 0) &&  (locatioCallFlag == true) {
            
            self.registerBackgroundTask()
            let restartLocationUpdates : Selector = #selector(ViewController.restartLocationUpdates)
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(180, target: self, selector: restartLocationUpdates, userInfo: nil, repeats: false)
            let stopLocationDelayBy10Seconds : Selector = #selector(ViewController.stopLocationDelayBy5Seconds)
            _ = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: stopLocationDelayBy10Seconds, userInfo: nil, repeats: false)
            //stopLocationDelayBy5Seconds()
            self.locatioCallFlag = false
        }
    }
    
    
    func restartLocationUpdates() {
        NSLog("restartLocationUpdates\n")
        
        if self.updateTimer != nil {
            self.updateTimer!.invalidate()
            self.updateTimer = nil
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        self.locatioCallFlag = true
        //self.registerBackgroundTask()
        
    }
    
    
    
    
    
    
    
    func registerBackgroundTask() {
        
        
        NSLog("Background task started.")
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.terminateBackgroundTask()
            
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func terminateBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask!)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("\(error)")
        NSLog("Can't get your location!")
    }
    

}


extension UIColor {
    
    class func customChevyOrangeColor() -> UIColor {
        return UIColor(red:225.0/255.0, green:50.0/255.0, blue:29.0/255.0, alpha:1);
    }
    class func customSkyBlueColor() -> UIColor {
        return UIColor(red:0.0/255.0, green:169.0/255.0, blue:199.0/255.0, alpha:1);
        
    }
    class func customTwitterColor() -> UIColor {
        return UIColor(red:75.0/255.0, green:163.0/255.0, blue:235.0/255.0, alpha:1);
    }
}
