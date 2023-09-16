import XCTest
@testable import Alarm_ios_swift


func constructTestingViews(navDelegate: UINavigationControllerDelegate) -> (UIStoryboard, AppDelegate, UINavigationController, MainAlarmViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

    let navigationController = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
    navigationController.delegate = navDelegate
    
    let mainAlarmViewController = navigationController.viewControllers.first as! MainAlarmViewController
    mainAlarmViewController.loadViewIfNeeded()
    
    let window = UIWindow()
    window.rootViewController = mainAlarmViewController
    let appDelegate = AppDelegate()
    appDelegate.window = window
    
    window.makeKeyAndVisible()
    return (storyboard, appDelegate, navigationController, mainAlarmViewController)
}

final class MainAlarmViewControllerTests: XCTestCase, UINavigationControllerDelegate {
    
    var storyboard: UIStoryboard! = nil
    var appDelegate: AppDelegate! = nil
    var navigationController: UINavigationController! = nil
    var mainAlarmViewController: MainAlarmViewController! = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let tuple = constructTestingViews(navDelegate: self)
        storyboard = tuple.0
        appDelegate = tuple.1
        navigationController = tuple.2
        mainAlarmViewController = tuple.3
    }
    
    func testStartupConfiguration() {
        let viewControllers = navigationController.viewControllers
        XCTAssert(viewControllers.first as? MainAlarmViewController == mainAlarmViewController)
        
        let navigationItemTitle = mainAlarmViewController.navigationItem.title
        XCTAssert(navigationItemTitle == "Alarm")
        
        XCTAssertNil(mainAlarmViewController.navigationItem.leftBarButtonItem)
        let rightButton = mainAlarmViewController.navigationItem.rightBarButtonItem
        XCTAssertNotNil(rightButton)
        XCTAssert(rightButton?.target?.identifier == "addSegue")
    }

}
