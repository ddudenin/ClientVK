//
//  ViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 3/18/21.
//

import UIKit
import WebKit

final class VKLoginWebViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView! {
        didSet {
            self.webView.navigationDelegate = self
        }
    }
    
    private func loginRequest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7795401"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginRequest()
    }
}

extension VKLoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              let userId = Int(userIdString)
        else {
            decisionHandler(.allow)
            return
        }
        
        Session.instance.token = token
        Session.instance.userId = userId
        
        decisionHandler(.cancel)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "startScreen")
        self.present(vc, animated: true, completion: .none)
    }
}
