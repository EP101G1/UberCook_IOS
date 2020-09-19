//
//  Blog.swift
//  UberCook
//
//  Created by 超 on 2020/9/2.
//

import UIKit

class Blog: Codable {
    var recipe_no:String?
    var chef_no:String?
    var recipe_title:String?
    var recipe_con:String?
    var recipe_total:Int?
    var recipe_point:Int?
    
    init (_ recipe_no:String, _ chef_no:String, _ recipe_title:String, _ recipe_con:String, _ recipe_total:Int, _ recipe_point:Int){
        self.recipe_no = recipe_no
        self.chef_no = chef_no
        self.recipe_title = recipe_title
        self.recipe_con = recipe_con
        self.recipe_total = recipe_total
        self.recipe_point = recipe_point
    }

}
