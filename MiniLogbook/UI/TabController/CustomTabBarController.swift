import UIKit
import SnapKit

class CustomTabBarController: UITabBarController {
   private enum Constants {
      static let firstTabTitle = "Log"
      static let secondTabTitle = "List"
      static let fontSize: CGFloat = 16
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      self.viewControllers = [initialTabBar, finalTabBar]
      customizeTabBarItemAppearance()
   }
   
   private func customizeTabBarItemAppearance() {
      let fontAttributes: [NSAttributedString.Key: Any] = [
         .font: UIFont.boldSystemFont(ofSize: Constants.fontSize)
      ]
      UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
   }
   
   lazy public var initialTabBar: MainViewController = {
      let initialTabBar = MainViewController.buildDefault()
      let tabBarItem = UITabBarItem(title: Constants.firstTabTitle, image: nil, tag: 0)
      initialTabBar.tabBarItem = tabBarItem
      return initialTabBar
   }()
   
   lazy public var finalTabBar: UIViewController = {
      let finalTabBar = UIViewController()
      let tabBarItem = UITabBarItem(title: Constants.secondTabTitle, image: nil, tag: 1)
      finalTabBar.tabBarItem = tabBarItem
      return finalTabBar
   }()
}
