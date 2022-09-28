//
//  TourpointsViewController.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/27/22.
//

import UIKit
import SVProgressHUD

class TourpointsViewController: UIViewController {

    @IBOutlet weak var tourpointSearchbar: UISearchBar!
    @IBOutlet weak var tourpointTableView: UITableView!

    var viewmodel = TourpointsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        initViewModel()

    }

    private func setUpViews() {
        tourpointTableView.delegate = self
        tourpointTableView.dataSource = self
        let uiNib = UINib(nibName: TourpointTableViewCell.nibName, bundle: nil)
        tourpointTableView.register(uiNib, forCellReuseIdentifier: TourpointTableViewCell.identifier)
        tourpointSearchbar.backgroundImage = UIImage()
        tourpointSearchbar.searchTextField.backgroundColor = .white
        SVProgressHUD.show()
    }

    private func initViewModel() {
        viewmodel.getTourpoints()
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.tourpointTableView.reloadData()
        }
        viewmodel.onError = { _ in
            SVProgressHUD.dismiss()
        }
    }

}

// MARK: Table view extension
extension TourpointsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.pointsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TourpointTableViewCell.identifier, for: indexPath)
                as? TourpointTableViewCell else { return UITableViewCell()}
        let point = viewmodel.getPointAt(index: indexPath.row)
        cell.updateCellModel(tourpointInfo: point)
        return cell
    }
}
