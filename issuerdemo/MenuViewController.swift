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
        promptForDeviceWalletUnitId()
    }

    private func promptForDeviceWalletUnitId() {
        let title = "Enter a Garmin unit id to go to the device's wallet"
        let message = "You can see device unit ids by long pressing on either the user or device wallet screens in GarminPay."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Garmin Unit Id"
            textField.keyboardType = .numberPad
        }

        let save = UIAlertAction(title: "Go", style: .default) { _ in
            guard let textField = alertController.textFields?.first, let unitId = textField.text else {
                return
            }
            self.openUrl(path: "device?unitId=\(unitId)")
        }

        let cancel = UIAlertAction(title: "Cancel", style: .default)

        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.preferredAction = save

        present(alertController, animated: true, completion: nil)
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
