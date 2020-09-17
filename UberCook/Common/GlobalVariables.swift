//
//  GlobalVariables.swift
//  UberCook
//
//  Created by 謝承儒 on 2020/9/14.
//

import Foundation
import Starscream

class GlobalVariables: NSObject {
    static let shared = GlobalVariables()
    let socket_server = "ws://127.0.0.1:8080/UberCook_Server/TwoChatServer/"
    var socket: WebSocket!
}
