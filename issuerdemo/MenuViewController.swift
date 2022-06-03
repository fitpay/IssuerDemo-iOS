//
//  MenuViewController.swift
//  issuerdemo
//
//  Created by Howerton, Ian on 5/7/21.
//  Copyright © 2021 Fitpay. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var appToAppButton: AppButton!
    @IBOutlet var pushProvisioningButton: AppButton!
    @IBOutlet var ciqButton: AppButton!

    @IBAction func appToAppButtonPressed(_ sender: Any) {
        let appToAppViewController = AppToAppViewController(cardType: .visa)
        navigationController?.pushViewController(appToAppViewController, animated: true)
    }

    @IBAction func pushProvisioningButtonPressed(_ sender: Any) {
        let pushProvisioningViewController = PushProvisioningViewController()
        navigationController?.pushViewController(pushProvisioningViewController, animated: true)
    }

    @IBAction func ciqButtonPressed(_ sender: Any) {
        let ciqLinkViewController = CIQLinkViewController()
        navigationController?.pushViewController(ciqLinkViewController, animated: true)
    }
}
