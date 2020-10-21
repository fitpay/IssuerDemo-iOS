//
//  DemoViewController.swift
//  issuerdemo
//
//  Created by Rebel, Chris on 10/20/20.
//  Copyright © 2020 Fitpay. All rights reserved.
//

import UIKit

enum SelectionAction {
    case cardType
    case authResponse
    case authCode
}

enum CardType: CaseIterable {
    case visa
    case mastercard
    case maestro
    case discover

    /// Match a card type by the callback param key in the url
    /// Useful for setting up the demo app to show the correct card type
    init?(url: URL) {
        guard let queryParams = url.queryParameters else {
            return nil
        }

        for cardType in CardType.allCases {
            for key in queryParams.keys {
                if cardType.callbackRequestParam == key {
                    self = cardType
                    return
                }
            }
        }

        return nil
    }

    var description: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .maestro: return "Maestro"
        case .discover: return "Discover"
        }
    }

    var icon: UIImage? {
        switch self {
        case .visa: return UIImage(named: "vbm_cardshape_blu_rgb")
        case .mastercard: return UIImage(named: "mc_vrt_spot_rev")
        case .maestro: return UIImage(named: "maestro")
        case .discover: return UIImage(named: "discover")
        }
    }

    var payloadRequestParam: String {
        switch self {
        case .visa: return "a2apayload"
        case .mastercard: return "iOS.deeplinkURL.extra.TEXT"
        case .maestro: return "iOS.deeplinkURL.extra.TEXT"
        case .discover: return "payload"
        }
    }

    var callbackRequestParam: String {
        switch self {
        case .visa: return "wpcallback"
        case .mastercard: return "callBackURL"
        case .maestro: return "callBackURL"
        case .discover: return "callback"
        }
    }

    var authResponseParam: String {
        switch self {
        case .visa: return "stepupresponse"
        case .mastercard: return "issuerMobileAppAuthResponse"
        case .maestro: return "issuerMobileAppAuthResponse"
        case .discover: return "authResponse"
        }
    }

    var authCodeParam: String {
        switch self {
        case .visa: return "stepupauthcode"
        case .mastercard: return "TAV"
        case .maestro: return "TAV"
        case .discover: return "authCode"
        }
    }
}

enum AuthResponse: CaseIterable {
    case approved
    case declined
    case failure

    var description: String {
        switch self {
        case .approved: return "Approved"
        case .declined: return "Declined"
        case .failure: return "Failure"
        }
    }

    var value: String {
        switch self {
        case .approved: return "approved"
        case .declined: return "declined"
        case .failure: return "failure"
        }
    }
}

enum AuthCode: CaseIterable {
    case none
    case manual

    var description: String {
        switch self {
        case .none: return "None"
        case .manual: return "Manual"
        }
    }

    var urlHost: String {
        switch self {
        case .none: return "a2a_perform_auth"
        case .manual: return "a2a_generate_auth_code"
        }
    }

    init?(url: URL) {
        for authCode in AuthCode.allCases {
            if authCode.urlHost == url.host {
                self = authCode
                return
            }
        }

        return nil
    }
}

enum CallbackError: Error {
    case missingCallbackParam
    case emptyAuthCode
    case invalidCallbackUrl(String)
    case unableToCreateUrl(URLComponents)
}

class DemoViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var requestLabel: UILabel!
    @IBOutlet var pickerTextField: UITextField!
    @IBOutlet var cardTypeView: UIView!
    @IBOutlet var cardTypeImageView: UIImageView!
    @IBOutlet var cardTypeLabel: UILabel!

    @IBOutlet var authResponseView: UIView!
    @IBOutlet var authResponseLabel: UILabel!
    @IBOutlet var authCodeView: UIView!
    @IBOutlet var authCodeLabel: UILabel!
    @IBOutlet var authCodeContainerView: UIView!
    @IBOutlet var authCodeTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var previewLabel: UILabel!

    private var url: URL
    private var cardType: CardType
    private var authResponse: AuthResponse
    private var authCode: AuthCode
    private var action: SelectionAction

    private let pickerView = UIPickerView(frame: CGRect.zero)
    private lazy var pickerDoneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneButtonAction))

        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        return toolbar
    }()

    private lazy var authCodeDoneToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(authCodeDoneButtonAction))

        let items = [flexSpace, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        return toolbar
    }()

    init(url: URL) {
        self.url = url
        self.cardType = CardType(url: url) ?? .visa
        self.authResponse = .approved
        self.authCode = AuthCode(url: url) ?? .none
        self.action = .cardType

        let nibName = String(describing: type(of: self))
        let bundle = Bundle.init(for: DemoViewController.self)
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Issuer Demo"

        pickerTextField.isHidden = true

        requestLabel.text = url.absoluteString

        authCodeTextField.text = "12345"
        authCodeTextField.inputAccessoryView = authCodeDoneToolbar
        authCodeTextField.delegate = self

        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 12

        let highlightColor = UIColor(red: 5.0/255.0, green: 80.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        submitButton.setBackgroundColor(highlightColor, forState: .highlighted)

        pickerView.dataSource = self
        pickerView.delegate = self

        pickerTextField.inputView = pickerView
        pickerTextField.inputAccessoryView = pickerDoneToolbar

        cardTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTypeAction)))

        authResponseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authResponseAction)))

        authCodeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authCodeAction)))

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        updateDisplay()
    }

    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        print(keyboardFrame)
    }

    @objc func keyboardWillHide(notification:NSNotification){
        scrollView.contentInset = .zero
    }

    @objc func cardTypeAction() {
        action = .cardType
        updatePickerView()
        pickerTextField.becomeFirstResponder()
    }

    @objc func authResponseAction() {
        action = .authResponse
        updatePickerView()
        pickerTextField.becomeFirstResponder()
    }

    @objc func authCodeAction() {
        action = .authCode
        updatePickerView()
        pickerTextField.becomeFirstResponder()
    }

    @objc func pickerDoneButtonAction() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)

        switch action {
        case .cardType:
            cardType = CardType.allCases[selectedRow]
        case .authResponse:
            authResponse = AuthResponse.allCases[selectedRow]
        case .authCode:
            authCode = AuthCode.allCases[selectedRow]
        }

        updateDisplay()
        pickerTextField.resignFirstResponder()
    }

    @objc func authCodeDoneButtonAction() {
        updateDisplay()
        view.endEditing(true)
    }

    private func updateDisplay() {
        cardTypeImageView.image = cardType.icon
        cardTypeLabel.text = cardType.description
        authResponseLabel.text = authResponse.description
        authCodeLabel.text = authCode.description
        authCodeContainerView.isHidden = authCode == .none

        let previewText = (try? createCallbackUrl().absoluteString) ?? "Error creating preview"
        previewLabel.text = previewText
    }

    private func updatePickerView() {
        pickerView.reloadAllComponents()

        let targetIndex: Int?
        switch action {
        case .cardType:
            targetIndex = CardType.allCases.index(of: cardType)
        case .authResponse:
            targetIndex = AuthResponse.allCases.index(of: authResponse)
        case .authCode:
            targetIndex = AuthCode.allCases.index(of: authCode)
        }

        let targetRow = targetIndex ?? 0
        pickerView.selectRow(targetRow, inComponent: 0, animated: false)
    }

    func createCallbackUrl() throws -> URL {
        guard let requestParams = url.queryParameters, let callback = requestParams[cardType.callbackRequestParam] else {
            showError("Error", message: "Missing required request params")
            throw CallbackError.missingCallbackParam
        }

        var queryItems: [URLQueryItem] = []
        let authResponseQueryItem = URLQueryItem(name: cardType.authResponseParam, value: authResponse.value)
        queryItems.append(authResponseQueryItem)

        if authCode == .manual {
            guard let authCodeText = authCodeTextField.text, !authCodeText.isEmpty else {
                showError("Error", message: "Auth code cannot be empty")
                throw CallbackError.emptyAuthCode
            }

            let authCodeQueryItem = URLQueryItem(name: cardType.authCodeParam, value: authCodeText)
            queryItems.append(authCodeQueryItem)
        }

        guard var urlComponents = URLComponents(string: callback) else {
            showError("Error", message: "Invalid callback url format")
            throw CallbackError.invalidCallbackUrl(callback)
        }

        urlComponents.queryItems = queryItems
        guard let callbackUrl = urlComponents.url else {
            showError("Error", message: "Unable to create callback url")
            throw CallbackError.unableToCreateUrl(urlComponents)
        }

        return callbackUrl
    }

    @IBAction func submitAction(_ sender: Any) {
        view.endEditing(true)

        do {
            let callbackUrl = try createCallbackUrl()
            UIApplication.shared.open(callbackUrl, options: [:], completionHandler: nil)
        } catch CallbackError.missingCallbackParam {
            showError("Error", message: "Missing callback param from url: \(url)")
        } catch CallbackError.emptyAuthCode {
            showError("Error", message: "The auth code field cannot be left blank")
        } catch CallbackError.invalidCallbackUrl(let callback) {
            showError("Error", message: "Invalid callback url: \(callback)")
        } catch CallbackError.unableToCreateUrl(let components) {
            showError("Error", message: "Unable to create url: \(components.description)")
        } catch {
            showError("Error", message: "Unknown error: \(error.localizedDescription)")
        }
    }

    func showError(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true) {}
    }
}

extension DemoViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        updateDisplay()
        return false
    }
}

extension DemoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch action {
        case .cardType: return CardType.allCases.count
        case .authResponse: return AuthResponse.allCases.count
        case .authCode: return AuthCode.allCases.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch action {
        case .cardType: return CardType.allCases[row].description
        case .authResponse: return AuthResponse.allCases[row].description
        case .authCode: return AuthCode.allCases[row].description
        }
    }
}

extension UIButton {

    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }

        setBackgroundImage(colorImage, for: controlState)
    }
}

extension URL {

    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else { return nil }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }
}
