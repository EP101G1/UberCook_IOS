//
//  TrackTVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/11.
//

import UIKit

class TrackTVC: UITableViewController {
    
    let userDefault = UserDefaults()
    let url_server = URL(string: common_url + "UberCook_Servlet")
    var track = [Track]()
    let fileManager = FileManager()
    var chef_no = ""
    var index = 0
    var test = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.clipsToBounds = false
        tableView.layer.shadowOffset = CGSize(width: -6, height: 6)
        tableView.layer.shadowOpacity = 1
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTrack()
    }
    
    
    func getTrack(){
        let user_no = userDefault.value(forKey: "user_no")
        var requestParam = [String: Any]()
        requestParam["action"] = "getFollow"
        requestParam["user_no"] = user_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
                    //print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([Track].self, from: data!){
                        self.track = result
                        for index in 0...self.track.count {
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
            requestParam["action"] = "insertFollow"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["chef_no"] = self.chef_no
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
            requestParam["action"] = "deleteFollow"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["chef_no"] = self.chef_no
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
        return track.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        let trackList = track[indexPath.row]
        cell.index = indexPath.row
        cell.completionHandler = {(index) in
            self.index = index
            self.chef_no = self.track[index].chef_no
        }
        if test[indexPath.row] {
            cell.trackSwitch.isOn = true
        }else{
            cell.trackSwitch.isOn = false
        }
        cell.trackSwitch.addTarget(self, action: #selector(onChange(sender:)), for: .valueChanged)
        cell.trackImageView.layer.cornerRadius = 10
        cell.layer.cornerRadius = cell.frame.height/20
        cell.trackLabel.text = trackList.user_name
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["user_no"] = trackList.user_no
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: trackList.user_no)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                DispatchQueue.main.async {
                    cell.trackImageView.image = image
                }
            }
        }else {
            executeTask(url_server!, requestParam) { (data, response, error) in
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell.trackImageView.image = image
                        }
                        if let image = image?.jpegData(compressionQuality: 1.0) {
                            try? image.write(to: imageUrl, options: .atomic)
                        }
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                        DispatchQueue.main.async {
                            cell.trackImageView.image = image
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
        let trackDVC = self.storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
        let trackList = track[indexPath.row]
        trackDVC.track = trackList
        self.navigationController?.pushViewController(trackDVC, animated: true)
    }
    
    
//    @IBAction func clickToTrack(_ sender: UISwitch) {
//        if sender.isOn == true{
//            var requestParam = [String: Any]()
//            requestParam["action"] = "insertFollow"
//            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
//            requestParam["chef_no"] = chef_no
//            executeTask(url_server!, requestParam) { (data, response, error) in
//                if error == nil {
//                    if data != nil {
//                        let count = String(decoding: data!, as: UTF8.self)
//                        if count == "1"{
//                            DispatchQueue.main.async {
//                            }
//                        }
//                    }
//                }
//            }
//        }else{
//            var requestParam = [String: Any]()
//            requestParam["action"] = "deleteFollow"
//            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
//            requestParam["chef_no"] = chef_no
//            executeTask(url_server!, requestParam) { (data, response, error) in
//                if error == nil {
//                    if data != nil {
//                        let count = String(decoding: data!, as: UTF8.self)
//                        if count == "1"{
//                            DispatchQueue.main.async {
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
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
