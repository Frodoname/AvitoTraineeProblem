//
//  ListView.swift
//  AvitoTraineeProblem
//
//  Created by Fed on 27.10.2022.
//

import UIKit

protocol RefreshControlDelegate: AnyObject {
    func alertControllerToRefresh()
    func refreshControllerToRefresh()
}

final class ListView: UIView {
    
    // MARK: - Public Methods
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableViewDataSetup(with array: [Employee]) {
        self.array = array.sorted(by: { $0.name < $1.name })
        self.tableView.reloadData()
    }
    
    func stopRefreshControl() {
        refreshControll.endRefreshing()
    }
    
    func presentAlertContrller() -> UIAlertController {
        return self.alert
    }
    
    func startAnimateActivityIndicator(_ parameter: Bool) {
        switch parameter {
        case true:
            self.activityIndicator.startAnimating()
        case false:
            self.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Local Constants & Variables
    
    weak var delegate: RefreshControlDelegate?
    private var array: [Employee] = []
    private let cellId = "cellId"
    private let cellHeight: CGFloat = 80
    
    // MARK: - UI Elements
    
    private lazy var refreshControll: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let atributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: atributes)
        refreshControl.addTarget(self, action: #selector(refreshScrollView), for: .valueChanged)
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.refreshControl = refreshControll
        tableView.register(ListViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var alert: UIAlertController = {
        let title = "Error"
        let message = "Please, check your connection to Network"
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.delegate?.alertControllerToRefresh()
        }
        controller.addAction(action)
        return controller
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    // MARK: - Init & Deinit
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        layoutSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutSetup() {
        addSubview(tableView)
        addSubview(activityIndicator)
        tableView.prepareForAutoLayOut()
        activityIndicator.prepareForAutoLayOut()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func refreshScrollView() {
        delegate?.refreshControllerToRefresh()
    }
}

extension ListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ListViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: array[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
