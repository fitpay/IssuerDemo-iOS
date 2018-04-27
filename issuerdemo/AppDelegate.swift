import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var payload: String?
    var wpCallback: String?
    var useAuthCode = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        payload = url.queryParameters?["a2apayload"]
        wpCallback = url.queryParameters?["wpcallback"]
        
        if (url.absoluteString.starts(with: "pagare://a2a_generate_auth_code")) {
            useAuthCode = true
        } else if (url.absoluteString.starts(with: "pagare://a2a_perform_auth")) {
            useAuthCode = false
        }
        
        return true
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
