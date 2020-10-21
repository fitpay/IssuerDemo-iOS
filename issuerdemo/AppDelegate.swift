import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    lazy var navController: UINavigationController = {
        return UINavigationController()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        /// Style the navigation bar
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = true

        /// Create a sample url for the demo controller to use for initial setup
        let callbackQueryItem = URLQueryItem(name: "wpcallback", value: "com.garmin.connect.mobile.wallet://fitpay-app-to-app/")
        var urlComponents = URLComponents(string: "pagare://a2a_generate_auth_code")!
        urlComponents.queryItems = [callbackQueryItem]
        let url = urlComponents.url!

        let demoViewController = DemoViewController(url: url)
        navController.pushViewController(demoViewController, animated: false)

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = navController
        window.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        navController.viewControllers = []
        let demoViewController = DemoViewController(url: url)
        navController.pushViewController(demoViewController, animated: false)
        return true
    }
}
