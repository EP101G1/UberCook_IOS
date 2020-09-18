//
//  ChatPageController.swift
//  UberCook
//
//  Created by 謝承儒 on 2020/9/15.
//

import UIKit
import Starscream

class ChatPageController : UIViewController,UITableViewDataSource {
    let tag = "ChatPageTVC"
    let userDefault = UserDefaults()
    var chatMessageList = [ChatMessage]()
    var friend_no:String?
    var user_no = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_no = userDefault.value(forKey: "user_no") as! String
        addKeyboardObserver()
        addSocketCallBacks()
        self.title = "friend: \(friend_no!)"
    }
    
    
    // 也可使用closure偵測WebSocket狀態
    func addSocketCallBacks() {
        GlobalVariables.shared.socket.onText = { (text: String) in
            if let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: text.data(using: .utf8)!) {
                let sender = chatMessage.sender
                let type = chatMessage.type
                // 接收到聊天訊息
                
                switch type {
                case "chat","img":
                    if sender == self.friend_no {
                        self.chatMessageList.append(chatMessage)
                    }
                case "read":
                    for index in 0...self.chatMessageList.count-1 {
                        if(self.chatMessageList[index].sender != self.friend_no){
                            self.chatMessageList[index].dateStr =  self.chatMessageList[index].dateStr! + " 已讀"
                        }
                    }
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
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mydChat", for: indexPath) as! MyChatCell
            return cell
        }
        
        
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
