//
//  MovieListController.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/5/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class MovieListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieTableView: UITableView!
    var movies: [NSDictionary]! = []
    var error: NSError!
    var descriptor: NSSortDescriptor = NSSortDescriptor(key: "ratings.critics_rating", ascending: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
            var turl = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=30&country=us&apikey=atga3fvfzzwy697nhypzjs8y")
            var request = NSURLRequest(URL: turl!)
            var queue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = responseDictionary["movies"] as [NSDictionary]
                self.movies = self.movies.sorted {
                    var rating_1 = $0.valueForKeyPath("ratings.critics_score") as Int
                    var rating_2 = $1.valueForKeyPath("ratings.critics_score") as Int
                    return rating_1 > rating_2
                }
                self.movieTableView.reloadData()
            })
            dispatch_async(dispatch_get_main_queue(), {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                return
            })
        })
        movieTableView.dataSource = self
        movieTableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //posterImageUrl = posterImageUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: nil, range: nil)
        cell.posterImage.setImageWithURL(NSURL(string: posterImageUrl))

        cell.Synopsis.text = self.movies[indexPath.section].valueForKeyPath("synopsis") as String!
        cell.criticsratingImage.image = UIImage(named: getImage("critics", section: indexPath.section))
        cell.audiencereviewImage.image = UIImage(named: getImage("audience", section: indexPath.section))
        return cell
    }

    func getImage(rating: NSString, section: Int) -> String{
        var ratingType = movies[section].valueForKeyPath("ratings."+rating+"_rating") as String!
        if !contains(["Certified Fresh","Fresh","Rotten","Upright", "Spilled"], ratingType){
            ratingType = "wtsicon"
        }
        return ratingType+".png"
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = movieTableView.dequeueReusableCellWithIdentifier("MovieHeader") as MovieHeaderTableViewCell
        header.movieTitleLabel.text = movies[section].valueForKeyPath("title") as String!
        header.movieTitleLabel.sizeToFit()
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
