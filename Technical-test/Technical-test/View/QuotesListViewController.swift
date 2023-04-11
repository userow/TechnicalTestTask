//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UIViewController {

    //DATA
    private let dataManager: DataManager = DataManager()
    private var market: Market? = nil

    //UI
    let tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.fetchQuotes { [weak self] result /*Result<[Quote], Error>*/ in
            print(result)

            switch result {
            case .success(let market):
                self?.market = market

                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

        addSubviews()
        setupAutolayout()
    }

    func addSubviews() {
        // add table

        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = 66
        tableView.estimatedRowHeight = 66

        tableView.register(QuoteTableViewCell.self, forCellReuseIdentifier: QuoteTableViewCell.reuseId)         // register cell name

        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)
    }

    func setupAutolayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
}

extension QuotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let quote = market?.quotes?[indexPath.row] {
            let details = QuoteDetailsViewController(quote: quote)
            self.navigationController?.pushViewController(details, animated: true)
        }
    }
}

extension QuotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return market?.quotes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let quote = market?.quotes?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: QuoteTableViewCell.reuseId, for: indexPath) as? QuoteTableViewCell
        else {
            return UITableViewCell()
        }

        cell.setup(with: quote, del: self)

        return cell
    }
}

extension QuotesListViewController: ToggleFavoritesDelegate {

    func toggleFavorite(key: String?) {
        print("TOGGLE FAV PRESSED FOR \(key)")

        if let key {
            FavoritesManager.shared.toggleFavorite(key: key)
            reprocessFavs()
            tableView.reloadData()
        }
    }

    private func reprocessFavs() {
        if let quotes = market?.quotes {
            var qs = [Quote]()
            quotes.forEach{ quote in
                var q = quote
                if let key = quote.isin {
                    q.isFavorite = FavoritesManager.shared.isFavorite(key)
                }
                qs.append(q)
            }
            market?.quotes = qs
        }
    }
}
