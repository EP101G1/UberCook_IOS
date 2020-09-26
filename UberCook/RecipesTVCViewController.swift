//
//  RecipeListTVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/3.
//

import UIKit

class RecipesTVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let url_server = URL(string: common_url + "UberCook_Servlet")
//    var blog: Blog?
    var blog = [Blog]()  // test
    var recipeList = [RecipeList]()
    let fileManager = FileManager()
    var flag = [Int]()
    let userDefault = UserDefaults()
    var index = 0
    var recipe_no = ""
    var user_name:String?
    var indexForRow:Int?


    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subview in self.view.subviews {
            if subview is UITableView {
                let tableView = subview as? UITableView
                tableView?.reloadData()
                tableView?.scrollToRow(at: IndexPath(row: self.indexForRow!, section: 0), at: .top, animated: false)
            }
        }
    }
    
//    func getRecipeList(){
//        var requestParam = [String: Any]()
//        requestParam["action"] = "getRecipeDetailForRV"
//        requestParam["chef_no"] = blog?.chef_no
//        executeTask(url_server!, requestParam) { (data, response, error) in
//            let decoder = JSONDecoder()
//            if error == nil {
//                if data != nil {
////                    print("input: \(String(data: data!, encoding: .utf8)!)")
//                    if let result = try? decoder.decode([RecipeList].self, from: data!){
//                        self.recipeList = result
//                        DispatchQueue.main.async {
//
//                        }
//                    }
//                }
//            }
//        }
//    }
    



//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return recipeList.count
//    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return blog.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeListCell
        let recipes = blog[indexPath.row]
        
        
        cell?.chefNameLabel.text = user_name ?? ""
        cell?.recipeConLabel.text = recipes.recipe_con
        cell?.recipePointLabel.text = "$ \(recipes.recipe_point ?? 0)"
        cell?.recipeTitleLabel.text = recipes.recipe_title
        
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getRecipeImage"
        requestParam["recipe_no"] = recipes.recipe_no
        requestParam["imageSize"] = cell?.frame.width
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: recipes.recipe_no!)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                cell?.recipeImageView.image = image
            }
        }else{
            executeTask(url_server!, requestParam) { (data, response, error) in
                //            print("input: \(String(data: data!, encoding: .utf8)!)")
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell?.recipeImageView.image = image
                        }
                        if let image = image?.jpegData(compressionQuality: 1.0) {
                            try? image.write(to: imageUrl, options: .atomic)
                        }
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                        DispatchQueue.main.async {
                            cell?.recipeImageView.image = image
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
        
        
        
        
        
        cell?.index = indexPath.row
        cell?.completionHandler = {(index) in
            self.index = index
            
            switch self.recipeList[index].flag {
            case 0:
                var requestParam = [String: Any]()
                requestParam["action"] = "insertCollect"
                requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
                requestParam["recipe_no"] = self.recipeList[self.index].recipe_no!
                executeTask(self.url_server!, requestParam) { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            let count = String(decoding: data!, as: UTF8.self)
                            if count == "1"{
                                self.recipeList[self.index].flag = 1
                                DispatchQueue.main.async {
                                    cell?.recipeCollectionButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                    cell?.recipeCollectionButton.tintColor = .red
                                }
                            }
                        }
                    }
                }
                break
            case 1:
                var requestParam = [String: Any]()
                requestParam["action"] = "deleteCollect"
                requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
                requestParam["recipe_no"] = self.recipeList[self.index].recipe_no!
                executeTask(self.url_server!, requestParam) { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            let count = String(decoding: data!, as: UTF8.self)
                            if count == "1"{
                                self.recipeList[self.index].flag = 0
                                DispatchQueue.main.async {
                                    cell?.recipeCollectionButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                    cell?.recipeCollectionButton.tintColor = .black
                                }
                            }
                        }
                    }
                }
                break
            default:
                break
            }
        }
            
        
        
        var requestParam0 = [String: Any]()
        requestParam0["action"] = "searchFollow"
        requestParam0["user_no"] = self.userDefault.value(forKey: "user_no")
        requestParam0["recipe_no"] = self.blog[indexPath.row].recipe_no!
        executeTask(url_server!, requestParam0) { (data, response, error) in
            if error == nil {
                if data != nil {
                    let count = Int(String(decoding: data!, as: UTF8.self)) ?? 0
                    if count == 1 {
                        DispatchQueue.main.async {
                            self.blog[indexPath.row].flag = 1
                            cell?.recipeCollectionButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            cell?.recipeCollectionButton.tintColor = .red
                        }
                    }else{
//                        self.flag[indexPath.row] = 0
                        DispatchQueue.main.async {
                            self.blog[indexPath.row].flag = 0
                            cell?.recipeCollectionButton.setImage(UIImage(systemName: "heart"), for: .normal)
                            cell?.recipeCollectionButton.tintColor = .black
                        }
                    }
                }
            }
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var requestParam_2 = [String: Any]()
        requestParam_2["action"] = "getUserImageForRecipeDetail"
        requestParam_2["chef_no"] = recipes.chef_no
        requestParam_2["imageSize"] = cell?.frame.width
        var image_2: UIImage?
        executeTask(url_server!, requestParam_2) { (data, response, error) in
//            print("input: \(String(data: data!, encoding: .utf8)!)")
            if error == nil {
                if data != nil {
                    image_2 = UIImage(data: data!)
                }
                if image == nil {
                    image_2 = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    cell?.chefImageView.layer.cornerRadius = (cell?.chefImageView.frame.height)!/2
                    cell?.chefImageView.image = image_2
                }
            } else {
                print(error!.localizedDescription)
            }
    }
        return cell ?? UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetail = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
//        let recipe = reciepLeaderList[indexPath.row]
//        recipeDetail.recipe = recipe
        let recipe = blog[indexPath.row]
        recipeDetail.blog = recipe
        self.navigationController?.pushViewController(recipeDetail, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
