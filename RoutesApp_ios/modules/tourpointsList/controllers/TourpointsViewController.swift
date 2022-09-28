//
//  TourpointsViewController.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/27/22.
//

import UIKit

class TourpointsViewController: UIViewController {

    @IBOutlet weak var tourpointSearchbar: UISearchBar!

    @IBOutlet weak var tourpointTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    private func setUpViews() {
        tourpointTableView.delegate = self
        tourpointTableView.dataSource = self
        let uiNib = UINib(nibName: TourpointTableViewCell.nibName, bundle: nil)
        tourpointTableView.register(uiNib, forCellReuseIdentifier: TourpointTableViewCell.identifier)
        tourpointSearchbar.backgroundImage = UIImage()
        tourpointSearchbar.searchTextField.backgroundColor = .white
    }

}

// MARK: Table view extension
extension TourpointsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TourpointTableViewCell.identifier, for: indexPath)
                as? TourpointTableViewCell else { return UITableViewCell()}
        return cell
    }
}
