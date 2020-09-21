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
    let socket_server = "ws://192.168.196.137:8080/UberCook_Server/TwoChatServer/"
    var socket: WebSocket!
}

