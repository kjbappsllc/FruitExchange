//
//  Extension.swift
//  Fruit Exchange
//
//  Created by Mac on 8/12/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation

extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary <String,AnyObject>? {
        var dataOk: NSData
        var dictionaryOk: NSDictionary = NSDictionary()
        
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            let _: NSError?
            
            do {
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions()) as NSData!
                dataOk = data
            }
            catch {
                print("Could not load level")
                return nil
            }
            
            do {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(dataOk, options: NSJSONReadingOptions()) as AnyObject!
                dictionaryOk = (dictionary as! NSDictionary as? Dictionary <String, AnyObject>)!
                
            }
            catch {
                print("Level file '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        return dictionaryOk as? Dictionary <String, AnyObject>
    }
}