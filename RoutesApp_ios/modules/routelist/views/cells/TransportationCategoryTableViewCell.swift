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

    func setStyle(selectedIndex: Int, currentIndex: Int, lineCategory: LinesCategory) {
        transportationNameLabel.text = lineCategory.nameEng
        ImageHelper.shared.downloadAndCacheImage(imageView: transportationImage, urlString: lineCategory.blackIcon ?? "")
        if selectedIndex == currentIndex {
            checkMarkImage.isHidden = false
            transportationNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            checkMarkImageHeight.constant = 30
            checkMarkImageHeight.constant = 30
            return
        }
        setDefaultStyle()
    }

    func resetStyle(resetCell: Bool = false) {
        setDefaultStyle()
    }

    private func setDefaultStyle() {
        checkMarkImage.isHidden = true
        transportationNameLabel.font = UIFont.systemFont(ofSize: 16)
        checkMarkImageHeight.constant = 25
        checkMarkImageHeight.constant = 25
    }
}
