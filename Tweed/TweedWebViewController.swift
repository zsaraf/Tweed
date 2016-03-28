//
//  TweedWebViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class TweedWebViewController: UIViewController {
    var startingUrl: String
    var webView: UIWebView!

    init(startingUrl: String) {
        self.startingUrl = startingUrl

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = UIWebView(frame: CGRectZero)
        self.webView.scalesPageToFit = true
        self.view.addSubview(self.webView)

        self.webView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        let request = NSURLRequest(URL: NSURL(string: self.startingUrl)!)
        self.webView.loadRequest(request)

        self.setupBackButton()
    }

    func setupBackButton() {
        let backButton = UIButton(type: .Custom)
        backButton.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        backButton.setImage(UIImage(named: "back_white"), forState: .Normal)
        backButton.addTarget(self, action: "popBack", forControlEvents: .TouchUpInside)
        let barButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItems = [barButtonItem]
    }

    func popBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }


}
