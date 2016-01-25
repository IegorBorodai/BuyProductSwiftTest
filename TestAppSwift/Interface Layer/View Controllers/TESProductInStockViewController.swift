//
//  TESProductInStockViewController.swift
//  TestAppSwift
//
//  Created by Iegor Borodai on 7/23/15.
//  Copyright (c) 2015 Iegor Borodai. All rights reserved.
//

import UIKit

class TESProductInStockViewController: UIViewController {
    
    static let identifier = "TESProductInStockViewController"
    
    @IBOutlet private weak var boughtProductAmount: UILabel!
    @IBOutlet private weak var boughtProductPrice: UILabel!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TESProductCoreDataManager.sharedInstance
    }
    
    override final func viewWillAppear(animated: Bool) {
        updateCart()
        tableView?.reloadData()
    }
    
    
    // MARK: - Utility
    
    private func updateCart () {
        boughtProductAmount.text = String(TESProductCoreDataManager.sharedInstance.totalAmount)
        boughtProductPrice.text = String(format: "%d$", TESProductCoreDataManager.sharedInstance.totalPrice)
    }
    
    // MARK: - Navigation

    override final func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TESProductListViewController {
            vc.controllerType = .Buy
            vc.delegate = self
            tableView = vc.tableView
        }
    }
}

extension TESProductInStockViewController : TESProductListViewControllerDelegate {
    
    // MARK: - TESProductListViewControllerDelegate
    
    final func cellDidRecieveAction() {
        updateCart()
    }
}
