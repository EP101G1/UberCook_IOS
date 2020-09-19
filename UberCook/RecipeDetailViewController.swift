//
//  RecipeDetailViewController.swift
//  UberCook
//
//  Created by 超 on 2020/9/1.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    let url_server = URL(string: common_url + "UberCook_Servlet")
    var fullScreenSize :CGSize!
    let fileManager = FileManager()
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeConLabel: UILabel!
    @IBOutlet weak var recipePointLabel: UILabel!
    @IBOutlet weak var chefIconImageView: UIImageView!
    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var chefNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    let userDefault = UserDefaults()
    var recipe:Recipe?
    var recipeList:RecipeList?
    var collection:Collection?
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenSize = UIScreen.main.bounds.size
        
        
        
        if collection == nil && recipe == nil{
            recipeConLabel.text = recipeList?.recipe_con
            recipeTitleLabel.text = recipeList?.recipe_title
            recipePointLabel.text = "$ \(String(recipeList?.recipe_point ?? 0))"
        }else if recipe == nil && recipeList == nil{
            recipeConLabel.text = collection?.recipe_con
            recipeTitleLabel.text = collection?.recipe_title
            recipePointLabel.text = "$ \(String(collection?.recipe_point ?? 0))"
        }else{
            recipeConLabel.text = recipe?.recipe_con
            recipeTitleLabel.text = recipe?.recipe_title
            recipePointLabel.text = "$ \(String(recipe?.recipe_point ?? 0))"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showChefIcon()
        showRecipeImage()
        showChefName()
        searchFollow()
    }
    
    func searchFollow(){
        var requestParam = [String: Any]()
        requestParam["action"] = "searchFollow"
        requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
        requestParam["recipe_no"] = (recipeList?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.flag = Int(String(decoding: data!, as: UTF8.self)) ?? 0
                    if self.flag == 0{
                        DispatchQueue.main.async {
                        self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                        self.favoriteButton.tintColor = .black
                        }
                    }else{
                        DispatchQueue.main.async {
                        self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        self.favoriteButton.tintColor = .red
                        }
                    }
                }
            }
        }
    }
    
    
    
    func showChefIcon(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImageForRecipeDetail"
        requestParam["chef_no"] = (recipeList?.chef_no ?? collection?.chef_no) ?? recipe?.chef_no
        requestParam["imageSize"] = 240
        var image: UIImage?
//        let imageUrl = fileInCaches(fileName: recipe.)
//        if self.fileManager.fileExists(atPath: imageUrl.path) {
//            if let imageCaches = try? Data(contentsOf: imageUrl) {
//                image = UIImage(data: imageCaches)
//                DispatchQueue.main.async {
//                    self.chefIconImageView.image = image
//                }
//            }
//        }else{
            executeTask(url_server!, requestParam) { (data, response, error) in
                //            print("input: \(String(data: data!, encoding: .utf8)!)")
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                    }
                    DispatchQueue.main.async {
                        self.chefIconImageView.image = image
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
//        }
    }
    
    func showRecipeImage(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getRecipeImage"
        requestParam["recipe_no"] = (recipeList?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
        requestParam["imageSize"] = 720
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: ((recipeList?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no) ?? "")
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                DispatchQueue.main.async {
                    self.recipeImageview.image = image
                }
            }
        }else{
        executeTask(url_server!, requestParam) { (data, response, error) in
            //            print("input: \(String(data: data!, encoding: .utf8)!)")
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.recipeImageview.image = image
                    }
                    if let image = image?.jpegData(compressionQuality: 1.0) {
                        try? image.write(to: imageUrl, options: .atomic)
                    }
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                    DispatchQueue.main.async {
                        self.recipeImageview.image = image
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    }
    
    func showChefName(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserNameforRecipeDetail"
        requestParam["chef_no"] = (recipeList?.chef_no ?? collection?.chef_no) ?? recipe?.chef_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                        DispatchQueue.main.async {
                            self.chefNameLabel.text = "\(String(decoding: data!, as: UTF8.self))"
                        }
                    }
                }
            }
        }
    
    
    @IBAction func clickTrack(_ sender: Any) {
        if flag == 0 {
            self.flag = 1
            var requestParam = [String: Any]()
            requestParam["action"] = "insertCollect"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["recipe_no"] = (recipeList?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let count = String(decoding: data!, as: UTF8.self)
                        if count == "1"{
                            DispatchQueue.main.async {
                                self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                self.favoriteButton.tintColor = .red
                            }
                            
                        }
                    }
                }
            }
        }else{
            self.flag = 0
            var requestParam = [String: Any]()
            requestParam["action"] = "deleteCollect"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["recipe_no"] = (recipeList?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let count = String(decoding: data!, as: UTF8.self)
                        if count == "1"{
                            DispatchQueue.main.async {
                                self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                self.favoriteButton.tintColor = .black
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
}
