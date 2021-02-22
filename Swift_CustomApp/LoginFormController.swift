//
//  LoginFormController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 23.01.2021.
//

import UIKit

class LoginFormController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loaderIndicator: CloudLoaderIndicator!
    
    private let userData = (login: "Tim Cook", password: "Apple1e12$")
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        self.scrollView?.contentInset = contentInsets
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //self.loaderIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let login = self.loginInput.text!
        let password = self.passwordInput.text!
        
        if login == self.userData.login && password == self.userData.password {
            
            let storyboard = UIStoryboard(name: "Main", bundle: .none)
            let vc = storyboard.instantiateViewController(withIdentifier: "startScreen")
            
            UIView.animateKeyframes(withDuration: 10,
                                    delay: 0,
                                    options: .autoreverse,
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 1,
                                                           animations: {
                                                            self.loaderIndicator.pathLayer.strokeEnd = 1
                                                           })
                                        UIView.addKeyframe(withRelativeStartTime: 1,
                                                           relativeDuration: 1,
                                                           animations: {
                                                            self.loaderIndicator.pathLayer.strokeStart = 0
                                                           })
                                    },
                                    completion: { _ in
                                        self.present(vc, animated: true, completion: .none)
                                    })
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
