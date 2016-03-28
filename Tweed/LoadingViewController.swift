//
//  LoadingViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "tweed_loading"))
        self.view.addSubview(imageView)

        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

}
