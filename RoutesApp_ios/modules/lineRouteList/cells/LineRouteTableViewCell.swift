import UIKit

class LineRouteTableViewCell: UITableViewCell {

    @IBOutlet weak var routeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateCell(lineRouteInfo: LineRouteInfo) {
        routeNameLabel.text = lineRouteInfo.name
    }
}
