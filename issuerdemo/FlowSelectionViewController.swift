//
//  FlowSelectionViewController.swift
//  issuerdemo
//
//  Created by Howerton, Ian on 5/7/21.
//  Copyright © 2021 Fitpay. All rights reserved.
//

import UIKit

class FlowSelectionViewController: UIViewController {

    @IBOutlet weak var pushProvisioningButton: UIButton!
    @IBOutlet weak var authorizationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pushProvisioningButton.clipsToBounds = true
        pushProvisioningButton.layer.cornerRadius = 12
        
        authorizationButton.clipsToBounds = true
        authorizationButton.layer.cornerRadius = 12
    }

    @IBAction func authorizationButtonPressed(_ sender: Any) {
        /// Create a sample url for the demo controller to use for initial setup
        let callbackQueryItem = URLQueryItem(name: "wpcallback", value: "com.garmin.connect.mobile.wallet://fitpay-app-to-app/")
        var urlComponents = URLComponents(string: "pagare://a2a_generate_auth_code")!
        urlComponents.queryItems = [callbackQueryItem]
        let url = urlComponents.url!
        
        let demoViewController = DemoViewController(url: url)
        self.navigationController?.pushViewController(demoViewController, animated: false)
    }

    @IBAction func pushProvisioningButtonPressed(_ sender: Any) {
        let deepLinkViewController = DeepLinkViewController()
        self.navigationController?.pushViewController(deepLinkViewController, animated: false)
    }
}
