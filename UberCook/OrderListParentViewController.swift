//
//  OrderListParentViewController.swift
//  UberCook
//
//  Created by Hsuan on 2020/9/18.
//

import UIKit

class OrderListParentViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var OrderscrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        let x = CGFloat(sender.selectedSegmentIndex) * OrderscrollView.bounds.width
               let offset = CGPoint(x: x, y: 0)
        OrderscrollView.setContentOffset(offset, animated: true)
      
    }
    

}

extension OrderListParentViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        segmentControl.selectedSegmentIndex = index
    }
}

