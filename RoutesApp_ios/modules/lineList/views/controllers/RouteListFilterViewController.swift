import UIKit

class RouteListFilterViewController: UIViewController {

    @IBOutlet var resetButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var filterTitleLabel: UILabel!

    var viewModel: RouteListViewModel

    init(viewModel: RouteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        viewModel = RouteListViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        filterTitleLabel.text = String.localizeString(localizedString: ConstantVariables.localizationLinesFilterTitle)
        setupTable()
    }

    @IBAction func doneAction(_ sender: Any) {
        guard viewModel.selectedFilterIndex != -1 else { return }
        viewModel.applyFilters(query: viewModel.queryAux)
    }

    @IBAction func resetAction(_ sender: Any) {
        viewModel.resetFilteredByCategoryRouteList()
        tableView.reloadData()
    }

    func setupTable() {
        let uiNib = UINib(nibName: TransportationCategoryTableViewCell.identifier, bundle: nil)
        tableView.register(uiNib, forCellReuseIdentifier: TransportationCategoryTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RouteListFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransportationCategoryTableViewCell.identifier, for: indexPath)
            as? TransportationCategoryTableViewCell ?? TransportationCategoryTableViewCell(style: .default,
                    reuseIdentifier: TransportationCategoryTableViewCell.identifier)
        cell.setStyle(selectedIndex: viewModel.selectedFilterIndex, currentIndex: indexPath.row,
                      lineCategory: viewModel.categories[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPathList = [IndexPath]()
        if viewModel.selectedFilterIndex != -1 {
            indexPathList.append(IndexPath(item: viewModel.selectedFilterIndex, section: 0))
        }
        indexPathList.append(indexPath)
        viewModel.selectedFilterIndex = indexPath.row
        tableView.reloadRows(at: indexPathList, with: .automatic)
    }
}
