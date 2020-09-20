//
//  startingOrderInfoTableViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/18.
//

import UIKit
import AVFoundation

class startingOrderInfoTableViewController: UITableViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    var orderList:Order?
    let userDefault = UserDefaults()
    var image: UIImage?
    
    @IBOutlet weak var OrderDateTextField: UITextField!
    
    @IBOutlet weak var OrderNameTextField: UITextField!
    
    @IBOutlet weak var adrsTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    @IBOutlet weak var remarkTextView: UITextView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var EvaluationButton: UIButton!
    
    @IBOutlet weak var userNoButton: UIButton!
    
    
    @IBOutlet weak var chefNoButton: UIButton!
    
    @IBOutlet weak var scanQrcodeButton: UIButton!
    
    
    // 預覽時管理擷取影像的物件
    var captureSession: AVCaptureSession!
    // 預覽畫面
    var previewLayer: AVCaptureVideoPreviewLayer!
    // 偵測到QR code時需要加框
    var qrFrameView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addSocketCallBacks()
        self.userDefault.setValue(orderList?.user_no, forKey: "custom_no")
        self.userDefault.setValue(orderList?.address, forKey: "custom_adrs")

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrderInfo()
        if orderList?.flag != 1 {
            userNoButton.isHidden = true
            chefNoButton.isHidden = true
            photoImageView.isHidden = true
        }
      

    }
    
    
    @IBAction func OnClickEvaluationButton(_ sender: Any) {
        
    }
    
    
  
    // 也可使用closure偵測WebSocket狀態
    func addSocketCallBacks() {
    
        
        GlobalVariables.shared.socket.onText = { [self] (text: String) in
            if let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: text.data(using: .utf8)!) {
                let type = chatMessage.type
                // 接收到聊天訊息
                
                switch type {
                case "QRCODE":
                    if(chatMessage.message == orderList?.user_no ){
                        photoImageView.isHidden = true
                        EvaluationButton.isHidden = false
                    }else{
                        //秀alert說條碼不符
                    }
                    
                default:
                    print("default")
                }
               
            }
            
            //print("\(self.tag) got some text: \(text)")
        }

    }
    
    func showOrderInfo(){
        
        let controller = parent as? StartingDetailViewController
       // print("orderList", controller, controller?.orderList) 確定有無帶到資料
        orderList = controller?.orderList
        
        
        let dateTostr = orderList?.order_date
        OrderDateTextField.text = dateConvertString(date: dateTostr!)

        OrderNameTextField.text = orderList?.user_name
        phoneTextField.text = orderList?.phone
        remarkTextView.text = orderList?.remark
        adrsTextField.text = orderList?.address
        
        
        let orderuserNo  = orderList?.user_no
        let myuserNo = userDefault.value(forKey: "user_no") as! String
        
        if orderuserNo == myuserNo {
            
            chefNoButton.isHidden = true
            photoImageView.isHidden = true
            EvaluationButton.isHidden = true
         

        }else{
            userNoButton.isHidden = true
            EvaluationButton.isHidden = true
            scanQrcodeButton.isHidden = true
            getQRcode()
            
        }
        
    }
    

    
    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> String { //date型態轉string
        
        let dateFormatter = DateFormatter() //設定時間格式

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    

    
    func getQRcode(){
        var requestParam = [String: Any]()
        requestParam["action"] = "getQR"
        requestParam["order_no"] = orderList?.order_no
        requestParam["imageSize"] = 1440
    
        executeTask(URL(string: common_url + "Order_Servlet")!, requestParam) { (data, response, error)in
            if let data = data,
               let image = UIImage(data: data){
                self.image = image
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
        }
    
}
    
    func changeFlag(qrCode:String){
        var requestParam = [String: Any]()
        requestParam["action"] = "updateOrderFlag"
        requestParam["order_no"] = orderList?.order_no
        
        executeTask(URL(string: common_url + "Order_Servlet")!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
               let result = String(data: data!, encoding: .utf8)!
               let resultInt = result.trimmingCharacters(in: .whitespacesAndNewlines)
                    if let count = Int(resultInt){
                        if count == 1{
                            DispatchQueue.main.async {
                                self.scanQrcodeButton.isHidden = true
                                self.EvaluationButton.isHidden = false
                                self.userNoButton.isHidden = true
                                self.chefNoButton.isHidden = true
                                self.photoImageView.isHidden = true
                                let chatMessage = ChatMessage(chatRoom: 0,type: "QRCODE", sender: "", receiver: self.orderList!.chef_no, message: qrCode,read: "",base64: nil,dateStr: "",myName: self.userDefault.value(forKey: "user_name") as! String)
                                
                                if let jsonData = try? JSONEncoder().encode(chatMessage) {
                                    let text = String(data: jsonData, encoding: .utf8)
                                    GlobalVariables.shared.socket.write(string: text!)
                                }
                               
                            }
                        }
                       
                    }
                }
            }
    }
        
    }
    
    
    @IBAction func pleaseScanQRcode(_ sender: Any) {
        
        startPreviewAndScanQR()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            // 將畫面鎖定為直式
            delegate.orientationLock = .portrait
        }
        preview(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .all
        }
        preview(false)
    }
    
    func startPreviewAndScanQR() {
        // 管理影像擷取期間的輸入與輸出
        captureSession = AVCaptureSession()
        // 負責擷取影像的預設裝置
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        // 建立輸入物件
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        if captureSession.canAddInput(input) {
            // 設定擷取期間的輸入
            captureSession.addInput(input)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            // 設定擷取期間的輸出
            captureSession.addOutput(metadataOutput)
            
            // 設定欲處理的類型為QR code
            metadataOutput.metadataObjectTypes = [.qr]
            // 一旦掃到QR code會呼叫AVCaptureMetadataOutputObjectsDelegate.metadataOutput()
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        // 建立擷取期間所需顯示的預覽圖層
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        createQRFrame()
        preview(true)
    }
    
    // 建立QR code掃描框
    func createQRFrame() {
        qrFrameView = UIView()
        qrFrameView.layer.borderColor = UIColor.yellow.cgColor
        qrFrameView.layer.borderWidth = 3
        view.addSubview(qrFrameView)
        // 將掃描框移到最上方才不會被遮蔽
        view.bringSubviewToFront(qrFrameView)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 將取得的資訊轉成條碼資訊
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let qrString = metadataObject.stringValue else { return }
            // 讓手機震動
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            scanSuccess(qrCode: qrString)
            // 取得QR code座標資訊
            if let barCodeObject = previewLayer.transformedMetadataObject(for: metadataObject) {
                // 成功解析就將QR code圖片框起來
                qrFrameView.frame = barCodeObject.bounds
            }
        } else {
            // 無法轉成條碼資訊就將圖框隱藏
            qrFrameView.frame = CGRect.zero
        }
    }
    
    func scanSuccess(qrCode: String) {
        print(userDefault.value(forKey: "user_no") as!String)
        if qrCode == userDefault.value(forKey: "user_no") as!String {
            changeFlag(qrCode: qrCode)
        }else{
            let controller = UIAlertController(title: "錯誤", message: "訂單不符 請重新掃描QR Code", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
              controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)

        }
        
        
    
        print("result: \(qrCode)")
        // 停止預覽
        preview(false)

 
        
    }
    
    // 是否開啟預覽畫面
    func preview(_ yes: Bool) {
        if yes {
            // 讓QR code掃描框消失 (避免前一次QR code掃描框留在畫面上)
            qrFrameView.frame = CGRect.zero
            if (!captureSession.isRunning) {
                captureSession.startRunning()
            }
        } else {
            
            if let captureSession = captureSession {
                if (captureSession.isRunning) {
                    captureSession.stopRunning()
                    previewLayer.removeFromSuperlayer()
                    qrFrameView.removeFromSuperview()
                }
            }
            
            
           
        }
    }
    
    func failed() {
        let alert = UIAlertController(title: "Scanning not supported", message: "Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
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
