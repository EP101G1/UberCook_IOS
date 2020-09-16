//
//  LoginObj.swift
//  UberCook
//
//  Created by 謝承儒 on 2020/9/7.
//

import Foundation
struct LoginObj:Decodable {
    var msg: String?
    var Result: String
    var USER: User?
    var CHEF_NO: String?
    
    
    enum CodingKeys: CodingKey { //init方法一定要列舉
        case msg
        case Result
        case USER
        case CHEF_NO
    }
    
    init(from decoder: Decoder) throws {
        
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if(container.contains(.msg)){
            msg = try container.decode(String.self, forKey: .msg)
        }
        
        if(container.contains(.CHEF_NO)){
            CHEF_NO = try container.decode(String.self, forKey: .CHEF_NO)
        }
       
        Result = try container.decode(String.self, forKey: .Result)
        
        if (container.contains(.USER)) {
            let USERString = try container.decode(String.self, forKey: .USER)
            if let userData = USERString.data(using: .utf8),
               let user = try? JSONDecoder().decode(User.self, from: userData) {
                self.USER = user
            }
        }else {
            self.USER = nil
        }
       
    }
    
    

}

struct User:Codable{
    var user_no:String
    var user_acc:String
    var user_psw:String
    var user_name:String
    var user_phone:String
    var user_adrs:String
    var user_si:String
    var user_bank_account:String
    var user_points:Int
    var flag:Int
    var token_flag:Int
    var user_war:Int
}



