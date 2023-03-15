//
//  ViewController.swift
//  Common7Sdk
//
//  Created by gogopaly@163.com on 02/23/2023.
//  Copyright (c) 2023 gogopaly@163.com. All rights reserved.
//

import UIKit
import Common7Sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let al = PccAlertView(title: "1", message: "2")
        al.config(action: "abc", style: .cancel)
        al.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

