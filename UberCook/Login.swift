//
//  Login.swift
//  UberCook
//
//  Created by 超 on 2020/8/29.
//

import UIKit
import Foundation

class Login: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let url_server = URL(string: common_url + "Login_Servlet")
    let userDefault = UserDefaults()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("USER : \(self.userDefault.dictionaryRepresentation())")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {}
    @IBAction func didEndOnExit2(_ sender: Any) {}
    
    @IBAction func textFieldresignFirstRespondertouchDown(_ sender: Any) {
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func magicButton(_ sender: Any) {
        self.accountTextField.text = "acc001"
        self.passwordTextField.text = "psw001"
    }
    
    
    
    
    @IBAction func clickLogin(_ sender: Any) {
        let account = accountTextField.text == nil ? "" : accountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text == nil ? "" : passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var requestParam = [String: String]()
        requestParam["action"] = "getone"
        requestParam["acc"] = account
        requestParam["psw"] = password
        executeTask(url_server!, requestParam) { (data, response, error) in
            //            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
                    let decoder = JSONDecoder()
                    if let result = try? decoder.decode(LoginObj.self, from: data!) {
                        if result.Result == "successful" {
//                            print(result)
                            if(result.USER!.flag == 2){
                                self.userDefault.setValue(result.CHEF_NO!,forKey: "chef_no")
                            }
                            self.userDefault.setValue(result.USER!.user_no,forKey: "user_no")
                            self.userDefault.setValue(result.USER!.user_acc,forKey: "user_acc")
                            self.userDefault.setValue(result.USER!.user_psw,forKey: "user_psw")
                            self.userDefault.setValue(result.USER!.user_name,forKey: "user_name")
                            self.userDefault.setValue(result.USER!.user_points,forKey: "point")
                            self.userDefault.setValue(result.USER!.user_phone,forKey: "user_phone")
                            self.userDefault.setValue(result.USER!.user_adrs,forKey: "user_adrs")
                            self.userDefault.setValue(result.USER!.token_flag,forKey: "token_flag")
                            self.userDefault.setValue(result.USER!.user_si,forKey: "user_si")
                            self.userDefault.setValue(result.USER!.user_bank_account,forKey: "user_bank_account")
                            
//                            let domain = Bundle.main.bundleIdentifier!
//                            UserDefaults.standard.removePersistentDomain(forName: domain)
//                            UserDefaults.standard.synchronize()
                            
//                            print("USER : \(self.userDefault.dictionaryRepresentation())")
                            DispatchQueue.main.sync {
                                self.performSegue(withIdentifier: "Home", sender: self)
                            }
                            
                        }else{
//                            print("Login Fail")
//                            print(result.msg!)
                        }
                    }
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//extension UserDefaults{
//    enum Keys: String, CaseIterable {
//
//           case unitsNotation
//           case temperatureNotation
//           case allowDownloadsOverCellular
//
//       }
//
//       func reset() {
//           Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
//       }
//}
