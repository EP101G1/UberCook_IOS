//
//  PersonalVCViewController.swift
//  UberCook
//
//  Created by 超 on 2020/9/19.
//

import UIKit

class PersonalVCViewController: UITableViewController {
    

    
    @IBOutlet weak var personalImageView: UIImageView!
    
    let userDefault = UserDefaults()
    let url_server = URL(string: common_url + "UberCook_Servlet")
    let fileManager = FileManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        personalImageView.layer.cornerRadius = 20
        getUserImage()
        tableView.tableFooterView = UIView()
    }
    
    
    func getUserImage(){
        let user_no = userDefault.value(forKey: "user_no") as! String
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["user_no"] = user_no
        requestParam["imageSize"] = 1440
        requestParam["notJoin"] = "yes"
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: user_no)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                    self.personalImageView.image = image
            }
        }else{
            executeTask(url_server!, requestParam) { (data, response, error) in
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.personalImageView.image = image
                        }
                        if let image = image?.jpegData(compressionQuality: 1.0) {
                            try? image.write(to: imageUrl, options: .atomic)
                        }
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                        DispatchQueue.main.async {
                            self.personalImageView.image = image
                        }
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func clickLogout(_ sender: Any) {
        let alertController = UIAlertController(title: "登出", message: "確定登出嗎？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default) {
            (alertAction) in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            self.jumpToLogin()
            self.removeCache()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        /* Alert Controller加上ok與cancel按鈕 */
        alertController.addAction(ok)
        alertController.addAction(cancel)

        /* 呼叫present()才會跳出Alert Controller */
        self.present(alertController, animated: true, completion:nil)
    }
    
    func jumpToLogin(){
        let login = Login()
        login.modalPresentationStyle = .fullScreen
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Login") {
            present(controller, animated: true, completion: nil)
        }
   
    }
    
    func removeCache (){
            // 取出cache資料夾路徑.如果清除其他位子的可以將cachesDirectory換成對應的資料夾
            let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
            
            // 列印路徑,需要測試的可以往這個路徑下放東西
            //print(cachePath)
            // 取出資料夾下所有檔案陣列
            let files = FileManager.default.subpaths(atPath: cachePath!)
            
            // 點選確定時開始刪除
            for p in files!{
                // 拼接路徑
                let path = cachePath!.appendingFormat("/\(p)")
                // 判斷是否可以刪除
                if FileManager.default.fileExists(atPath: path){
                    // 刪除
                    //                try! FileManager.default.removeItem(atPath: path)
                    /*******/
                    //避免崩潰
                    do {
                        try FileManager.default.removeItem(atPath: path as String)
                    } catch {
                        print("removeItemAtPath err"+path)
                    }
                }
                
            }
            
        }
    
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
