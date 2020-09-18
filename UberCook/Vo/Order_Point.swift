//
//  Order_Point.swift
//  UberCook
//
//  Created by Kathy Huang on 2020/9/18.
//

import Foundation

class Order_Point: Codable{
    
    var user_no:String?
    var p_order_no:Int?
    var point:Int?
    var flag:Int?
    
    init(_ user_no:String,_ p_order_no:Int,_ point:Int,_ flag:Int){
        self.user_no = user_no
        self.p_order_no = p_order_no
        self.point = point
        self.flag = flag
    }
    
    init(_ user_no:String,_ point:Int,_ flag:Int){
        self.user_no = user_no
        self.point = point
        self.flag = flag
    }
}
