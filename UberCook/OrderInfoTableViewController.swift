//
//  OrderInfoTableViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/18.
//

import UIKit

class OrderInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var orderDateTextField: UITextField!
    
    @IBOutlet weak var OrderNameTextField: UITextField!
    
    
    @IBOutlet weak var adrsTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var remarkTextView: UITextView!
    
    
    @IBOutlet weak var checkButton: UIButton!
    
    
    @IBOutlet weak var rejectButton: UIButton!
    
    var orderList:Order?
    let userDefault = UserDefaults()
    var image:UIImage?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let controller = parent as? WaittingDetailViewController
//        print("orderList", controller, controller?.orderList)
        orderList = controller?.orderList

        let dateTostr = orderList?.order_date
        orderDateTextField.text = dateConvertString(date: dateTostr!)

        OrderNameTextField.text = orderList?.user_name
        phoneTextField.text = orderList?.phone
        remarkTextView.text = orderList?.remark
        adrsTextField.text = orderList?.address
        
        let orderuserNo  = orderList?.user_no
        let myuserNo = userDefault.value(forKey: "user_no") as! String
         
         if orderuserNo == myuserNo {
            
            checkButton.isHidden = true
            rejectButton.isHidden = true
         }else{
            
         }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String { //date型態轉string
        
        let dateFormatter = DateFormatter() //設定時間格式

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    @IBAction func ifAccept(_ sender: Any) {
        
        let myuserNoQRcode = orderList?.user_no
        let data = myuserNoQRcode?.data(using: String.Encoding.utf8)
        // CIFilter是圖片處理器，指定QR code產生器產生對應的CIImage
        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // key為"inputMessage"代表要設定輸入資料，而輸入資料設為data即為utf8編碼的文字
        ciFilter.setValue(data, forKey: "inputMessage")
        // 取得產生好的QR code圖片，不過圖片很小
        guard let ciImage_smallQR = ciFilter.outputImage else { return }
        // QR code圖片很小，需要放大
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
        // 將CIImage轉成UIImage顯示
        let uiImage = UIImage(ciImage: ciImage_largeQR)
        self.image = uiImage
        
        getAccept()
    }
    
    func getAccept(){
        var requestParam = [String: Any]()
        requestParam["action"] = "dealOrder"
        requestParam["order_no"] = orderList?.order_no
        requestParam["user_no"] = orderList?.user_no
        requestParam["ifAccept"] = true
        requestParam["chef_name"] = userDefault.value(forKey: "user_name") as! String
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1)!.base64EncodedString()
        }
        executeTask(URL(string: common_url + "Order_Servlet")!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                   // print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = String(data: data!, encoding: .utf8){
                        let resultInt = result.trimmingCharacters(in: .whitespacesAndNewlines)
//                        print(resultInt)
//                        print(resultInt.count)
                        if let count = Int(resultInt){
                            DispatchQueue.main.async {
                                if count != 0 {
                                   
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                }
                            }
                        }
                    }
                    }
                }
            }
        }
    
    
    @IBAction func ifReject(_ sender: Any) {
        
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
