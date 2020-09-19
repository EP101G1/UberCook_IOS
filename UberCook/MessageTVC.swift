//
//  MessageTVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/18.
//

import UIKit

class MessageTVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let url_server = URL(string: common_url + "UberCook_Servlet")
    var message = [Message]()
    var recipe_no:String?
    var messageData = Message()
    let fileManager = FileManager()
    let userDefault = UserDefaults()

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageSendButton: UIButton!
    @IBOutlet weak var messageTableview: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        getMessage()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }
    
    @objc func dismissKeyBoard() {
            self.view.endEditing(true)
        }
    
    func getMessage(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getMessage"
        requestParam["message"] = self.recipe_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([Message].self, from: data!){
                        self.message = result
                        DispatchQueue.main.async {
                            self.messageTableview.reloadData()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell
        let msg = message[indexPath.row]
        cell?.messageUserNameLabel.text = "\(msg.user_name ?? ""):"
        cell?.messageUserConLabel.text = msg.msg_con
        cell?.messageUserImage.layer.cornerRadius = 20
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["user_no"] = msg.user_no
        requestParam["imageSize"] = cell?.frame.width
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: msg.user_no!)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                DispatchQueue.main.async {
                    cell?.messageUserImage.image = image
                }
            }
        }else{
            executeTask(url_server!, requestParam) { (data, response, error) in
//                    print("input: \(String(data: data!, encoding: .utf8)!)")
                if error == nil {
                    if data != nil {
                        image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            cell?.messageUserImage.image = image
                        }
                        if let image = image?.jpegData(compressionQuality: 1.0) {
                            try? image.write(to: imageUrl, options: .atomic)
                        }
                    }
                    if image == nil {
                        image = UIImage(named: "noImage.jpg")
                        DispatchQueue.main.async {
                            cell?.messageUserImage.image = image
                        }
                    }
                    
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        messageData.msg_con = self.messageTextField.text
        messageData.recipe_no = self.recipe_no
        messageData.user_no = (userDefault.value(forKey: "user_no") as! String)
        
        var requestParam = [String: String]()
        requestParam["action"] = "sendMessage"
        requestParam["takeMessage"] = try! String(data: JSONEncoder().encode(messageData), encoding: .utf8)
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if Int(result) != nil {
                            self.getMessage()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        self.messageTextField.text = ""
    }
    
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight+80
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }

    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
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
