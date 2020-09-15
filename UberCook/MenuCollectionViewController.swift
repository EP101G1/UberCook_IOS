//
//  MenuCollectionViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/13.
//

import UIKit

private let reuseIdentifier = "\(MenuCollectionViewCell.self)"



class MenuCollectionViewController: UICollectionViewController {
    
    var chefNo:String?
    
    var MenuRecipeLists = [MenuRecipeList]()
    
    var didselect:[Bool] = []
    
    var addnumber:[Int] = []
    
    var nextMenuRecipeLists = [MenuRecipeList]()
     
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(chefNo!)
        
        MenuController.shared.getMenuRecipeLists(chefNo: chefNo!) { (MenuRecipeLists) in
            if let MenuRecipeLists = MenuRecipeLists{
                
              
                self.MenuRecipeLists = MenuRecipeLists
                
                for index in 0...MenuRecipeLists.count-1
                {
                    self.didselect.insert(true, at: index)
                    self.addnumber.insert(0, at: index)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MenuRecipeLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell
        
        
        if didselect[indexPath.row] {
            cell?.layer.borderColor = UIColor(named: "tiffanyGreen")?.cgColor
            cell?.layer.borderWidth = 2
            cell?.layer.cornerRadius = 10
            didselect[indexPath.row] = false
            //cell?.contentView.backgroundColor = UIColor.systemGray4
            cell?.contentView.layer.cornerRadius = 10
            addnumber[indexPath.row] += 1
            MenuRecipeLists[indexPath.row].number = 1
            
            
            cell?.numberLabel.text = String(addnumber[indexPath.row]) //在下一步按鈕判斷的點選
            cell?.addLessStepper.isHidden = false
            cell?.numberLabel.isHidden = false
            
           
    
            
        }else{
            cell?.layer.borderColor = UIColor.clear.cgColor
            didselect[indexPath.row] = true
            cell?.layer.cornerRadius = 10
            cell?.contentView.backgroundColor = UIColor.white
            cell?.contentView.layer.cornerRadius = 10
            
            addnumber[indexPath.row] = 0
            MenuRecipeLists[indexPath.row].number = 0
            cell?.numberLabel.text = String(addnumber[indexPath.row])
            cell?.numberLabel.isHidden = true
            cell?.addLessStepper.isHidden = true
        }
        
       
        
        
    }


    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       // let cell = collectionView.cellForItem(at: indexPath)
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath) as! MenuCollectionViewCell
        //        cell.photoView.image = UIImage(s)
        // Configure the cell
        
        cell.titleLabel.text = MenuRecipeLists[indexPath.row].recipeTitle
        let cash = MenuRecipeLists[indexPath.row].recipePoint
        cell.addLessStepper.value = Double(self.addnumber[indexPath.row])
        cell.cashLabel.text = String(cash)+"  points"
        cell.index = indexPath.row
        cell.addnumber = self.addnumber
        cell.didselect = self.didselect
        cell.compeltionHandler = { (addnumber,index,didselect) in
            self.addnumber = addnumber
            if(!self.didselect[index]){
             cell.numberLabel.text = String(self.addnumber[index])
                self.MenuRecipeLists[indexPath.row].number = self.addnumber[index]
            }
            
            print(self.MenuRecipeLists[indexPath.row].number)
        }
        
        
        MenuController.shared.getRecipeImage(recipe_no: MenuRecipeLists[indexPath.row].recipeNo , imageSize: 500) { (image) in
            if let image = image{
                
                DispatchQueue.main.async {
                    cell.photoView.image = image
                }
            }
            
        }
        
       
       
        
        
        
        
        return cell
    }
    
    
  
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func collectionView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    @IBSegueAction func takeTitleAndNumberToTotalList(_ coder: NSCoder) -> TotalOrderListViewController? {
        nextMenuRecipeLists.removeAll()
        
        for index in 0...didselect.count-1 { //去除沒選中的菜單
            if (!didselect[index]){
               nextMenuRecipeLists.append(MenuRecipeLists[index])
            }
        }
        
        let controller = TotalOrderListViewController(coder: coder)
        controller?.nextMenuRecipeLists = self.nextMenuRecipeLists

        return controller
    }
    
}
