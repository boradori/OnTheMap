//
//  AuthViewController.swift
//  OnTheMap
//
//  Created by Youngsun Paik on 6/7/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    var completionHandlerForView: ((success: Bool, errorString: String?) -> Void)? = nil
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "On The Map Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AuthViewController.cancelAuth))
        
    }
    
    // MARK: Cancel Auth Flow
    func cancelAuth() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}


extension AuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.request!.URL!.absoluteString)
    }
    
}