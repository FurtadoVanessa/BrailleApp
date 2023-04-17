import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = tabBar.standardAppearance
        appearance.shadowColor = .black
        UITabBar.appearance().barTintColor = .white
        tabBar.tintColor = .label
        tabBar.standardAppearance = appearance
        setupVCs()
    }
    
    func setupVCs() {
          viewControllers = [
            createNavController(for: BrailleConfigurator().resolve(), title: NSLocalizedString("Inicio", comment: ""), image: UIImage(systemName: "house")!),
              createNavController(for: CreatePDFConfigurator().resolve(), title: NSLocalizedString("Gerar PDF", comment: ""), image: UIImage(systemName: "magnifyingglass")!),
              createNavController(for: CustomPageConfigurator().resolve(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "trapezoid.and.line.vertical")!)
          ]
        
      }
    
    fileprivate func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.badgeColor = .black
        navController.setNavigationBarHidden(true, animated: false)
        
        return navController
      }

}
