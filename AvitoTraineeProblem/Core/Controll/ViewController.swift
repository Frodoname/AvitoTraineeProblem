//
//  ViewController.swift
//  AvitoTraineeProblem
//
//  Created by Fed on 27.10.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Local Constants & Variables
    
    private lazy var networkService = NetworkService()
    private var listView: ListView!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetup()
        navigationBarSetup()
        listView.tableViewSetup()
        listView.delegate = self
        networkSetup(indicatorAnimating: true)
    }
    
    // MARK: - ViewController Setup
    
    private func layoutSetup() {
        view.backgroundColor = .white
        listView = ListView(frame: view.bounds)
        view.addSubview(listView)
    }
    
    private func navigationBarSetup() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Employees"
    }
    
    private func networkSetup(indicatorAnimating: Bool) {
        listView.startAnimateActivityIndicator(indicatorAnimating)
        networkService.fetchData { result in
            switch result {
            case .success(let success):
                self.listView.tableViewDataSetup(with: success.company.employees)
                self.listView.startAnimateActivityIndicator(false)
                self.listView.stopRefreshControl()
            case .failure(let failure):
                print(failure.localizedDescription)
                self.listView.startAnimateActivityIndicator(false)
                self.listView.stopRefreshControl()
                self.present(self.listView.presentAlertContrller(), animated: true)
            }
        }
    }
}

// MARK: - Extensions

extension ViewController: RefreshControlDelegate {
    func refreshControllerToRefresh() {
        networkSetup(indicatorAnimating: false)
    }
    
    func alertControllerToRefresh() {
       networkSetup(indicatorAnimating: true)
    }
}

