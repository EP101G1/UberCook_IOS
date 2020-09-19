struct  ChatMessage: Codable {
    var chatRoom: Int
    var type: String
    var sender: String?
    var receiver: String
    var message: String
    var read: String
    var base64: String?
    var dateStr: String?
    var myName: String?
    
//    init(chatRoom: Int, type: String, sender: String, receiver: String, message: String , read: String, base64: String, dateStr: String, myName: String) {
//        self.chatRoom = chatRoom
//        self.type = type
//        self.sender = sender
//        self.receiver = receiver
//        self.message = message
//        self.read = read
//        self.base64 = base64
//        self.dateStr = dateStr
//        self.myName = myName
//    }
}
