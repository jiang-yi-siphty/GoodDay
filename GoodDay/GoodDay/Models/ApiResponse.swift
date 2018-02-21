//
//	ApiResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport
//  GoodDay
//
//  Created by Yi JIANG on 20/2/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import Foundation 
import ObjectMapper


class ApiResponse : NSObject, NSCoding, Mappable{

	var base : String?
	var clouds : Cloud?
	var cod : Int?
	var coord : Coord?
	var dt : Int?
	var id : Int?
	var main : Main?
	var name : String?
	var sys : Sys?
	var visibility : Int?
	var weather : [Weather]?
	var wind : Wind?


	class func newInstance(map: Map) -> Mappable?{
		return ApiResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		base <- map["base"]
		clouds <- map["clouds"]
		cod <- map["cod"]
		coord <- map["coord"]
		dt <- map["dt"]
		id <- map["id"]
		main <- map["main"]
		name <- map["name"]
		sys <- map["sys"]
		visibility <- map["visibility"]
		weather <- map["weather"]
		wind <- map["wind"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         base = aDecoder.decodeObject(forKey: "base") as? String
         clouds = aDecoder.decodeObject(forKey: "clouds") as? Cloud
         cod = aDecoder.decodeObject(forKey: "cod") as? Int
         coord = aDecoder.decodeObject(forKey: "coord") as? Coord
         dt = aDecoder.decodeObject(forKey: "dt") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         main = aDecoder.decodeObject(forKey: "main") as? Main
         name = aDecoder.decodeObject(forKey: "name") as? String
         sys = aDecoder.decodeObject(forKey: "sys") as? Sys
         visibility = aDecoder.decodeObject(forKey: "visibility") as? Int
         weather = aDecoder.decodeObject(forKey: "weather") as? [Weather]
         wind = aDecoder.decodeObject(forKey: "wind") as? Wind

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if base != nil{
			aCoder.encode(base, forKey: "base")
		}
		if clouds != nil{
			aCoder.encode(clouds, forKey: "clouds")
		}
		if cod != nil{
			aCoder.encode(cod, forKey: "cod")
		}
		if coord != nil{
			aCoder.encode(coord, forKey: "coord")
		}
		if dt != nil{
			aCoder.encode(dt, forKey: "dt")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if main != nil{
			aCoder.encode(main, forKey: "main")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if sys != nil{
			aCoder.encode(sys, forKey: "sys")
		}
		if visibility != nil{
			aCoder.encode(visibility, forKey: "visibility")
		}
		if weather != nil{
			aCoder.encode(weather, forKey: "weather")
		}
		if wind != nil{
			aCoder.encode(wind, forKey: "wind")
		}

	}

}
