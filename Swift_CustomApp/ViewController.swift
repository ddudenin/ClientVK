//
//  ViewController.swift
//  Swift_CustomApp
//
//  Created by user192247 on 3/18/21.
//

import UIKit
import WebKit

class VKLoginWtbViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7795401"),
            URLQueryItem(name: "redirect_uri", value: "https://vk.com/groups"),
            URLQueryItem(name: "group_ids", value: ""),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
}

extension VKLoginWtbViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
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
              let userId = Int(userIdString) else {
            decisionHandler(.cancel)
            return
        }
        
        Session.shared.token = token
        Session.shared.userId = userId
        
        //print(userId)
        //print(token)
        
        decisionHandler(.cancel)
    }
}
