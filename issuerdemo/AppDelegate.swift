import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    lazy var navController: UINavigationController = {
        return UINavigationController()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let menuViewController = MenuViewController()
        navController.viewControllers = [menuViewController]

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = navController
        window.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.absoluteString.contains("/ciq") {
            navController.popViewController(animated: false)
        } else if !url.absoluteString.contains("a2a") {
            navController.popToRootViewController(animated: false)
            let appToAppViewController = AppToAppViewController(url: url)
            navController.pushViewController(appToAppViewController, animated: false)
        }

        return true
    }
}
