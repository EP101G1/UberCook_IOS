//
//  BlogViewController.swift
//  UberCook
//
//  Created by 超 on 2020/9/2.
//

import UIKit


class BlogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var collectionView: UICollectionView!
    let url_server = URL(string: common_url + "UberCook_Servlet")
    var chefLeader: ChefLeader?
    var blogList = [Blog]()
    var test:IndexPath?
    var reusableView:BlogHeardReusableView?
    var trackNum:Int = 0
    let fileManager = FileManager()
    let userDefault = UserDefaults()
    var flag = 0
    var track:Track?
    var chatRoomNo:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBlog()
        title = chefLeader?.user_name ?? track?.user_name
//        UIView.performWithoutAnimation {
//                   CATransaction.setDisableActions(false)
//                   self.collectionView.reloadData()
//                   CATransaction.commit()
//               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTrack()
        searchTrack()
        checkChatRoom()
        getBlog()
        title = chefLeader?.user_name ?? track?.user_name
    }
    
    
    func checkChatRoom(){
        var requestParam = [String: Any]()
        requestParam["type"] = "getChatRoom"
        requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
        requestParam["chef_no"] = chefLeader?.chef_no ?? track?.chef_no
        requestParam["user_name"] = self.userDefault.value(forKey: "user_name")
        requestParam["chef_name"] = chefLeader?.user_name ?? track?.user_name
        executeTask(URL(string: common_url + "Chat_Servlet")!, requestParam) { (data, response, error) in
                           
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    dump(String(data: data!, encoding: .utf8)!)
                    let room = String(data: data!, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.chatRoomNo = Int(room) ?? 0
                }
            }
        }
    }
    
    
    func getTrack(){
        let chef_no = userDefault.value(forKey: "chef_no")
        var requestParam = [String: Any]()
        requestParam["action"] = "getFollows"
        requestParam["chef_no"] = chefLeader?.chef_no ?? track?.chef_no ?? chef_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.trackNum = Int(String(decoding: data!, as: UTF8.self))!
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                }
            }
        }
    }
    
    func getBlog(){
        let chef_no = userDefault.value(forKey: "chef_no")
        var requestParam = [String: Any]()
        requestParam["action"] = "getBlog"
        requestParam["chef_no_blog"] = chefLeader?.chef_no ?? track?.chef_no ?? chef_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            let decoder = JSONDecoder()
            if error == nil {
                if data != nil {
//                print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? decoder.decode([Blog].self, from: data!){
                        self.blogList = result
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func searchTrack(){
        let chef_no = userDefault.value(forKey: "chef_no")
        var requestParam = [String: Any]()
        requestParam["action"] = "searchTrack"
        requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
        requestParam["chef_no"] = chefLeader?.chef_no ?? track?.chef_no ?? chef_no
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    self.flag = Int(String(decoding: data!, as: UTF8.self)) ?? 0
                }
            }
        }
    }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blogList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let bolg = blogList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCell", for: indexPath) as! BlogCollectionViewCell
        var requestParam = [String: Any]()
        requestParam["action"] = "getRecipeImage_chef_no"
        requestParam["recipe_no"] = bolg.recipe_no
        requestParam["imageSize"] = 1440
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: bolg.recipe_no!)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                    cell.BlogImageView.image = image
            }
        }else{
        executeTask(url_server!, requestParam) { (data, response, error) in
            // print("input: \(String(data: data!, encoding: .utf8)!)")
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        cell.BlogImageView.image = image
                    }
                    if let image = image?.jpegData(compressionQuality: 1.0) {
                        try? image.write(to: imageUrl, options: .atomic)
                    }
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                    DispatchQueue.main.async {
                        cell.BlogImageView.image = image
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header", for: indexPath) as? BlogHeardReusableView
        let user_name = userDefault.value(forKey: "user_name") as! String
        let user_si = userDefault.value(forKey: "user_si") as! String
        reusableView?.chefImageView.layer.cornerRadius = (reusableView?.chefImageView.frame.height)! / 2
        reusableView?.chefSi.text = chefLeader?.user_si ?? track?.user_si ?? user_si
        reusableView?.chefName.text = chefLeader?.user_name ?? track?.user_name ?? user_name
        reusableView?.postLabel.text = String(blogList.count)
        reusableView?.followLabel.text = String(self.trackNum)
        let chef_no = userDefault.value(forKey: "chef_no") as? String
        
        
        
      
            if chefLeader?.chef_no == chef_no && track?.chef_no == nil{
                print("111111")
                reusableView?.postButton.isHidden = false
                reusableView?.chatButton.isHidden = true
                reusableView?.trackButton.isHidden = true
                reusableView?.reserveButton.isHidden = true
            }else if chefLeader?.chef_no == nil && track?.chef_no == chef_no{
                print("222222")
                reusableView?.postButton.isHidden = true
                reusableView?.chatButton.isHidden = false
                reusableView?.trackButton.isHidden = false
                reusableView?.reserveButton.isHidden = false
            }else if chefLeader?.chef_no != chef_no && track?.chef_no == nil && chefLeader?.chef_no != nil{
                print("333333")
                reusableView?.postButton.isHidden = true
                reusableView?.chatButton.isHidden = false
                reusableView?.trackButton.isHidden = false
                reusableView?.reserveButton.isHidden = false
            }else if chefLeader?.chef_no == nil && track?.chef_no == nil{
                reusableView?.postButton.isHidden = false
                reusableView?.chatButton.isHidden = true
                reusableView?.trackButton.isHidden = true
                reusableView?.reserveButton.isHidden = true
            }
        
        
        test = indexPath
        
        if flag == 0 {
            reusableView?.trackButton.setTitle("追蹤", for: .normal)
        }else{
            reusableView?.trackButton.setTitle("已追蹤", for: .normal)
        }

//        print(reusableView.chefSi.text ?? "??")
//        let lines = reusableView.chefSi.value(forKey: "measuredNumberOfLines")
//        print("line_1 : \(lines ?? "error")")
//        line = lines as! Int
//        print("line_2 : \(line)")
        
        
        let user_no = userDefault.value(forKey: "user_no") as! String
        var requestParam = [String: Any]()
        requestParam["action"] = "getUserImage"
        requestParam["user_no"] = chefLeader?.user_no ?? track?.user_no ?? user_no
        requestParam["imageSize"] = 1440
        requestParam["notJoin"] = "yes"
        var image: UIImage?
        let imageUrl = fileInCaches(fileName: (chefLeader?.user_no ?? track?.user_no) ?? user_no)
        if self.fileManager.fileExists(atPath: imageUrl.path) {
            if let imageCaches = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: imageCaches)
                self.reusableView?.chefImageView.image = image
            }
        }else{
        executeTask(url_server!, requestParam) { (data, response, error) in
            //print("input: \(String(data: data!, encoding: .utf8)!)")
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    self.reusableView?.chefImageView.image = image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chefBlog = self.storyboard?.instantiateViewController(withIdentifier: "RecipesTVCViewController") as! RecipesTVCViewController
//        let blog = blogList[indexPath.row]
        chefBlog.blog = blogList
        chefBlog.indexForRow = indexPath.row
        chefBlog.user_name = chefLeader?.user_name
        self.navigationController?.pushViewController(chefBlog, animated: true)
    }
    
    
    
    
    
    @IBAction func clickTrack(_ sender: Any) {
        if flag == 0 {
            self.flag = 1
            let chef_no = userDefault.value(forKey: "chef_no")
            var requestParam = [String: Any]()
            requestParam["action"] = "insertFollow"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["chef_no"] = chefLeader?.chef_no ?? track?.chef_no ?? chef_no
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let count = String(decoding: data!, as: UTF8.self)
                        if count == "1"{
                            self.trackNum += 1
                            DispatchQueue.main.async {
                                self.reusableView?.followLabel.text = String(self.trackNum)
                                self.reusableView?.trackButton.setTitle("已追蹤", for: .normal)
                            }
                            
                        }
                    }
                }
            }
        }else{
            self.flag = 0
            let chef_no = userDefault.value(forKey: "chef_no")
            var requestParam = [String: Any]()
            requestParam["action"] = "deleteFollow"
            requestParam["user_no"] = self.userDefault.value(forKey: "user_no")
            requestParam["chef_no"] = chefLeader?.chef_no ?? track?.chef_no ?? chef_no
            executeTask(url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        let count = String(decoding: data!, as: UTF8.self)
                        if count == "1"{
                            self.trackNum -= 1
                            DispatchQueue.main.async {
                                self.reusableView?.followLabel.text = String(self.trackNum)
                                self.reusableView?.trackButton.setTitle("追蹤", for: .normal)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellsAcross: CGFloat = 3
//        let spaceBetweenCells: CGFloat = 5
//        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
//        return CGSize(width: dim, height: dim)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required, // Width is fixed
            verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
    
//    collectionView.frame.size.width??
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let heightForHeard = line*20
//        if heightForHeard == 0 {
//            return CGSize(width: 414, height: 100)
//        }else{
//            print(heightForHeard)
//            return CGSize(width: 414, height: heightForHeard)
//        }
//    }
    
 
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    @IBSegueAction func toChatPage(_ coder: NSCoder) -> ChatPageController? {
        let controller = ChatPageController(coder: coder)
        let chef_no = userDefault.value(forKey: "chef_no") as! String
        controller?.friend_no = chefLeader?.chef_no  ?? track?.chef_no ?? chef_no
        controller?.chatRoomNo = self.chatRoomNo
        controller?.friend_name = chefLeader?.user_name ?? track?.user_name
        controller?.NoForSelectPhoto = chefLeader?.user_no ?? track?.user_no
        controller?.role = "U"
        
        return controller
    }

    
    @IBSegueAction func TakeChefNoToMenuOrderList(_ coder: NSCoder) -> MenuCollectionViewController? {
        let controller = MenuCollectionViewController(coder: coder)
        let chef_no = userDefault.value(forKey: "chef_no") as! String
        controller?.chefNo = chefLeader?.chef_no  ?? track?.chef_no ?? chef_no
     
           
        return controller
    }
    
    
    
    
    
}

