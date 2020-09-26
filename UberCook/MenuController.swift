//
//  MenuOrderList.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/13.
//

import Foundation
import UIKit

struct GetPostMenuRecipeListData:Encodable {
    var action = "getRecipeList"
    var chefNo:String
    
}

struct MenuRecipeList:Decodable {
    var recipeNo:String
    var chefNo:String
    var recipeTitle:String
    var recipeCon:String
    var recipePoint:Int
    var flag:Int
    var count:Int?
}

struct GetRecipeImagePostData: Encodable {
    var action = "getRecipeImage"
    var recipe_no: String
    var imageSize: Int
   
}

class MenuController{
    
    static let shared = MenuController()
    
    let baseURL = URL(string: "http://192.168.50.35:8080/UberCook_Server")!
    
    func getMenuRecipeLists(chefNo:String,completion:@escaping ([MenuRecipeList]?) -> Void){
        let url = baseURL.appendingPathComponent("Order_Servlet") //連網址
        var request = URLRequest(url: url) //送請求
        request.httpMethod = "POST" //包post
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //add key value
        let getMenuRecipeList = GetPostMenuRecipeListData(chefNo: chefNo) //包chefno
        let encoder = JSONEncoder() //編碼
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try? encoder.encode(getMenuRecipeList)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
           // print(String(decoding: data!, as: UTF8.self))
//            print(String(decoding: data!, as: UTF8.self))
             let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let data = data,
               let menuRecipeList = try? decoder.decode([MenuRecipeList].self, from: data){
//                print(menuRecipeList[0].chefNo)
                completion(menuRecipeList)
            }else{
                completion(nil)
            }
        }.resume()
        
    }
    
    func getRecipeImage(recipe_no:String,imageSize:Int,completion:@escaping (UIImage?) -> Void){
        let url = baseURL.appendingPathComponent("UberCook_Servlet")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let getRecipeImagePostData = GetRecipeImagePostData(recipe_no: recipe_no, imageSize: imageSize)
        request.httpBody = try? JSONEncoder().encode(getRecipeImagePostData)
        URLSession.shared.dataTask(with: request) { (data, response, errer) in
            if let data = data,
               let image = UIImage(data: data){
                completion(image)
            }else{
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
}

