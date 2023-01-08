import UIKit
import OpenAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //You can create new secret key through below link.
        //https://beta.openai.com/account/api-keys
        OpenAI.setToken("YOU-NEED-SET-SECRET-KEY")
        OpenAI.setToken("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")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}

