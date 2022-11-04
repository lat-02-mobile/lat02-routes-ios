import UIKit
import Kingfisher

class TransportationCategoryTableViewCell: UITableViewCell {

    static let identifier = "TransportationCategoryTableViewCell"

    @IBOutlet var transportationImage: UIImageView!
    @IBOutlet var transportationNameLabel: UILabel!
    @IBOutlet var checkMarkImage: UIImageView!
    @IBOutlet var checkMarkImageHeight: NSLayoutConstraint!
    @IBOutlet var checkMarkImageWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    func setStyle(isSameCategory: Bool, lineCategory: LineCategoryEntity, isCurrentLocaleEsp: Bool) {
        transportationNameLabel.text = isCurrentLocaleEsp ? lineCategory.nameEsp : lineCategory.nameEng
        ImageHelper.shared.downloadAndCacheImage(imageView: transportationImage, urlString: lineCategory.blackIcon)
        if isSameCategory {
            checkMarkImage.isHidden = false
            transportationNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            checkMarkImageHeight.constant = 30
            return
        }
        setDefaultStyle()
    }

    func setStyleForTourPoint(isSameCategory: Bool, tourPointCategory: TourpointCategoryEntity, isCurrentLocaleEsp: Bool) {
        transportationNameLabel.text = isCurrentLocaleEsp ? tourPointCategory.descriptionEsp.capitalized :
        tourPointCategory.descriptionEng.capitalized
        ImageHelper.shared.downloadAndCacheImage(imageView: transportationImage, urlString: tourPointCategory.icon)
        if isSameCategory {
            checkMarkImage.isHidden = false
            transportationNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            checkMarkImageHeight.constant = 30
            return
        }
        setDefaultStyle()
    }

    private func setDefaultStyle() {
        checkMarkImage.isHidden = true
        transportationNameLabel.font = UIFont.systemFont(ofSize: 16)
        checkMarkImageHeight.constant = 25
    }
}
