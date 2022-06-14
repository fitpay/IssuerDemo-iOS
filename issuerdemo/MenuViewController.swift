//
//  MenuViewController.swift
//  issuerdemo
//
//  Created by Howerton, Ian on 5/7/21.
//  Copyright © 2021 Fitpay. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var userWalletButton: AppButton!
    @IBOutlet var deviceWalletButton: AppButton!
    @IBOutlet var appToAppButton: AppButton!
    @IBOutlet var pushProvisioningButton: AppButton!
    @IBOutlet var ciqButton: AppButton!


    @IBAction func userWalletButtonPressed(_ sender: Any) {
        openUrl(path: "wallet")
    }

    @IBAction func deviceWalletButtonPressed(_ sender: Any) {
        openUrl(path: "device?unitId=123")
    }

    @IBAction func appToAppButtonPressed(_ sender: Any) {
        let appToAppViewController = AppToAppViewController(cardType: .visa)
        navigationController?.pushViewController(appToAppViewController, animated: true)
    }

    @IBAction func pushProvisioningButtonPressed(_ sender: Any) {
        let pushProvisioningViewController = PushProvisioningViewController()
        navigationController?.pushViewController(pushProvisioningViewController, animated: true)
    }

    @IBAction func ciqButtonPressed(_ sender: Any) {
        openUrl(path: "add")
    }

    private func openUrl(path: String) {
        let urlString = "https://connect.garmin.com/payment/" + path
        if let appURL = URL(string: urlString) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            print("Could not create url")
        }
    }
}
