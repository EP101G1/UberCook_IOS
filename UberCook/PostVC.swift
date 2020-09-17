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
        let alertController = UIAlertController(title: "上傳食譜", message: "確定要上傳此篇食譜嗎？", preferredStyle: .alert)
        /* 建立標題為"Ok"，樣式為.default(預設樣式)的按鈕 */
        let ok = UIAlertAction(title: "上傳", style: .default) {
            /* alertAction代表被點擊的按鈕 */
            (alertAction) in
            let recipe_title = self.recipeTitleTextField.text == nil ? "" : self.recipeTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let recipe_con = self.recipeConTextView.text == nil ? "" : self.recipeConTextView.text!
            let recipe_point = Int(self.recipePointTextField.text ?? "0")
            let chef_no:String = self.userDefault.value(forKey: "chef_no") as! String
            let flag = 1
            
//            self.recipe?.recipe_no = ""
//            self.recipe?.recipe_title = self.recipeTitleTextField.text ?? ""
//            self.recipe?.recipe_con = self.recipeConTextView.text ?? ""
//            self.recipe?.recipe_point = Int(self.recipePointTextField.text ?? "0")
//            self.recipe?.chef_no = self.userDefault.value(forKey: "chef_no") as? String
//            self.recipe?.flag = 1
            
            let recipeData = Recipe("", recipe_title, recipe_con, recipe_point!, chef_no, flag)
            
            var requestParam = [String: String]()
            requestParam["action"] = "recipeInsert"
            requestParam["recipe"] = try! String(data: JSONEncoder().encode(recipeData), encoding: .utf8)
//            print(self.recipe)
//            requestParam["flag"] = flag
            // 有圖才上傳
            if self.image != nil {
                requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1)!.base64EncodedString()
            }
            executeTask(self.url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                DispatchQueue.main.async {
                                    // 新增成功則回前頁
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
