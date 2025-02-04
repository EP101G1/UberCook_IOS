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
    var blog:Blog?
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeConLabel: UILabel!
    @IBOutlet weak var recipePointLabel: UILabel!
    @IBOutlet weak var chefIconImageView: UIImageView!
    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var chefNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    let userDefault = UserDefaults()
    var recipeDetail:Recipe?
    var recipe:Recipe?
//    var recipeList:RecipeList?
    var collection:Collection?
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenSize = UIScreen.main.bounds.size
        getRecipeDetail()
        checkChefDetail()
//        if collection == nil && recipe == nil{
//            recipeConLabel.text = recipeList?.recipe_con
//            recipeTitleLabel.text = recipeList?.recipe_title
//            recipePointLabel.text = "$ \(String(recipeList?.recipe_point ?? 0))"
//        }else if recipe == nil && recipeList == nil{
//            recipeConLabel.text = collection?.recipe_con
//            recipeTitleLabel.text = collection?.recipe_title
//            recipePointLabel.text = "$ \(String(collection?.recipe_point ?? 0))"
//        }else{
//            recipeConLabel.text = recipe?.recipe_con
//            recipeTitleLabel.text = recipe?.recipe_title
//            recipePointLabel.text = "$ \(String(recipe?.recipe_point ?? 0))"
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showChefIcon()
        showRecipeImage()
        showChefName()
        searchFollow()
        getRecipeDetail()
    }
    
    
    func checkChefDetail(){
        let chef_no = userDefault.value(forKey: "chef_no") as! String
        if chef_no == blog?.chef_no! || chef_no == collection?.chef_no || chef_no == recipe?.chef_no! {
            updateButton.isEnabled = true
            updateButton.tintColor = UIColor.systemBlue
        }else{
            updateButton.tintColor = UIColor.clear
            updateButton.isEnabled = false
        }
    }
    
    
    func getRecipeDetail(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getRecipeDetail"
        requestParam["recipe_no"] = (blog?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode(Recipe.self, from: data!){
                        self.recipeDetail = result
                        DispatchQueue.main.async {
                            self.recipeConLabel.text = self.recipeDetail?.recipe_con
                            self.recipeTitleLabel.text = self.recipeDetail?.recipe_title
                            self.recipePointLabel.text = "$ \(String(self.recipeDetail?.recipe_point ?? 0))"
                        }
                    }
                }
            }
        }
    }
    
    func searchFollow(){
        var requestParam = [String: Any]()
        requestParam["action"] = "searchFollow"
        requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
        requestParam["recipe_no"] = (blog?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
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
        requestParam["chef_no"] = (blog?.chef_no ?? collection?.chef_no) ?? recipe?.chef_no
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
        requestParam["recipe_no"] = (blog?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
        requestParam["imageSize"] = 720
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: ((blog?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no) ?? "")
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
        requestParam["chef_no"] = (blog?.chef_no ?? collection?.chef_no) ?? recipe?.chef_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
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
            requestParam["recipe_no"] = (blog?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
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
            requestParam["recipe_no"] = (blog?.recipe_no ?? collection?.recipe_no) ?? recipe?.recipe_no
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
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let post = segue.destination as! PostVC
//        let con = recipeConLabel.text
//        let title = recipeTitleLabel.text
//        let point = recipePointLabel.text
//        
//        post.recipeTitle = title
//        post.con = con
//        post.point = point?.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "$"))
//        post.flag = 1
//        post.image = recipeImageview.image
//        post.recipe_no = recipe?.recipe_no ?? collection?.recipe_no ?? recipeList?.recipe_no
//        }
    
    
    @IBSegueAction func clickToMessage(_ coder: NSCoder) -> MessageTVC? {
        let controller = MessageTVC(coder: coder)
        controller?.recipe_no = recipe?.recipe_no ?? collection?.recipe_no ?? blog?.recipe_no
        return controller
    }
    
    @IBSegueAction func clickToUpdate(_ coder: NSCoder) -> PostVC? {
        let controller = PostVC(coder: coder)
        let con = recipeConLabel.text
        let title = recipeTitleLabel.text
        let point = recipePointLabel.text
        
        controller?.recipeTitle = title
        controller?.con = con
        controller?.point = point?.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "$"))
        controller?.flag = 1
        controller?.image = recipeImageview.image
        controller?.recipe_no = recipe?.recipe_no ?? collection?.recipe_no ?? blog?.recipe_no
        return controller
    }
    
}
