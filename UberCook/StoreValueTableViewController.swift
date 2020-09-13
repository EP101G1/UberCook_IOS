//
//  StoreValueTableViewController.swift
//  UberCook
//
//  Created by Kira 2020/9/13.
//

import UIKit
import TPDirect

class StoreValueTableViewController: UITableViewController {
    let frontend_rediret_url = "https://example.com/front-end-redirect"
    let backend_notify_url = "https://example.com/back-end-notify"
    var linePay: TPDLinePay!
    var wallets = [Wallet]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wallets = getWallets()
//        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wallets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        let wallet = wallets[indexPath.row]
        cell.index = indexPath.row
        
        cell.count = {(index) in
            self.index = index
            let selectPoint = self.wallets[self.index].point
        
            // 初始化TPDLinePay物件
            self.linePay = TPDLinePay.setup(withReturnUrl: "UberCook://tw.chao.UberCook")
            
            // 檢查裝置是否可使用LINE Pay
            if (TPDLinePay.isLinePayAvailable()){
                // linePay呼叫getPrime()以取得prime，並從onSuccessCallback取得
                self.linePay.onSuccessCallback { (prime) in
                    self.generatePayByPrimeForSandBox(prime: prime!,point: selectPoint)
                }.onFailureCallback { (status, msg) in
                    print("status : \(status), msg : \(msg)")
                }.getPrime()
            } else {
                // 開啟App Store的Line App安裝畫面
                TPDLinePay.installLineApp()
            }
        }
        cell.lbpoint.text = String(wallet.point)
        cell.btMoney.setTitle(wallet.money, for: .normal)
        return cell
    }
    
    func generatePayByPrimeForSandBox(prime: String,point : Int) {
        let url_TapPay = URL(string: tapPaySanbox)
        var cardholderDic = [String: String]()
        cardholderDic["name"] = "Kira"
        cardholderDic["phone_number"] = "+886912345678"
        cardholderDic["email"] = "kira@email.com"
        
        var resultUrlDic = [String: String]()
        resultUrlDic["frontend_redirect_url"] = self.frontend_rediret_url
        resultUrlDic["backend_notify_url"] = self.backend_notify_url
        
        var paymentDic = [String: Any]()
        paymentDic["partner_key"] = partnerKey
        paymentDic["prime"] = prime
        paymentDic["merchant_id"] = merchantId
        paymentDic["amount"] = String(point)
        paymentDic["currency"] = "TWD"
        paymentDic["order_number"] = "SN0001"
        paymentDic["details"] = "UberCook點數"
        paymentDic["cardholder"] = cardholderDic
        paymentDic["result_url"] = resultUrlDic
        
        executeTask(url_TapPay!, paymentDic) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONSerialization.jsonObject(with: data!) {
                        if let resultDic = result as? [String: Any] {
                            // 取得 payment_url，在前端使用TPDirect.redirect(payment_url)，讓使用者進行 LINE Pay付款
                            let payment_url = resultDic["payment_url"] as! String
                            self.linePay.redirect(payment_url, with: self, completion: { (linePayResult) in
                                print("\n----------LINE Pay Result--------------")
                                print(linePayResult)
                            })
                        }
                    }
                    let text = String(data: data!, encoding: .utf8)!
                    print("\n----------Success--------------")
                    print(text)
                }
            }
        }
    }
    
    func executeTask(_ url: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestParam) {
            // 將輸出資料列印出來除錯用
            print("output: \(String(data: jsonData, encoding: .utf8)!)")
            var request = URLRequest(url: url)
            // request header要加上Content-Type與x-api-key設定，否則支付失敗
            request.addValue(partnerKey, forHTTPHeaderField: "x-api-key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            request.httpBody = jsonData
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: completionHandler)
            task.resume()
        } else {
            print("executeTask error")
        }
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
    
    func getWallets() -> [Wallet]{
        wallets.append(Wallet(50, "NT$50"))
        wallets.append(Wallet(100,"NT$100"))
        wallets.append(Wallet(500, "NT$500"))
        wallets.append(Wallet(1000, "NT$1000"))
        wallets.append(Wallet(2000, "NT$2000"))
        wallets.append(Wallet(3000, "NT$3000"))
        wallets.append(Wallet(5000, "NT$5000"))
        return wallets
    }

}
