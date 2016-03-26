//
//  HomeViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        self.title = "TWEED"

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsMake(0, UIScreen.mainScreen().bounds.size.width * CGFloat(TweedViewConstants.CellLeftContentInsetMultiplier), 0, 0)
        self.view.addSubview(self.tableView)

        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: UITableViewDelegate & UITableViewDataSource methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "TweedTweetCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TweetTableViewCell
        if cell == nil {
            cell = TweetTableViewCell(style: .Default, reuseIdentifier: identifier)
        }

        cell?.messageTextView.text = "Hey this is my first tweet. Feels good to be alive! Read all of my tweets. Catch up on everything."
        cell?.dateLabel.text = "4/15/15"
        cell?.nameLabel.text = "Zach S."
        cell?.handleLabel.text = "@zacharysaraf"
        cell?.profileImageView.sd_setImageWithURL(NSURL(string: "https://media.licdn.com/mpr/mpr/shrinknp_200_200/p/7/000/211/124/06ee517.jpg"))

        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
