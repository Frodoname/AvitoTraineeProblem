//
//  TableViewCell.swift
//  AvitoTraineeProblem
//
//  Created by Fed on 27.10.2022.
//

import UIKit

final class ListViewCell: UITableViewCell {
    
    // MARK: - Public Methods
    
    func configureCell(with person: Employee) {
        personName.text = person.name
        personNumber.text = "Phone: \(person.phoneNumber)"
        personSkills.text = ("Skills: \(person.skills.joined(separator: ", "))")
        selectionStyle = .none
    }
    
    // MARK: - Local Constants
    
    private let cellId = "cellId"
    private let imageWidth: CGFloat = 44
    private let nameFontSize: CGFloat = 21
    private let infoFontSize: CGFloat = 15
    private let sViewSpacing: CGFloat = 10
    
    // MARK: - UI Elements
    
    private lazy var image: UIImageView = {
        let image = UIImage(systemName: "person.circle")
        let view = UIImageView(image: image)
        view.layer.cornerRadius = imageWidth / 2
        view.contentMode = .scaleAspectFit
        view.prepareForAutoLayOut()
        view.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        return view
    }()
    
    private lazy var personName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: nameFontSize, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var personNumber: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: infoFontSize, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var personSkills: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: infoFontSize, weight: .regular)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var smallVertivalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personNumber, personSkills])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personName, smallVertivalStack])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [image, vStack])
        stackView.spacing = sViewSpacing
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: cellId)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        contentView.addSubview(hStack)
        hStack.prepareForAutoLayOut()
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
