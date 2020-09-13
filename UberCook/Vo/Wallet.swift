//
//  Wallet.swift
//  UberCook
//
//  Created by kira on 2020/9/13.
//

import Foundation

class Wallet : Codable{
    var point : Int
    var money : String
    
    public init(_ point : Int , _ money : String){
        self.point = point
        self.money = money
        
    }
}
