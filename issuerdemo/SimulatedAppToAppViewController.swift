import UIKit

class SimulatedAppToAppViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordTF.isHidden = !appDelegate.useAuthCode
    }
    
    @IBAction func confirmPassword(_ sender: Any) {
        if passwordTF?.text?.isEmpty == true && appDelegate.useAuthCode {
            showError("No Password", message: "Password is empty")
            return
        }
        
        guard let wpCallback = appDelegate.wpCallback else {
            showError("No callback", message: "Launch app with wpcallback parameter")
            return
        }
        
        var authResponse = "approved"

        switch (passwordTF.text?.last) {
        case "d":
            authResponse = "declined"
            break;
        case "f":
            authResponse = "failure"
            break
        default:
            break
        }
        
        var urlString = "\(wpCallback)?stepupresponse=\(authResponse)"
        if (appDelegate.useAuthCode) {
            urlString.append("&stepupauthcode=\(passwordTF!.text!)")
        }
        
        let url = URL(string: urlString)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        passwordTF.text = ""
        passwordTF.resignFirstResponder()
    }

    @IBAction func declined(_ sender: Any) {
        guard let wpCallback = appDelegate.wpCallback else {
            showError("No callback", message: "Launch app with wpcallback parameter")
            return
        }

        let authResponse = "declined"

        var urlString = "\(wpCallback)?stepupresponse=\(authResponse)"
        if (appDelegate.useAuthCode) {
            urlString.append("&stepupauthcode=\(passwordTF!.text!)")
        }

        let url = URL(string: urlString)!

        UIApplication.shared.open(url, options: [:], completionHandler: nil)

        passwordTF.text = ""
        passwordTF.resignFirstResponder()
    }

    @IBAction func failure(_ sender: Any) {
        guard let wpCallback = appDelegate.wpCallback else {
            showError("No callback", message: "Launch app with wpcallback parameter")
            return
        }

        let authResponse = "failure"

        var urlString = "\(wpCallback)?stepupresponse=\(authResponse)"
        if (appDelegate.useAuthCode) {
            urlString.append("&stepupauthcode=\(passwordTF!.text!)")
        }

        let url = URL(string: urlString)!

        UIApplication.shared.open(url, options: [:], completionHandler: nil)

        passwordTF.text = ""
        passwordTF.resignFirstResponder()
    }
    
    func showError(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true) {}
    }
    
}

extension SimulatedAppToAppViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTF.resignFirstResponder()
        return true
    }
    
}
