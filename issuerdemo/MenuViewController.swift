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

    @IBAction func encryptedPushProvisioningButtonPressed(_ sender: Any) {
        openUrl(path: "push/ios/mc?pushAccountData=eyJhbGciOiJSUzI1NiIsImtpZCI6IjIwMjEwOTI3MDkxMzQwLU1ERVMtdG9rZW4tY29ubmVjdC1tdGYifQ.eyJwdXNoQWNjb3VudFJlY2VpcHRzIjpbIk1TSS1TVEwtNkFERjg5QjItOEJBQi00MzNGLUE3NDItQUVENTg1Q0M3MDFCIl0sImNhbGxiYWNrVVJMIjoiaHR0cHM6Ly90b2tlbmNvbm5lY3QubWNzcmN0ZXN0c3RvcmUuY29tL3Rva2VuaXphdGlvbi1yZXN1bHRzIiwiY29tcGxldGVXZWJzaXRlQWN0aXZhdGlvbiI6dHJ1ZSwiYWNjb3VudEhvbGRlckRhdGFTdXBwbGllZCI6dHJ1ZSwibG9jYWxlIjoiZW5fVVMifQ.vdLuG-W4ydTfL_Meoov7kPKUfkLhBWiCyImUfZ79mYAsXgcUcrwjp2Fyrmfjf0rXClcYlDi19jD01gtXqmlmqRyXGvuWb0a0yXB_9isus2rKYwcAdbiEnlvHzN9J9taw_AzIF50ACl8xtDhF_dwX0UcFi_98TagNMlRN3-R0C0C4LZaWMj32der28roX3uUxjTUl4LQULP6kLC9b-kJozCXiAZnJVWtYMFO4FLMjAUFH0hZPTTzmkr80bJYTxU8gFF5KRx-Y25G8LtoQ0chTfyI6EbkOQzLvY5Rt1NISCMCDP2sWo8zPLBRIos6CLxkCO1eCS2WEwO02hqr9Vw6V3w"
        )
    }

    @IBAction func ciqButtonPressed(_ sender: Any) {
        openUrl(path: "add?callbackURL=pagare://ciq")
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
