//
//  OrderObj.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/16.
//

import Foundation

struct OrderObj:Encodable { //下載是decodable解碼 上傳就是encodable編碼
    var action = "InsertOrder"
    var userName:String?
    var order:Order?
    var orderList:[OrderList]?
    
    enum CodingKeys: String,CodingKey{
        case action
        case userName
        case order
        case orderList
    }
    
    func encode(to encoder: Encoder) throws { //將日期傳至資料庫
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(action, forKey: .action)
        try container.encode(userName, forKey: .userName)
        let encoder = JSONEncoder() //編碼
        
        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy h:mm:ss a"
            let stringData = formatter.string(from: date)
            var container = encoder.singleValueContainer()
            try container.encode(stringData)
        })
        
        if let order = try? encoder.encode(order),
           let orderString = String(data:order, encoding: .utf8){
            try container.encode(orderString, forKey: .order)
        }
        
        if let orderList = try? JSONEncoder().encode(orderList),
           let orderListString = String(data:orderList, encoding: .utf8){
            try container.encode(orderListString, forKey: .orderList)
        }
    }
    
    
}

struct Order:Codable {
    var order_no:Int?
    var user_no:String
    var chef_no:String
    var remark:String?
    var order_date:Date
    var flag:Int
    var deal_date:Date
    var total_point:Int
    var user_star:Double?
    var chef_star:Double?
    var address:String
    var phone:String
    var user_name:String
    
//    enum CodingKeys:CodingKey {
//        case order_no
//        case user_no
//        case chef_no
//        case remark
//        case order_date
//        case flag
//        case deal_date
//        case total_point
//        case user_star
//        case chef_star
//        case address
//        case phone
//        case user_name
//        
//    }
//    
//    
//    mutating func decode(to decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        order_no =  try container.decode(Int.self, forKey: .order_no)
//        user_no = try container.decode(String.self, forKey: .user_no)
//        chef_no = try container.decode(String.self, forKey: .chef_no)
//        remark = try container.decode(String.self, forKey: .remark)
//        let order_dateStr = try container.decode(String.self, forKey: .order_date)
//        let deal_dateStr = try container.decode(String.self, forKey: .deal_date)
//        let dateFormatter = DateFormatter.init()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        order_date = dateFormatter.date(from: order_dateStr)!
//        deal_date = dateFormatter.date(from: deal_dateStr)!
//        flag = try container.decode(Int.self, forKey: .flag)
//        total_point = try container.decode(Int.self, forKey: .total_point)
//        user_star = try container.decode(Double.self, forKey: .user_star)
//        chef_star = try container.decode(Double.self, forKey: .chef_star)
//        address = try container.decode(String.self, forKey: .address)
//        phone = try container.decode(String.self, forKey: .phone)
//        user_name = try container.decode(String.self, forKey: .user_name)
//    }
    
    
    
}



struct OrderList:Codable {
    var order_no:Int?
    var recipe_no:String
    var point:Int
    var count:Int
    var recipe_title:String
}

//    enum CodingKeys:CodingKey {
//        case action
//        case userName
//        case order
//        case orderList
//    }
//
//    init(from decoder:Decoder) throws { //轉字串一定要用decodable 其他可以用codable
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            action = try container.decode(String.self, forKey: .action)
//
//
//        if container.contains(.userName){
//            userName = try container.decode(String.self, forKey: .userName)
//        }
//
//        if container.contains(.order) {
//            let orderString = try container.decode(String.self, forKey: .order)
//            if let orderData = orderString.data(using: .utf8),
//               let order = try? JSONDecoder().decode(Order.self, from: orderData) {
//                self.order = order
//            }
//        }else {
//            self.order = nil
//        }
//
//
//        if container.contains(.orderList) {
//            let orderListString = try container.decode(String.self, forKey: .orderList)
//            if let orderListData = orderListString.data(using: .utf8),
//               let orderList = try?JSONDecoder().decode(OrderList.self, from: orderListData){
//                self.orderList = [orderList]
//            }
//        }else{
//            self.orderList = nil
//        }
//
//    }





//    enum CodingKeys:CodingKey {
//        case ORDER_NO
//        case USER_NO
//        case CHEF_NO
//        case REMARK
//        case ORDER_DATE
//        case FLAG
//        case DEAL_DATE
//        case TOTAL_POINT
//        case USER_STAR
//        case CHEF_STAR
//        case ADDRESS
//        case PHONE
//        case USER_NAME
//
//    }









//    enum OrderList {
//        case ORDER_NO
//        case CHEF_NO
//        case POINT
//        case COUNT
//        case RECIPE_TITLE
//    }




