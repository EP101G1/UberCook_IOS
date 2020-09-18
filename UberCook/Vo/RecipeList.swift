//
//  RecipeList.swift
//  UberCook
//
//  Created by 超 on 2020/9/3.
//

import UIKit

class RecipeList: Codable{
    var user_no:String?
    var chef_no:String?
    var recipe_no:String?
    var user_name:String?
    var user_si:String?
    var recipe_title:String?
    var recipe_con:String?
    var recipe_point:Int?
    var recipe_total:Int?
    var flag:Int? = 0
    
    init(_ user_no:String, _ chef_no:String, _ recipe_no:String, _ user_name:String, _ user_si:String, _ recipe_title:String, _ recipe_con:String, _ recipe_point:Int, _ recipe_total:Int, _ flag:Int) {
        self.user_no = user_no
        self.chef_no = chef_no
        self.recipe_no = recipe_no
        self.user_name = user_name
        self.user_si = user_si
        self.recipe_title = recipe_title
        self.recipe_con = recipe_con
        self.recipe_point = recipe_point
        self.recipe_total = recipe_total
        self.flag = flag
    }

}
