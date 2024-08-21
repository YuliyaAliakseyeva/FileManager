//
//  LogInViewController.swift
//  FileManager
//
//  Created by Yuliya Vodneva on 15.08.24.
//

import UIKit
import KeychainAccess

class LogInViewController: UIViewController {
    
    var isPassword: Bool?
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "enter password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
        
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let password = PasswordViewModel.shared.getPassword() {
            print(password)
            isPassword = true
        } else {
            isPassword = false
        }
        
        if isPassword! {
            passwordButton.setTitle("Введите пароль", for: .normal)
            passwordButton.addTarget(self, action: #selector(enteredPassword), for: .touchUpInside)
        } else {
            passwordButton.setTitle("Создать пароль", for: .normal)
            passwordButton.addTarget(self, action: #selector(createdPassword), for: .touchUpInside)
        }
        
    }
    
    @objc func createdPassword() {
       let vc = CreatePasswordViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
        vc.completion = {
            self.isPassword = true
            self.viewWillAppear(true)
        }
    }
    
    @objc func enteredPassword() {
        if passwordTextField.text?.count ?? 0 > 3, PasswordViewModel.shared.checkPassword(interedPassword: passwordTextField.text ?? "") {
            self.passwordButton.setTitle("Повторите пароль", for: .normal)
            self.passwordTextField.text = ""
            self.passwordButton.addTarget(self, action: #selector(secondEnteredPassword), for: .touchUpInside)
        } else {
            let alert = UIAlertController(title: "Неверный пароль", message: nil, preferredStyle: .alert)
            
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAlertAction)
            
            present(alert, animated: true)
            
        }
    }
    
    @objc func secondEnteredPassword() {
        let tabBarController = UITabBarController()
        
        let listVC = ViewController()
        let settingsVC = SettingsViewController()
        
        let listNavigationController = UINavigationController(rootViewController: listVC)
        
        tabBarController.viewControllers = [listNavigationController, settingsVC]
        
        listVC.tabBarItem = UITabBarItem(title: "Docs", image: UIImage(systemName: "doc"), tag: 0)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 0)
        
       
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    private func setUpSubviews() {
        view.addSubview(passwordTextField)
        view.addSubview(passwordButton)
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -200),
            passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            passwordButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            passwordButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

