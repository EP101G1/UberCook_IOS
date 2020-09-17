//
//  Home.swift
//  UberCook
//
//  Created by 超 on 2020/8/30.
//

import UIKit
import Foundation
import Starscream

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    let tag = "HomeTVC"
    let userDefault = UserDefaults()
    let url_server = URL(string: common_url + "UberCook_Servlet")
    var socket: WebSocket!
    let socket_server = GlobalVariables.shared.socket_server
    let fileManager = FileManager()
    var chefLeaderList = [ChefLeader]()
    var reciepLeaderList = [Recipe]()
    var fullScreenSize :CGSize!
    var user_no = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_no = userDefault.value(forKey: "user_no") as! String
        fullScreenSize = UIScreen.main.bounds.size
        collectionView.backgroundColor = UIColor.white
        collectionView2.backgroundColor = UIColor.white
      
        GlobalVariables.shared.socket = WebSocket(url: URL(string: socket_server + user_no)!)
        addSocketCallBacks()
        GlobalVariables.shared.socket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllChef()
        showAllRecipe()
    }
    
    
    // 也可使用closure偵測WebSocket狀態
    func addSocketCallBacks() {
        GlobalVariables.shared.socket.onConnect = {
            print("websocket is connected")
        }

        GlobalVariables.shared.socket.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(error?.localizedDescription ?? "")")
        }
        
        GlobalVariables.shared.socket.onText = { (text: String) in
            if let stateMessage = try? JSONDecoder().decode(StateMessage.self, from: text.data(using: .utf8)!) {
                let type = stateMessage.type
                let friend = stateMessage.user
                switch type {
                // 有user連線
                case "open":
                    // 上線的是好友而非自己就顯示該好友user name
                    if friend != self.user_no {
                        showToast(view: self.view, message: "\(friend) is online")
                    }
                // 有user斷線
                case "close":
                    // 斷線的是好友而非自己就顯示該好友user name
                    if friend != self.user_no {
                        showToast(view: self.view, message: "\(friend) is offline")
                    }
                default:
                    break
                }
                // 取得server上的所有user，但移除自己，否則會看到自己在聊天清單上
//                stateMessage.users.remove(self.user)
   //             self.friendList = Array(stateMessage.users)
                // 重刷好友清單
   //             self.tableView.reloadData()
            }
          
        }

        GlobalVariables.shared.socket.onData = { (data: Data) in
            print("\(self.tag) got some data: \(data.count)")
        }
    }
    
    func showAllChef(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getChefLeader"
        requestParam["getChefLeaderType"] = "ChefAll"
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
                    //                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([ChefLeader].self, from: data!){
                        self.chefLeaderList = result
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func showAllRecipe(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getRecipes"
        requestParam["getRecipeLeaderType"] = "ChefAll"
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    //                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([Recipe].self, from: data!){
                        self.reciepLeaderList = result
                        DispatchQueue.main.async {
                            self.collectionView2.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
        case 0:
            return chefLeaderList.count
        default:
            return reciepLeaderList.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 0:
            let chefBlog = self.storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
            let chef = chefLeaderList[indexPath.row]
            chefBlog.chefLeader = chef
            self.navigationController?.pushViewController(chefBlog, animated: true)
        default:
            let recipeDetail = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
            let recipe = reciepLeaderList[indexPath.row]
            recipeDetail.recipe = recipe
            self.navigationController?.pushViewController(recipeDetail, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            let chefLeader = chefLeaderList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCollectionViewCell
            cell.layer.cornerRadius = cell.frame.height/20
            var requestParam = [String: Any]()
            requestParam["action"] = "getUserImage"
            requestParam["user_no"] = chefLeader.user_no
            requestParam["imageSize"] = cell.frame.width
            var image: UIImage?
            let imageUrl = fileInCaches(fileName: chefLeader.user_no!)
            if self.fileManager.fileExists(atPath: imageUrl.path) {
                if let imageCaches = try? Data(contentsOf: imageUrl) {
                    image = UIImage(data: imageCaches)
                    DispatchQueue.main.async {
                        cell.HomeChefImageView.image = image
                    }
                }
            }else {
                executeTask(url_server!, requestParam) { (data, response, error) in
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if error == nil {
                        if data != nil {
                            image = UIImage(data: data!)
                            DispatchQueue.main.async {
                                cell.HomeChefImageView.image = image
                            }
                            if let image = image?.jpegData(compressionQuality: 1.0) {
                                try? image.write(to: imageUrl, options: .atomic)
                            }
                        }
                        if image == nil {
                            image = UIImage(named: "noImage.jpg")
                            DispatchQueue.main.async {
                                cell.HomeChefImageView.image = image
                            }
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
            return cell
        default:
            let recipeLeader = reciepLeaderList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! HomeCollectionViewCell
            cell.layer.cornerRadius = cell.frame.height/20
            var requestParam = [String: Any]()
            requestParam["action"] = "getRecipeImage"
            requestParam["recipe_no"] = recipeLeader.recipe_no
            requestParam["imageSize"] = 1440
            var image: UIImage?
            let imageUrl = fileInCaches(fileName: recipeLeader.recipe_no!)
            if self.fileManager.fileExists(atPath: imageUrl.path) {
                if let imageCaches = try? Data(contentsOf: imageUrl) {
                    image = UIImage(data: imageCaches)
                    DispatchQueue.main.async {
                        cell.HomeRecipeImageView.image = image
                    }
                }
            }else{
                executeTask(url_server!, requestParam) { (data, response, error) in
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if error == nil {   
                        if data != nil {
                            image = UIImage(data: data!)
                            DispatchQueue.main.async {
                                cell.HomeRecipeImageView.image = image
                            }
                            if let image = image?.jpegData(compressionQuality: 1.0) {
                                try? image.write(to: imageUrl, options: .atomic)
                            }
                        }
                        if image == nil {
                            image = UIImage(named: "noImage.jpg")
                            DispatchQueue.main.async {
                                cell.HomeRecipeImageView.image = image
                            }
                        }
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            }
            return cell
        }
    }
}
