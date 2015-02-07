//
//  DVDMovieViewController.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/7/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class DVDMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var DVDTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DVDTableView.dataSource = self
        self.DVDTableView.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    tableView
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
