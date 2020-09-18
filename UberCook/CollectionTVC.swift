//
//  CollectionTVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/11.
//

import UIKit

class CollectionTVC: UITableViewController {
    
    let fileManager = FileManager()
    let userDefault = UserDefaults()
    let url_server = URL(string: common_url + "UberCook_Servlet")
    var collection = [Collection]()
    var recipe_no = ""
    var index = 0
    var test = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCollection()
    }
    
    func getCollection(){
        let user_no = userDefault.value(forKey: "user_no")
        var requestParam = [String: Any]()
        requestParam["action"] = "getCollection"
        requestParam["user_no"] = user_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
                    //print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([Collection].self, from: data!){
                        self.collection = result
                        for index in 0...self.collection.count {
                            self.test.insert(true, at: index)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func onChange(sender: Any) {
        // 取得這個 UISwtich 元件
        let tempSwitch = sender as! UISwitch
        // 依據屬性 on 來為底色變色
        if tempSwitch.isOn {
            test[self.index] = true
            var requestParam = [String: Any]()
            requestParam["action"] = "insertCollect"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["recipe_no"] = self.recipe_no
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let count = String(decoding: data!, as: UTF8.self)
                        if count == "1"{
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }else{
            test[self.index] = false
            var requestParam = [String: Any]()
            requestParam["action"] = "deleteCollect"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["recipe_no"] = self.recipe_no
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let count = String(decoding: data!, as: UTF8.self)
                        if count == "1"{
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return collection.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        let collectionList = collection[indexPath.row]
        cell.index = indexPath.row
        cell.completionHandler = {(index) in
            self.index = index
            self.recipe_no = self.collection[index].recipe_no
        }
        if test[indexPath.row] {
            cell.collectionSwitch.isOn = true
        }else{
            cell.collectionSwitch.isOn = false
        }
        cell.collectionSwitch.addTarget(self, action: #selector(onChange(sender:)), for: .valueChanged)
        cell.collectionLabel.text = collectionList.recipe_title
        cell.collectionImageView.layer.cornerRadius = 10
        cell.layer.cornerRadius = cell.frame.height/20
        var requestParam = [String: Any]()
        requestParam["action"] = "getRecipeImage"
        requestParam["recipe_no"] = collectionList.recipe_no
        requestParam["imageSize"] = 720
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: collectionList.recipe_no)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                DispatchQueue.main.async {
                    cell.collectionImageView.image = image
                }
            }
        }else {
            executeTask(url_server!, requestParam) { (data, response, error) in
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell.collectionImageView.image = image
                        }
                        if let image = image?.jpegData(compressionQuality: 1.0) {
                            try? image.write(to: imageUrl, options: .atomic)
                        }
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                        DispatchQueue.main.async {
                            cell.collectionImageView.image = image
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionDVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        let collectionList = collection[indexPath.row]
        collectionDVC.collection = collectionList
        self.navigationController?.pushViewController(collectionDVC, animated: true)
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
