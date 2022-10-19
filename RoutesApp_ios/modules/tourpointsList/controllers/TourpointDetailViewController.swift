//
//  TourpointDetailViewController.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/19/22.
//

import UIKit

class TourpointDetailViewController: UIViewController {

    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var pointUIImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    var tourpoint: TourpointEntity

    init(tourpoint: TourpointEntity) {
        self.tourpoint = tourpoint
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.tourpoint = TourpointEntity()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        let currentLocale = Locale.current.languageCode

        // Containers
        categoryContainer.layer.cornerRadius = 5
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.2]
        containerView.layer.insertSublayer(gradient, at: 0)

        // Data from tourpoint
        ImageHelper.shared.downloadAndCacheImage(imageView: pointUIImage, urlString: tourpoint.urlImage)
        let categoryDesc = currentLocale == ConstantVariables.spanishLocale ? tourpoint.category.descriptionEsp : tourpoint.category.descriptionEng
        categoryLabel.text = categoryDesc
        nameLabel.text = tourpoint.name
        addressLabel.text = tourpoint.address
    }

    @IBAction func goToSearchButton(_ sender: Any) {
    }
}
