//
//  CashVC.swift
//  UberCook
//
//  Created by 超 on 2020/9/13.
//

import UIKit

class CashVC: UIViewController {
    
    @IBOutlet weak var cashSegment: UISegmentedControl!
    @IBOutlet weak var cashScroll: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        let x = CGFloat(sender.selectedSegmentIndex) * cashScroll.bounds.width
               let offset = CGPoint(x: x, y: 0)
        cashScroll.setContentOffset(offset, animated: true)
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

extension CashVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        cashSegment.selectedSegmentIndex = index
    }
}
