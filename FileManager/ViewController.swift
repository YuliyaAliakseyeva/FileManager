//
//  ViewController.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 5.08.24.
//

import UIKit

class ViewController: UIViewController {
    
    var fileManagerService = FileManagerService()
    var imagePicker = ImagePicker()
    var currentSortingTipe: String = ""
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = fileManagerService.model.title
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
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true

        let createFolderButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(didTapCreateFolder))
        let createPhotoButton = UIBarButtonItem(image: UIImage(systemName: "photo.badge.plus"), style: .plain, target: self, action: #selector(didTapCreatePhoto))
        self.tabBarController?.navigationItem.rightBarButtonItems = [createFolderButton, createPhotoButton]
        
        tableView.reloadData()
    }
    
    @objc private func didTapCreateFolder() {
        TextPicker.showAddFolder(in: self) { [weak self] text in
            self?.fileManagerService.createDirectory(title: text)
            self?.tableView.reloadData()
        }
    }
    
    @objc private func didTapCreatePhoto() {
        imagePicker.showAddPhoto(in: self) { imageURL in
            let pathOriginPhoto = imageURL.path()
            let imageName: String = NSString(string: pathOriginPhoto).lastPathComponent as String
            self.fileManagerService.createFile(url: imageURL, addedPath: imageName)
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileManagerService.contentsOfDirectory().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        currentSortingTipe = UserDefaults.standard.string(forKey: "typeOfSorting") ?? ""
        if currentSortingTipe == "alphabetically" {
            var listOfFiles = fileManagerService.contentsOfDirectory().sorted(by: { (s1: String, s2: String) -> Bool in
                return s1 < s2
             })
            config.text = listOfFiles[indexPath.row]
        } else if currentSortingTipe == "reverseAlphabetically" {
            var listOfFiles = fileManagerService.contentsOfDirectory().sorted(by: { (s1: String, s2: String) -> Bool in
               return s1 > s2
            })
            config.text = listOfFiles[indexPath.row]
        } else {
            config.text = fileManagerService.contentsOfDirectory()[indexPath.row]
            
        }
        cell.contentConfiguration = config
        cell.accessoryType = fileManagerService.model.isPathForItemIsFolder(index: indexPath.row) ? .disclosureIndicator : .none
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fileManagerService.model.isPathForItemIsFolder(index: indexPath.row) {
            let vc = ViewController()
            vc.fileManagerService.model = Model(path: fileManagerService.model.path + "/" + fileManagerService.model.items[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManagerService.removeContent(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
}

