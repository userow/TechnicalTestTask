//
//  QuoteTableViewCell.swift
//  Technical-test
//
//  Created by Pavlo Vasylenko on 11.04.2023.
//

import UIKit

protocol ToggleFavoritesDelegate: AnyObject {
    func toggleFavorite(key: String?)
//    func setFavorite(:Bool, key: String)
}

class QuoteTableViewCell: UITableViewCell {

    weak var delegate: ToggleFavoritesDelegate?

    public static let reuseId = "QuoteTableViewCell"

    var quoteKey: String?

    let nameLabel = UILabel()
    let lastLabel = UILabel()
    let currencyLabel = UILabel()
    let readableLastChangePercentLabel = UILabel()
    let favoriteButton = UIButton()


    let imgUser = UIImageView()
    let labUserName = UILabel()
    let labMessage = UILabel()
    let labTime = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setupAutolayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        nameLabel.textAlignment = .left
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .lightGray

        lastLabel.textAlignment = .right
        lastLabel.font = .systemFont(ofSize: 16)

        //added to Currency
//        currencyLabel.topAnchor.constraint(equalTo: lastLabel.topAnchor),
//        currencyLabel.leadingAnchor.constraint(equalTo: lastLabel.trailingAnchor, constant: 5),
//        currencyLabel.widthAnchor.constraint(equalToConstant: 50 ),
//        currencyLabel.heightAnchor.constraint(equalToConstant: 44),

        readableLastChangePercentLabel.textAlignment = .center
        readableLastChangePercentLabel.font = .systemFont(ofSize: 16)

        favoriteButton.layer.masksToBounds = true
        favoriteButton.addTarget(self, action: #selector(didPressFavoriteButton), for: .touchUpInside)
        favoriteButton.setImage(UIImage(named: "no-favorite"), for: .normal)
        favoriteButton.setImage(UIImage(named: "favorite"), for: .selected)

        contentView.addSubview(nameLabel)
        contentView.addSubview(lastLabel)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(readableLastChangePercentLabel)
        contentView.addSubview(favoriteButton)
    }

    func setupAutolayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastLabel.translatesAutoresizingMaskIntoConstraints = false
        // currencyLabel.translatesAutoresizingMaskIntoConstraints = false //added to Last
        readableLastChangePercentLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),

            lastLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            lastLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 4),
            lastLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),

//            currencyLabel.topAnchor.constraint(equalTo: lastLabel.topAnchor),
//            currencyLabel.leadingAnchor.constraint(equalTo: lastLabel.trailingAnchor, constant: 5),
//            currencyLabel.widthAnchor.constraint(equalToConstant: 50 ),
//            currencyLabel.heightAnchor.constraint(equalToConstant: 44),

            readableLastChangePercentLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),
            readableLastChangePercentLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),
            readableLastChangePercentLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            favoriteButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    func setup(with quote: Quote, del: ToggleFavoritesDelegate) {
        nameLabel.text = quote.name
        lastLabel.text = (quote.last ?? "") + " " + (quote.currency ?? "")

        readableLastChangePercentLabel.text = quote.readableLastChangePercent

        //button.selected for FAV
        favoriteButton.isSelected = quote.isFavorite

        // i thought it would be some RGB hex.
        if quote.variationColor == "red" {
            readableLastChangePercentLabel.textColor = .red
        } else if quote.variationColor == "green" {
            readableLastChangePercentLabel.textColor = .green
        }

        quoteKey = quote.isin
        delegate = del
    }

    @objc func didPressFavoriteButton(_ sender:UIButton!) {
        print("fav tapped - \(quoteKey), \(favoriteButton.isSelected)")

        delegate?.toggleFavorite(key: quoteKey)
    }
}
