//
//  LoginFormController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 23.01.2021.
//

import UIKit

final class LoginFormController: UIViewController {
    
    @IBOutlet private var loginInput: UITextField!
    @IBOutlet private var passwordInput: UITextField!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var loaderIndicator: CloudLoaderIndicator!
    
    private let userLoginData = (login: "Tim Cook", password: "Apple1e12$")
    
    @objc private func keyboardWillBeShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        self.scrollView?.contentInset = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //self.loaderIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction private func loginButtonPressed(_ sender: Any) {
        let login = self.loginInput.text!
        let password = self.passwordInput.text!
        
        if login == self.userLoginData.login && password == self.userLoginData.password {
            
            let storyboard = UIStoryboard(name: "Main", bundle: .none)
            let vc = storyboard.instantiateViewController(withIdentifier: "startScreen")
            self.loaderIndicator.animate(completion: { _ in self.present(vc, animated: true, completion: .none)                            })
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction private func loginVKButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVKScreen")
        self.present(vc, animated: true, completion: .none)
    }
}

extension LoginFormController: UITextFieldDelegate {
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case loginInput:
            passwordInput.becomeFirstResponder()
        default:
            passwordInput.resignFirstResponder()
        }
    }
    
    // Called on returnKey pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return false
    }
}
