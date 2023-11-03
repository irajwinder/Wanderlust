//
//  DataManager.swift
//  Wanderlust
//
//  Created by Rajwinder Singh on 11/3/23.
//

import UIKit

//Singleton Class
class DataManager: NSObject {

    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
   
    private override init() {
        super.init()
    }
    
}

let dataManagerInstance = DataManager.sharedInstance
