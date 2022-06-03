//
//  CIQLinkViewController.swift
//  issuerdemo
//
//  Created by Rebel, Chris on 5/18/22.
//  Copyright © 2022 Fitpay. All rights reserved.
//

import UIKit

class CIQLinkViewController: UIViewController {

    let GARMIN_PAY_URL = "https://connect.garmin.com/payment/ciq"
    
    @IBOutlet var addCardButton: UIButton!
    @IBOutlet var linkLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CIQ App"

        linkLabel.text = GARMIN_PAY_URL
    }

    @IBAction func addCardPressed(_ sender: Any) {
        if let appURL = URL(string: GARMIN_PAY_URL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            print("Could not create ciq url")
        }
    }
}
