//
//  ChatPageController.swift
//  UberCook
//
//  Created by 謝承儒 on 2020/9/15.
//

import UIKit
import Starscream

class ChatPageController : UIViewController,UITableViewDataSource,UITableViewDelegate {
    let tag = "ChatPageTVC"
    let userDefault = UserDefaults()
    var chatMessageList = [ChatMessage]()
    var friend_no:String?
    let fileManager = FileManager()
    var chatRoomNo:Int?
    var NoForSelectPhoto:String?
    var role:String?
    var friend_name:String?
    var image: UIImage?
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var msgSendBtn: UIButton!
    var role_no = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(role == "U"){
            role_no = userDefault.value(forKey: "user_no") as! String
        }else{
            role_no = userDefault.value(forKey: "chef_no") as! String
        }
       
        addKeyboardObserver()
        addSocketCallBacks()
        updateReadStatus()
        SendReadChatMessage()
        getAllChat()
        getPhoto()
        
        
        //self.title = "friend: \(friend_no!)"
    }
    
    
    func getPhoto(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["user_no"] = NoForSelectPhoto
        requestParam["imageSize"] = 1440
        let imageUrl = fileInCaches(fileName: NoForSelectPhoto!)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
            }
        }else{
            executeTask(URL(string: common_url + "UberCook_Servlet")!, requestParam) { (data, response, error) in
            // print("input: \(String(data: data!, encoding: .utf8)!)")
            if error == nil {
                if data != nil {
                    self.image = UIImage(data: data!)
                    if let image = self.image?.jpegData(compressionQuality: 1.0) {
                        try? image.write(to: imageUrl, options: .atomic)
                    }
                }
                if self.image == nil {
                    self.image = UIImage(named: "noImage.jpg")
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        }
    }
    
    func getAllChat(){
        var requestParam = [String: Any]()
        requestParam["type"] = "getAll"
        requestParam["chatRoom"] = chatRoomNo
        executeTask(URL(string: common_url + "Chat_Servlet")!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
                print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([ChatMessage].self, from: data!){
                        self.chatMessageList = result
                        DispatchQueue.main.async {
                            self.chatTable.reloadData()
                            self.chatTable.scrollToRow(at: IndexPath(row: self.chatMessageList.count-1, section: 0), at: .bottom, animated: false)
                        }
                       
                    }
                }
            }
        }
    }
    
    func updateReadStatus(){
        var requestParam = [String: Any]()
        requestParam["type"] = "read"
        requestParam["friend"] = friend_name
        requestParam["chatRoom"] = chatRoomNo
       
        executeTask(URL(string: common_url + "Chat_Servlet")!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    print(String("update success"))
                }
            }
        }
    }
    
    func SendReadChatMessage(){
        let SendReadChatMessage = ChatMessage(chatRoom: chatRoomNo!,type: "read", sender: role_no, receiver: friend_no!, message: "read",read: "read",base64: nil,dateStr: nil,myName: userDefault.value(forKey: "user_name") as! String);
              
        if let jsonData = try? JSONEncoder().encode(SendReadChatMessage) {
            let text = String(data: jsonData, encoding: .utf8)
            GlobalVariables.shared.socket.write(string: text!)
            // debug用
            print("\(tag) send messages: \(text!)")
        }
    }
    
    // 也可使用closure偵測WebSocket狀態
    func addSocketCallBacks() {
    
        
        GlobalVariables.shared.socket.onText = { [self] (text: String) in
            if let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: text.data(using: .utf8)!) {
                let sender = chatMessage.sender
                let type = chatMessage.type
                // 接收到聊天訊息
                
                switch type {
                case "chat","img":
                    if sender == self.friend_no {
                        self.chatMessageList.append(chatMessage)
                        self.chatTable.reloadData()
                        self.chatTable.scrollToRow(at: IndexPath(row: self.chatMessageList.count-1, section: 0), at: .bottom, animated: false)
                        print(chatMessage.message)
                        SendReadChatMessage()
                    }
                case "read":
                    for index in 0..<self.chatMessageList.count {
                        if(self.chatMessageList[index].sender != self.friend_no){
                            self.chatMessageList[index].read =   "已讀"
                        }
                    }
                    self.chatTable.reloadData()
                    self.chatTable.scrollToRow(at: IndexPath(row: self.chatMessageList.count-1, section: 0), at: .bottom, animated: false)
                default:
                    print("default")
                }
               
            }
            
            print("\(self.tag) got some text: \(text)")
        }

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       var chatMessage:ChatMessage?
        
        chatMessage = chatMessageList[indexPath.row]
        
        if(chatMessage!.sender == friend_no){
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendChat", for: indexPath) as! FriendChatCell
            
            if(chatMessage?.type == "chat"){
                cell.FriendPhoto.layer.cornerRadius = 25
                cell.FriendPhoto.image = self.image
                cell.FriendMsg.text = chatMessage?.message
                cell.FriendMsgState.text = chatMessage?.dateStr
            
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChat", for: indexPath) as! MyChatCell
            if(chatMessage?.type == "chat"){
                cell.MyMsg.text = chatMessage?.message
                
                cell.MyMsgState.text = chatMessage!.read + " " +  (chatMessage?.dateStr)!
            }
            return cell
        }
        
        
    }
    
    @IBAction func msgSend(_ sender: Any) {
        let message = msgTextField.text
        // 訊息不可為nil或""
        if message == nil || message!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        let now = Date()
         
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm:ss"
        
        let chatMessage = ChatMessage(chatRoom: chatRoomNo!,type: "chat", sender: role_no, receiver: friend_no!, message: message!,read: "",base64: nil,dateStr: dformatter.string(from: now),myName: userDefault.value(forKey: "user_name") as! String);
        
        if let jsonData = try? JSONEncoder().encode(chatMessage) {
            let text = String(data: jsonData, encoding: .utf8)
            GlobalVariables.shared.socket.write(string: text!)
            // debug用
            print("\(tag) send messages: \(text!)")
            self.chatMessageList.append(chatMessage)
            self.chatTable.reloadData()
            self.chatTable.scrollToRow(at: IndexPath(row: self.chatMessageList.count-1, section: 0), at: .bottom, animated: false)
            // 將欲傳送訊息顯示在text view上
            //showMessage(textView: tvMessage, message: "\(sender!): \(message!)")
            // 將輸入的訊息清空
            msgTextField.text = nil
        }
        // 隱藏鍵盤
        msgTextField.resignFirstResponder()
    }
}


extension ChatPageController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            view.frame.origin.y = -keyboardHeight
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
