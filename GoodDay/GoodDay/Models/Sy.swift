//
//	Sy.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport
//  GoodDay
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation 
import ObjectMapper


class Sy : NSObject, NSCoding, Mappable{

	var country : String?
	var id : Int?
	var message : Float?
	var sunrise : Int?
	var sunset : Int?
	var type : Int?


	class func newInstance(map: Map) -> Mappable?{
		return Sy()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		country <- map["country"]
		id <- map["id"]
		message <- map["message"]
		sunrise <- map["sunrise"]
		sunset <- map["sunset"]
		type <- map["type"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         country = aDecoder.decodeObject(forKey: "country") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         message = aDecoder.decodeObject(forKey: "message") as? Float
         sunrise = aDecoder.decodeObject(forKey: "sunrise") as? Int
         sunset = aDecoder.decodeObject(forKey: "sunset") as? Int
         type = aDecoder.decodeObject(forKey: "type") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if sunrise != nil{
			aCoder.encode(sunrise, forKey: "sunrise")
		}
		if sunset != nil{
			aCoder.encode(sunset, forKey: "sunset")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}
