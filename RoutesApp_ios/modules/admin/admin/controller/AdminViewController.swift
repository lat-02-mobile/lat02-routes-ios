import UIKit

class AdminViewController: UIViewController {
    var isSettingsController = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func goToUsersPanel(_ sender: Any) {
        let vc = UserListViewController()
        show(vc, sender: nil)
    }

    @IBAction func goToLinesPanel(_ sender: Any) {
        let vc = LinesViewController(nibName: "RouteListViewController", bundle: nil)
        show(vc, sender: nil)
    }
}
