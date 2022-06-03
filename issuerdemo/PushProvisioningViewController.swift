//
//  PushProvisioningViewController.swift
//  issuerdemo
//
//  Created by Howerton, Ian on 5/7/21.
//  Copyright © 2021 Fitpay. All rights reserved.
//

import UIKit

class PushProvisioningViewController: UIViewController {

    @IBOutlet weak var completeIssuerActivatationSwitch: UISwitch!
    @IBOutlet weak var callbackRequiredSwitch: UISwitch!
    @IBOutlet weak var cardTypePickerView: UIPickerView!
    @IBOutlet weak var sendButton: UIButton!
    
    let GARMIN_PAY_URL = "https://connect.garmin.com/payment/push/ios/mc" // mastercard

    static let visaAccountReceipt = "eyJraWQiOiJhMjAwOTRjYy0yMTE1LTQzZTgtYjZkOS05Y2ZkMTYxODQwNWYiLCJjdHkiOiJhcHBsaWNhdGlvbi9qc29uIiwiZW5jIjoiQTI1NkdDTSIsInRhZyI6IldCbnZnaHZ4Vk9SNV9XSUh3TXBEaHciLCJhbGciOiJBMjU2R0NNS1ciLCJpdiI6Ill1ZHpGUW92emdkdGlheFAifQ.eMz0qvnyrK3sPpg9pgcc3M9cNDJDuGogKxO5J7QZX6k.z9b1YlXvI0YigapnwmrN6A.nZOTwdx5DlcarSPe_Y8yzjMH0lAhpNMvZwEHbojYD3WTc6sMjvs_m4kpf-ewpB6pzWQ_uSW93HBZPEPmWvRbhgFIk7c_xOaESk2f85S46dgJo_cRTso_jJXRVjQuqizabyOGM-Mnt5a1RfH6QvCSWrEKIV0NbtTjbXFrhcyRgaG-i8moa5lOMOuTLd4QHz4DF32ZC_aG5OQ5M7o8l_su7L7WEXgsu3f7TDc5r6Biyaei95pDwMZMaKIFFJWiBl0yEbJozA.lwpuG0VYDMh01CkiQw"
    static let masterCardCreditAccountReceipt = "TST-MCC7F0AE-298E-48EB-AA43-A7C40B32DDDE"
    static let masterCardCreditAccountRecieptAdditionalAuth = "TST-MCC7F0AE-298E-48EB-AA43-ADDAUTH04566"
    static let masterCardCreditAccountRecieptDeclined = "TST-MCC7F0AE-298E-48EB-AA43-DECLINE77777"
    static let masterCardCreditAccountRecieptError = "TST-MCC7F0AE-298E-48EB-AA43-ERROR9999999"
    static let plvPrivateLabelAccountReceipt = "TST-PVLGTJ94-9D5T-96MO-WV36-56AZN95Y8DUL"

    let cardTypes: [CardAttributes] = [
                                 CardAttributes(name: "mastercard", accountReceipt: masterCardCreditAccountReceipt, title: "Mastercard Approved"),
                                 CardAttributes(name: "mastercard", accountReceipt: masterCardCreditAccountRecieptAdditionalAuth, title: "Mastercard Auth flow"),
                                 CardAttributes(name: "mastercard", accountReceipt: masterCardCreditAccountRecieptDeclined, title: "Mastercard Declined "),
                                 CardAttributes(name: "mastercard", accountReceipt: masterCardCreditAccountRecieptError, title: "Mastercard Error"),
                                 CardAttributes(name: "plv", accountReceipt: plvPrivateLabelAccountReceipt, title: "PVL Private Label")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Push Provisioning"

        cardTypePickerView.dataSource = self
        cardTypePickerView.delegate = self
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        
        guard var urlComponents = URLComponents(string: GARMIN_PAY_URL) else {
            errorAlertView(errorText: "Could not create urlComponents")
            return
        }
        
        let selectedCardType = cardTypes[cardTypePickerView.selectedRow(inComponent: 0)]
        //Different providers may pass the pushAccountReceipts using different names and this will need to be conditionally edited to account for this.
        //Currently we only know what mastercard uses.
        urlComponents.queryItems = [
            URLQueryItem(name: "callbackRequired", value: String(callbackRequiredSwitch.isOn)),
            URLQueryItem(name: "callbackURL", value: "pagare://deep-link"),
            URLQueryItem(name: "completeIssuerAppActivation", value: String(completeIssuerActivatationSwitch.isOn)),
            URLQueryItem(name: "pushAccountReceipts", value: selectedCardType.accountReceipt)
        ]

        if let appURL = urlComponents.url, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: {[weak self] _ in
                self?.dismiss(animated: false, completion: nil)
            })
        } else {
            errorAlertView(errorText: "Could not create url from urlComponents")
        }
    }
    
    func errorAlertView(errorText: String) {
        let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PushProvisioningViewController: UIPickerViewDataSource, UIPickerViewAccessibilityDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let cardType = cardTypes[row]
        return cardType.title
    }
}

struct CardAttributes {
    let name: String
    let accountReceipt: String
    let title: String
}
