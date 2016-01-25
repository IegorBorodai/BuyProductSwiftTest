//
//  TESProductBoughtListViewController.swift
//  TestAppSwift
//
//  Created by Iegor Borodai on 7/23/15.
//  Copyright (c) 2015 Iegor Borodai. All rights reserved.
//

import UIKit

class TESProductBoughtViewController: UIViewController {
    
    override final func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Action
    
    @IBAction private func doneButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override final func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? TESProductListViewController {
            vc.controllerType = .Remove
        }
    }
}
