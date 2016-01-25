//
//  TESProductListViewController.swift
//  TestAppSwift
//
//  Created by Iegor Borodai on 7/23/15.
//  Copyright (c) 2015 Iegor Borodai. All rights reserved.
//

import UIKit

enum TESProductListViewControllerType : String {
    case Buy = "Buy"
    case Remove = "Remove"
}

protocol TESProductListViewControllerDelegate : class {
    func cellDidRecieveAction()
}

class TESProductListViewController: UIViewController {
    
    var controllerType: TESProductListViewControllerType = .Buy
    var delegate : TESProductListViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override final func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    final func buyProduct (sender: UIButton) {
        if let cell = sender.superview?.superview {
            if let indexPath = tableView.indexPathForCell(cell as! UITableViewCell) {
                switch controllerType
                {
                case .Buy:
                    let product = TESProductCoreDataManager.sharedInstance.productsList[indexPath.row]
                    TESProductCoreDataManager.sharedInstance.buyProduct(product)
                    delegate!.cellDidRecieveAction()
                case .Remove:
                    let product = TESProductCoreDataManager.sharedInstance.productsBought[indexPath.row]
                    TESProductCoreDataManager.sharedInstance.removeProduct(product)
                }
                
                tableView.reloadData()
            }
        }
    }
    
}

extension TESProductListViewController : UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    final func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerType == .Buy ? TESProductCoreDataManager.sharedInstance.productsList.count : TESProductCoreDataManager.sharedInstance.productsBought.count
    }
    
    final func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TESProductTableViewCell.identifier, forIndexPath: indexPath) as! TESProductTableViewCell
        
        switch controllerType {
        case .Buy:
            let product = TESProductCoreDataManager.sharedInstance.productsList[indexPath.row]
            cell.productTitleLabel.text = product.productName
            cell.productCountLabel.text = "\(product.productAmount.integerValue) / "
            cell.productPriceLabel.text = "\(product.productPrice.integerValue)$"
        case .Remove:
            let product = TESProductCoreDataManager.sharedInstance.productsBought[indexPath.row]
            cell.productTitleLabel.text = product.productName
            cell.productCountLabel.text = "\(product.boughtAmount.integerValue) / "
            cell.productPriceLabel.text = "\(product.productPrice.integerValue)$"
        }
        
        cell.poductActionButton.setTitle(controllerType.rawValue, forState: UIControlState.Normal)
        cell.poductActionButton.addTarget(self, action: "buyProduct:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
}
