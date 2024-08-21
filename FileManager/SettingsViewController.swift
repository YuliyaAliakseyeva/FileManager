//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 19.08.24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var sortingTipes: [String] = ["alphabetically", "reverseAlphabetically"]
    var currentSortingTipe: String = "alphabetically"

    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
        
//        subscribeOnNotificationCenter()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
    }
    
//    func subscribeOnNotificationCenter() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(notificationAction),
//            name: .changeTypeOfSorting,
//            object: nil
//        )
//    }
//    
//    @objc func notificationAction() {
//        print("Подписка на notification center")
//    }

}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            2
        } else {
            1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            var config = UIListContentConfiguration.cell()
            config.text = sortingTipes[indexPath.row]
            if let sort = UserDefaults.standard.string(forKey: "typeOfSorting"), sort == config.text {
                cell.accessoryType = .checkmark
                currentSortingTipe = sort
            } else {
                cell.accessoryType = .none
            }
            cell.contentConfiguration = config
//            NotificationCenter.default.post(name: .changeTypeOfSorting, object: nil)
            return cell
        } else {
            let cell = UITableViewCell()
            var config = UIListContentConfiguration.cell()
            config.text = "Сменить пароль"
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            "Сортировка"
        } else {
            "Смена пароля"
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            UserDefaults.standard.setValue(sortingTipes[indexPath.row], forKeyPath: "typeOfSorting")
            self.tableView.reloadData()
        } else {
            let vc = CreatePasswordViewController()
            vc.exist = true
             vc.modalPresentationStyle = .pageSheet
             vc.modalTransitionStyle = .flipHorizontal
             present(vc, animated: true)
        }
    }
}

//extension NSNotification.Name {
//    static let changeTypeOfSorting = NSNotification.Name(rawValue: "changeTypeOfSorting")
//}
//

    
