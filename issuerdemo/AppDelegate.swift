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

        let flowSelectionViewController = FlowSelectionViewController()
        navController.pushViewController(flowSelectionViewController, animated: false)

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = navController
        window.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        navController.viewControllers = []
        navController.pushViewController(FlowSelectionViewController(), animated: false)
        if url.absoluteString == "pagare://deep-link" {
            let deepLinkViewController = DeepLinkViewController()
            navController.pushViewController(deepLinkViewController, animated: false)
            return true
        } else {
            let demoViewController = DemoViewController(url: url)
            navController.pushViewController(demoViewController, animated: false)
            return true
        }
    }
}
