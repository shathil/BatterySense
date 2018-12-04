//
//  DatabaseAccess.swift
//  BatterySense
//
//  Created by Mohammad Hoque on 24/02/16.
//  Copyright © 2016 Mohammad Hoque. All rights reserved.
//

import Foundation

class sqliteaccess{

    
    var dbName :String = ""
    var statement : COpaquePointer = nil
    var db: COpaquePointer = nil
    
    struct DBConstants{
        static let SQLITE_STATIC = unsafeBitCast(0, sqlite3_destructor_type.self)
        static let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    }
    
    init (dbname: String){
        
        self.dbName = dbname
        self.sqliteConnectDB(self.dbName)
    }
    
    
    // DB related functions
    
    
    func sqliteConnectDB(dbFileName : String){
        
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        
        
        let fileURL = documents.URLByAppendingPathComponent(dbFileName)
        
        
        if sqlite3_open(fileURL.path!, &self.db) != SQLITE_OK {
            print("error opening database")
        }
        else{
            print("sqlite success")
        }
        
    }
    
    func getDBPointer () -> COpaquePointer{
    
        return self.db
    }
    
    
    
    func sqliteCreateTable (tableName : String, columns: [String]) -> Bool{
        
        

        let queryPart = columns.joinWithSeparator(",")
        
        NSLog("\(queryPart)")
        
        var success: Bool = true
        let query = "create table if not exists \(tableName) (\(queryPart))"
        var errmsg = ""
        if sqlite3_exec(self.db, query, nil, nil, nil) != SQLITE_OK {
            errmsg = String.fromCString(sqlite3_errmsg(db))!
            print("error creating table: \(errmsg)")
            success = false
        }else{
            
            print(" creating table successfull: \(errmsg)")
        }
        
        return success
    }

    

    
    
    func sqliteInsertCharging (tableName : String, columns: [String], sample: ChargingData) -> Bool{
        
        var success = true
        let colCount = columns.count
        let fkval  = [String](count: colCount, repeatedValue: "?").joinWithSeparator(",")
        let prepInsert = "insert into \(tableName) values (\(fkval))"
        if sqlite3_prepare_v2(self.db, prepInsert, -1, &self.statement, nil) != SQLITE_OK
            
        {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            NSLog("error preparing insert: \(errmsg)")
            success = false
            return success
        }
        
        
        
      
        
        if sqlite3_bind_int64(self.statement, 1, sample.timestamp) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.timestamp: \(errmsg)")
            success = false
            return success

            
            
        }

        
        if sqlite3_bind_text(self.statement, 2, sample.localtime,-1, DBConstants.SQLITE_TRANSIENT) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.localtime: \(errmsg)")
            success = false
            return success

        
        }

        
        if sqlite3_bind_int(self.statement, 3, Int32(sample.batterylevel)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.batterylevel: \(errmsg)")
            success = false
            return success

        
        }
        
        if sqlite3_bind_double(self.statement, 4, Double(sample.rate)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.rate: \(errmsg)")
            success = false
            return success
            
            
        }

        
        if sqlite3_bind_int(self.statement, 5, Int32(sample.chargingevent)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.chargingevent: \(errmsg)")
            success = false
            return success

            
        
        }

        
        if (sqlite3_step(self.statement) != SQLITE_DONE) {
            
            NSLog("Commit Failed!\n");
            success = false
            return success

        
        }
            
        
        if sqlite3_reset(self.statement) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error resetting prepared statement: \(errmsg)")
            success = false
            return success
        }

        
        if sqlite3_finalize(self.statement) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error finalizing prepared statement: \(errmsg)")
            success = false
            return success
        }
        
        self.statement = nil

        return success
        
    }
    
    func sqliteInsertBattery (tableName : String, columns: [String], sample: BatteryData) -> Bool{
        
        var success = true
        let colCount = columns.count
        let fkval  = [String](count: colCount, repeatedValue: "?").joinWithSeparator(",")
        let prepInsert = "insert into \(tableName) values (\(fkval))"
        if sqlite3_prepare_v2(self.db, prepInsert, -1, &self.statement, nil) != SQLITE_OK
            
        {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            NSLog("error preparing insert: \(errmsg)")
            success = false
            return success
        }
        
        

        
        
        if sqlite3_bind_int(self.statement, 1, Int32(sample.chargingevent)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.chargingevent: \(errmsg)")
            success = false
            return success
            
            
            
        }

        if sqlite3_bind_int64(self.statement, 2, sample.timestamp) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.timestamp: \(errmsg)")
            success = false
            return success
            
            
            
        }

        if sqlite3_bind_text(self.statement, 3, sample.localtime,-1, DBConstants.SQLITE_TRANSIENT) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.timestamp: \(errmsg)")
            success = false
            return success
            
            
            
        }

        

        if sqlite3_bind_int(self.statement, 4, Int32(sample.beginlevel)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.beginlevel: \(errmsg)")
            success = false
            return success
            
            
            
        }
        if sqlite3_bind_int(self.statement, 5, Int32(sample.endlevel)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.endlevel: \(errmsg)")
            success = false
            return success
            
            
            
        }

        if sqlite3_bind_int(self.statement, 6, Int32(sample.ccphase)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.ccphase: \(errmsg)")
            success = false
            return success
            
            
            
        }

        
        if sqlite3_bind_int(self.statement, 7, Int32(sample.batterycapacity)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.batterycapacity: \(errmsg)")
            success = false
            return success
            
            
            
        }
        
        
        
        if sqlite3_bind_int(self.statement, 8, Int32(sample.chargingcycle)) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.chargingcycle: \(errmsg)")
            success = false
            return success
            
            
        }
        
        if sqlite3_bind_text(self.statement, 9, sample.charger,-1, DBConstants.SQLITE_TRANSIENT) != SQLITE_OK {
            
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            
            NSLog("failure binding sample.charger: \(errmsg)")
            success = false
            return success
            
            
            
        }

        
        
        if (sqlite3_step(self.statement) != SQLITE_DONE) {
            
            NSLog("Commit Failed!\n");
            success = false
            return success
            
            
        }
        
        
        if sqlite3_reset(self.statement) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error resetting prepared statement: \(errmsg)")
            success = false
            return success
        }
        
        
        if sqlite3_finalize(self.statement) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error finalizing prepared statement: \(errmsg)")
            success = false
            return success
        }
        
        self.statement = nil
        
        return success
        
    }
    

    
    func sqliteGetLastRowId (primaryKey : String, tableName : String) -> BatteryData {
        
        let battOne = BatteryData()
        
        
        let myQuery = "select \(primaryKey) from \(tableName) ORDER BY \(primaryKey) DESC LIMIT 1"
        if sqlite3_prepare_v2(self.db, myQuery, -1, &self.statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error preparing select: \(errmsg)")
            //return battOne
        }
        
        
        while sqlite3_step(self.statement) == SQLITE_ROW{
            battOne.chargingevent  = Int(sqlite3_column_int(self.statement, 0))
            battOne.timestamp  = Int64(sqlite3_column_int(self.statement, 1))
            
            let time = sqlite3_column_text(self.statement, 2)
            if (time != nil){
                battOne.localtime = String.fromCString(UnsafePointer<Int8>(time))!
            }
            
            battOne.beginlevel  = Int(sqlite3_column_int(self.statement, 3))
            battOne.endlevel  = Int(sqlite3_column_int(self.statement, 4))
            battOne.ccphase  = Int(sqlite3_column_int(self.statement, 5))
            battOne.batterycapacity  = Int(sqlite3_column_int(self.statement, 6))
            battOne.acrate  = Float(sqlite3_column_double(self.statement, 7))
            battOne.usbrate  = Float(sqlite3_column_double(self.statement, 8))
            battOne.chargingcycle  = Int(sqlite3_column_int(self.statement, 9))
            //battOne.charger  = Int(sqlite3_column_int(self.statement, 10))
            
            let charger = sqlite3_column_text(self.statement, 10)
            if (charger != nil){
                battOne.charger = String.fromCString(UnsafePointer<Int8>(charger))!
            }

        }

        

        if sqlite3_finalize(self.statement) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        self.statement = nil

        return battOne
    }
    
    
    
    
    
    func sqliteSelect (fieldName : [String], tableName : String){
        
        var columns = [String]()
        
        fieldName.forEach{ pair in
            let temp = pair.characters.split{$0 == " "}.map(String.init)
            columns.append(temp[0])
        }
        
        let myQuery = "select \(columns.joinWithSeparator(",")) from \(tableName)"
        
        if sqlite3_prepare_v2(db, myQuery, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            print("id = \(id); ", terminator: "")
            
            let name = sqlite3_column_text(statement, 1)
            if name != nil {
                let nameString = String.fromCString(UnsafePointer<Int8>(name))
                print("date = \(nameString!)")
            } else {
                print("name not found")
            }
        }
        
        
        if sqlite3_finalize(self.statement) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        self.statement = nil
        
    }
    
    
    func sqliteDropTable (tableName : String) -> Bool{
        var success = true
        let dropQuery = "drop table \(tableName)"
        if sqlite3_exec(db, dropQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String.fromCString(sqlite3_errmsg(self.db))!
            print("error creating table: \(errmsg)")
            success = false
            
        }
        
        
        
        return success;
        
    }
    
    func sqliteCloseDb() -> COpaquePointer {
        
        if sqlite3_close(self.db) != SQLITE_OK {
            print("error closing database")
        }
        
        self.db = nil
        
        return self.db
    }
    
    
}