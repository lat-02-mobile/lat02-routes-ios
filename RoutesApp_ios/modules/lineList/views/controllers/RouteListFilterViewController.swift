import UIKit

class RouteListFilterViewController: UIViewController {

    @IBOutlet var resetButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var filterTitleLabel: UILabel!

    var viewModel: RouteListViewModel

    let currentLocale = Locale.current.languageCode
    var isCurrentLocaleEsp = false

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
        isCurrentLocaleEsp = currentLocale == ConstantVariables.spanishLocale
        setupTable()
    }

    @IBAction func doneAction(_ sender: Any) {
        if viewModel.categoryAux != nil {
            viewModel.applyFilters(query: viewModel.queryAux, selectedCat: viewModel.categoryAux)
        }

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
        let category = viewModel.categories[indexPath.row]
        cell.setStyle(isSameCategory: category.id == viewModel.categoryAux?.id, lineCategory: category, isCurrentLocaleEsp: isCurrentLocaleEsp)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categoryAux = viewModel.categories[indexPath.row]
        tableView.reloadData()
    }
}
