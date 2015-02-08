//
//  MovieListController.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/5/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class MovieListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var refreshControl:UIRefreshControl!  // An optional variable
    @IBOutlet weak var movieTableView: UITableView!
    var movies: [NSDictionary]! = []
    var error: NSError!
    
    // Sorting Functions
    // These functions allow for sorting by critics score or audience score.
    var currentSortPath = "ratings.critics_score"
    func sortMovies(sender: AnyObject){
        movies = movies.sorted {
            var rating_1 = $0.valueForKeyPath(self.currentSortPath) as Int
            var rating_2 = $1.valueForKeyPath(self.currentSortPath) as Int
            return rating_1 > rating_2
        }
        self.movieTableView.reloadData()
    }
    func toggleSort(sender: AnyObject){
        currentSortPath = currentSortPath == "ratings.critics_score" ? "ratings.audience_score" : "ratings.critics_score"
        sortMovies(self)
        movieTableView.reloadData()
    }

    // Refresh function. Makes an API request.
    func refresh(sender: AnyObject){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            var turl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=30&country=us&apikey=atga3fvfzzwy697nhypzjs8y")
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
                    self.movieTableView.addSubview(ErrorCell)
                }else{
                    var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                    self.movies = responseDictionary["movies"] as [NSDictionary]
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var SortViewControl = UISegmentedControl(items:["Critics Rating", "Audience Rating"])
        self.movieTableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        SortViewControl.selectedSegmentIndex = 0
        SortViewControl.bounds = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 25)
        SortViewControl.addTarget(self, action: "toggleSort:", forControlEvents: .ValueChanged)
        movieTableView.tableHeaderView = SortViewControl
        
        
        // Refresh Code Start
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull Harder!")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        movieTableView.addSubview(refreshControl)

        // Refresh Code End
        refresh(self)

        movieTableView.dataSource = self
        movieTableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tableView definitions
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = movieTableView.dequeueReusableCellWithIdentifier("MovieHeader") as MovieHeaderTableViewCell
        header.movieTitleLabel.text = movies[section].valueForKeyPath("title") as String!
        header.movieTitleLabel.sizeToFit()
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCellTableViewCell
        var posterImageUrl = self.movies[indexPath.section].valueForKeyPath("posters.original") as String
        cell.posterImage.setImageWithURL(NSURL(string: posterImageUrl))
        cell.posterImage.alpha = 0
        UIView.animateWithDuration(1.5, animations: {() -> Void in
            cell.posterImage.alpha = 1
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            posterImageUrl = posterImageUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: nil, range: nil)
            var url = NSURL(string: posterImageUrl)
            var request = NSURLRequest(URL: url!)
            cell.posterImage.setImageWithURLRequest(request, placeholderImage: cell.posterImage.image, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    cell.posterImage.image = image
                })
            }, failure:nil)
        })
        dispatch_async(dispatch_get_main_queue(), {
            return
        })

        cell.Synopsis.text = self.movies[indexPath.section].valueForKeyPath("synopsis") as String!
        cell.criticsratingImage.image = UIImage(named: getImage("critics", section: indexPath.section))
        cell.audiencereviewImage.image = UIImage(named: getImage("audience", section: indexPath.section))
        return cell
    }
    
    //This function puts the correct image for the rating
    func getImage(rating: NSString, section: Int) -> String{
        var ratingType = movies[section].valueForKeyPath("ratings."+rating+"_rating") as String!
        if !contains(["Certified Fresh","Fresh","Rotten","Upright", "Spilled"], ratingType){
            ratingType = "wtsicon"
        }
        return ratingType+".png"
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as DetailedViewController
        var idx = movieTableView.indexPathForCell(sender as UITableViewCell)
        vc.movie = self.movies[idx!.section]
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
