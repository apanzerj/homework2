//
//  DVDMovieViewController.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/7/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class DVDMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dvds: [NSDictionary] = []
    var refreshControl:UIRefreshControl!  // An optional variable
    var currentSortPath = "ratings.critics_score"

    @IBOutlet weak var dvdTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull Harder!")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        dvdTableView.addSubview(refreshControl)
        request(self)
        
        dvdTableView.dataSource = self
        dvdTableView.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sortMovies(sender: AnyObject){
        dvds = dvds.sorted {
            var rating_1 = $0.valueForKeyPath(self.currentSortPath) as Int
            var rating_2 = $1.valueForKeyPath(self.currentSortPath) as Int
            return rating_1 > rating_2
        }
        self.dvdTableView.reloadData()
    }
    func toggleSort(sender: AnyObject){
        currentSortPath = currentSortPath == "ratings.critics_score" ? "ratings.audience_score" : "ratings.critics_score"
        sortMovies(self)
        dvdTableView.reloadData()
    }

    func request(sender: AnyObject){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            var turl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=atga3fvfzzwy697nhypzjs8y")
            var request = NSURLRequest(URL: turl!)
            var queue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if((error) != nil){
                    var ErrorCell = UIView()
                    ErrorCell.frame = CGRect(x: 0, y: 25, width:UIScreen.mainScreen().bounds.width, height: 50)
                    var ErrorMessageLabel = UILabel()
                    ErrorMessageLabel.text = "There was an error accessing your network"
                    ErrorMessageLabel.frame =  CGRect(x: 0, y: 2.5, width: UIScreen.mainScreen().bounds.width, height: 50)
                    ErrorMessageLabel.textAlignment = NSTextAlignment.Center
                    ErrorCell.backgroundColor = UIColor.blackColor()
                    ErrorMessageLabel.textColor = UIColor.whiteColor()
                    ErrorCell.addSubview(ErrorMessageLabel)
                    self.dvdTableView.addSubview(ErrorCell)
                }else{
                    var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                    self.dvds = responseDictionary["movies"] as [NSDictionary]
                    self.sortMovies(self)
                }
            })
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                return
            })
        })
        refreshControl.endRefreshing()
    }

    // UITableView Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dvds.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = dvdTableView.dequeueReusableCellWithIdentifier("dvdCell") as DVDCellTableViewCell
        var url_for_poster = dvds[indexPath.section].valueForKeyPath("posters.original") as String
        cell.dvdPoster.setImageWithURL(NSURL(string: url_for_poster))
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            url_for_poster = url_for_poster.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: nil, range: nil)
            var url = NSURL(string: url_for_poster)
            var request = NSURLRequest(URL: url!)
            cell.dvdPoster.setImageWithURLRequest(request, placeholderImage: cell.dvdPoster.image, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    cell.dvdPoster.image = image
                })
                }, failure:nil)
        })
        dispatch_async(dispatch_get_main_queue(), {
            return
        })
        cell.audienceRating.image = UIImage(named: getImage("audience", section: indexPath.section))
        cell.criticsRating.image = UIImage(named: getImage("critics", section: indexPath.section))
        cell.dvdSynopsis.text = dvds[indexPath.section].valueForKeyPath("synopsis") as? String
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = dvdTableView.dequeueReusableCellWithIdentifier("dvdHeaderCell") as DVDHeaderTableViewCell
        cell.dvdHeaderTitle.text = dvds[section].valueForKeyPath("title") as? String
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func getImage(rating: NSString, section: Int) -> String{
        var ratingType = dvds[section].valueForKeyPath("ratings."+rating+"_rating") as String!
        if !contains(["Certified Fresh","Fresh","Rotten","Upright", "Spilled"], ratingType){
            ratingType = "wtsicon"
        }
        return ratingType+".png"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as DetailedViewController
        var idx = dvdTableView.indexPathForCell(sender as UITableViewCell)
        vc.movie = dvds[idx!.section]
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
