//
//  AppDelegate.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 02/12/2020.
//

/*
  Unit Test
 
  Copy to GitHub
 
Implementation focused on 'business' logic rather than UI.

THEORETICAL NEXT STEPS
----------------------

1. Add error handling (for API load errors, empty images, empty and illegal JSON responses, etc.)
2. Add a busy indicator (spinner) for the api load
3. Add snapshot testing to test view controllers' logic
4. Add further unit test coverage to DetailsPresenter (specifically for testing the combination of search and season filters). DetailsPresenter probably requires no unit tests and can rely on the snapshot testing of its view controller.
5. etc...
 
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    navigationController = startAppFlow()

    window!.rootViewController = navigationController
    window!.makeKeyAndVisible()

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  private func startAppFlow() -> UINavigationController {
    
    let navVC = UINavigationController()
    let vcFactory = ViewControllerFactory()
    let vc = vcFactory.getCharactersViewController()
    navVC.viewControllers = [vc]

    return navVC
  }
}
