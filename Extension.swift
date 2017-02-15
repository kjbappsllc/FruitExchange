//
//  Extension.swift
//  Fruit Exchange
//
//  Created by Mac on 8/12/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation
import SpriteKit

extension Dictionary {
    static func loadJSONFromBundle(_ filename: String) -> Dictionary <String,AnyObject>? {
        var dataOk: Data
        var dictionaryOk: NSDictionary = NSDictionary()
        
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            let _: NSError?
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
                dataOk = data!
            }
            catch {
                print("Could not load level")
                return nil
            }
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataOk, options: JSONSerialization.ReadingOptions()) as AnyObject!
                dictionaryOk = (dictionary as! NSDictionary as? Dictionary <String, AnyObject>)! as NSDictionary
                
            }
            catch {
                print("Level file '\(filename)' is not valid JSON: \(error)")
                return nil
            }
        }
        return dictionaryOk as? Dictionary <String, AnyObject>
    }
}
