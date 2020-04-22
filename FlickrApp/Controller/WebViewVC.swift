//
//  WebViewVC.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 22/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var linkUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView(url: linkUrl)
    }
    
    func setUpView(url: String){
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
 

}
