//
//  Recipe.swift
//  UberCook
//
//  Created by 超 on 2020/8/31.
//

import UIKit
import Foundation

class Recipe: Codable{
    var recipe_no:String?
    var recipe_title:String?
    var recipe_con:String?
    var recipe_point:Int?
    var chef_no:String?
    var flag:Int?
    
    public init(_ recipe_no:String, _ recipe_title:String, _ recipe_con:String, _ recipe_point:Int,_ chef_no:String,_ flag:Int){
        self.recipe_no = recipe_no
        self.recipe_title = recipe_title
        self.recipe_con = recipe_con
        self.recipe_point = recipe_point
        self.chef_no = chef_no
        self.flag = flag
    }
    
    
}
