//
//  PostVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/13.
//

import UIKit

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var recipeConTextView: UITextView!
    @IBOutlet weak var recipePointTextField: UITextField!
    @IBOutlet weak var recipeImageView: UIImageView!
    let userDefault = UserDefaults()
    var image:UIImage?
    let url_server = URL(string: common_url + "UberCook_Servlet")
    let recipe:Recipe? = nil
    var flag:Int?
    var recipeTitle:String?
    var con:String?
    var point:String?
    var recipe_no:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        recipeConTextView.layer.borderWidth = 1
        recipeConTextView.layer.borderColor = UIColor.gray.cgColor
        recipeConTextView.layer.cornerRadius = 5
        recipeTitleTextField.layer.borderColor = UIColor.gray.cgColor
        recipeTitleTextField.layer.borderWidth = 1
        recipeTitleTextField.layer.cornerRadius = 5
        recipePointTextField.layer.borderColor = UIColor.gray.cgColor
        recipePointTextField.layer.borderWidth = 1
        recipePointTextField.layer.cornerRadius = 5
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
                
        if self.flag == 1 {
            recipeTitleTextField.text = self.recipeTitle
            recipeConTextView.text = self.con
            recipePointTextField.text = self.point
            recipeImageView.image = self.image
        }
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil)
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil)
//
//        /* 將 View 原始範圍儲存 */
//        rect = view.bounds
    }
    
    @objc func dismissKeyBoard() {
            self.view.endEditing(true)
        }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//            /* 開始輸入時，將輸入框實體儲存 */
//        recipePointTextField = textField
//        }
    
//    @objc func keyboardWillShow(note: NSNotification) {
//            if recipePointTextField == nil {
//                return
//            }
//
//            let userInfo = note.userInfo!
//            /* 取得鍵盤尺寸 */
//            let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
//            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
//            /* 取得焦點輸入框的位置 */
//            let origin = (recipePointTextField?.frame.origin)!
//            /* 取得焦點輸入框的高度 */
//            let height = (recipePointTextField?.frame.size.height)!
//            /* 計算輸入框最底部Y座標，原Y座標為上方位置，需要加上高度 */
//            let targetY = origin.y + height
//            /* 計算扣除鍵盤高度後的可視高度 */
//            let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height
//
//            /* 如果輸入框Y座標在可視高度外，表示鍵盤已擋住輸入框 */
//            if targetY >= visibleRectWithoutKeyboard {
//                var rect = self.rect!
//                /* 計算上移距離，若想要鍵盤貼齊輸入框底部，可將 + 5 部分移除 */
//                rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + 100
//
//                UIView.animate(
//                    withDuration: duration,
//                    animations: { () -> Void in
//                        self.view.frame = rect
//                    }
//                )
//            }
//        }
    @IBAction func Magic(_ sender: Any) {
        recipePointTextField.text = String(100)
        recipeTitleTextField.text = "健康油條"
        recipeConTextView.text = "原料\n" +
        "普通麵粉 300克（高筋麵粉更好一些，不要用低筋麵粉）, 清水 170~180克（麵粉的吸水性不同，清水要分次倒入，涼水就可以，希望發酵快些的可以用溫水）, 酵母粉 5克, 小蘇打 2克, 食用油 15克, 鹽 3克（淡淡的，喜歡正常鹹味的可以放5~6鹽）\n" +
        "\n" +
        "步驟\n" +
        "1將麵粉放入盆中，放入酵母粉、小蘇打和鹽拌勻\n" +
        "\n" +
        "\n" +
        "2倒入清水攪成小面絮，然後揉成光滑的麵糰。因為麵粉的吸水性不同清水可以分次倒入，揉好的麵糰非常柔軟，但是絕不是稀得沾手的那種，和耳垂一樣柔軟就可以\n" +
        "\n" +
        "\n" +
        "3再放入15克食用油（我一般用色拉油，別的植物油都可以），將油揉進麵糰中，剛開始感覺麵糰會滑膩膩的，揉一揉就看不到油了，只是感覺麵糰非常的滋潤\n" +
        "\n" +
        "\n" +
        "4將揉好的麵糰放入盆中蓋上餳(靜置）10分鐘後，再揉一揉就可以蓋上發酵了\n" +
        "\n" +
        "\n" +
        "5將麵糰發成2倍大，發大一些也沒關係\n" +
        "\n" +
        "\n" +
        "6用手撥開麵糰會發現有很多的孔洞，面發的很柔軟但不是很稀的狀態，從盆中取出，因為麵糰里有油，不會粘的，用手在盆里抹一下就會全部取出\n" +
        "\n" +
        "\n" +
        "7將面板上用手抹一層油，這樣手上也有油就不會沾了，將發好的面放到面板上揉幾下成團即可\n" +
        "\n" +
        "\n" +
        "8然後用擀麵杖擀成0.5厘米厚的大片(不要太薄，不然炸出來裡面不柔軟），然後用刀切成10厘米長3厘米寬的長條，也可以根據你鍋的大小切成適合你的長度和寬度，300克麵粉大約可以做12根油條（我先用了一點麵糰炸了油餅，所以圖上是九根的量）\n" +
        "\n" +
        "\n" +
        "9將切好的條先靜置幾分鐘再接著做，這樣會炸得更蓬鬆，我有的時候著急不靜置直接做效果也不錯，自己看著辦吧！取兩條面摞在一起然後將筷子豎著放到面片的中間，用手按壓筷子的兩頭將面片中間壓上一條印，壓得稍微深一些炸的時候兩條面片才不會分開\n" +
        "\n" +
        "\n" +
        "10拎著面片的兩頭抻長一點，再兩手反方向擰一下\n" +
        "\n" +
        "\n" +
        "11直接放入燒到7、8成熱的油鍋中（擀麵片之前就可以點火熱油了），可以先用一小塊面放入油鍋里試一下，麵糰放進去就浮上來說明油溫就可以了\n" +
        "\n" +
        "\n" +
        "12油條生坯放進油鍋中立刻就會浮上來，要用筷子撥弄著翻轉，中大火炸制，不要用小火，那樣炸出來的油條外皮會很硬，等到油條的兩面都成金黃色就可以撈出來，豎著放置會將多餘的油控一控\n" +
        "\n" +
        "\n" +
        "13用此麵糰炸油餅也可以，只需將發好的麵糰分成30克左右的小團，擀開成0.3左右的圓形薄片，中間豎著劃兩刀拎起放入油鍋中炸上色即可，油溫和炸油條一樣"
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
            /* 鍵盤隱藏時將畫面下移回原樣 */
            let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
            let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)

            UIView.animate(
                withDuration: duration,
                animations: { () -> Void in
                    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
                }
            )
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
            view.frame.origin.y = -keyboardHeight+100
        } else {
            view.frame.origin.y = -view.frame.height / 3
        }
    }

    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
     
    
    @IBAction func Insert(_ sender: Any) {
        let alertController = UIAlertController(title: self.flag == 1 ? "修改食譜" : "上傳食譜",
                                                message: self.flag == 1 ? "確定要修改此篇食譜嗎？" : "確定要上傳此篇食譜嗎？",
                                                preferredStyle: .alert)
        /* 建立標題為"Ok"，樣式為.default(預設樣式)的按鈕 */
        let ok = UIAlertAction(title: self.flag == 1 ? "修改" : "上傳", style: .default) {
            /* alertAction代表被點擊的按鈕 */
            (alertAction) in
            
            let recipe_title = self.recipeTitleTextField.text == nil ? "" : self.recipeTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let recipe_con = self.recipeConTextView.text == nil ? "" : self.recipeConTextView.text!
            let recipe_point = Int(self.recipePointTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let chef_no:String = self.userDefault.value(forKey: "chef_no") as! String
            
            let recipeData = Recipe(self.recipe_no ?? "", recipe_title, recipe_con, recipe_point ?? 0, chef_no, 1)
            
            var requestParam = [String: String]()
            requestParam["action"] = self.flag == 1 ? "recipeUpdate" : "recipeInsert"
            requestParam["recipe"] = try! String(data: JSONEncoder().encode(recipeData), encoding: .utf8)
            requestParam["flag"] = "1"
            if self.image != nil {
                requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1)!.base64EncodedString()
                let imageUrl = fileInCaches(fileName: self.recipe_no ?? "")
                if let image = self.image?.jpegData(compressionQuality: 1.0) {
                    try? image.write(to: imageUrl, options: .atomic)
                }
            }
            executeTask(self.url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    if count != 0 {
                                        self.navigationController?.popViewController(animated: true)
                                    } else {
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
//         建立標題為"Cancel"，樣式為.cancel(取消樣式)的按鈕
        let cancel = UIAlertAction(title: "取消", style: .cancel)

        alertController.addAction(ok)
        alertController.addAction(cancel)

        /* 呼叫present()才會跳出Alert Controller */
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
    
    
    @IBAction func clickPickImage(_ sender: UIButton) {
        /* 建立樣式為.actionSheet(長得像Action Sheet)的Alert Controller */
        let alertController = UIAlertController(title: "", message: "選取一張照片", preferredStyle: .actionSheet)
        
        let takePicture = UIAlertAction(title: "拍照", style: .default) {_ in
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            /* 照片來源為相機 */
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let pickPicture = UIAlertAction(title: "選擇照片", style: .default) {_ in
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            /* 照片來源為相簿 */
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }

        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(takePicture)
        alertController.addAction(pickPicture)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /* 利用指定的key從info dictionary取出照片 */
        if let pickedImage = info[.originalImage] as? UIImage {
            recipeImageView.image = pickedImage
//            self.image = pickedImage
            self.image = newSizeImage(size: CGSize(width: 720, height: 720), source_image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func newSizeImage(size: CGSize, source_image: UIImage) -> UIImage {
        var newSize = CGSize(width: source_image.size.width, height: source_image.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: source_image.size.width / tempWidth, height: source_image.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: source_image.size.width / tempHeight, height: source_image.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        source_image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
