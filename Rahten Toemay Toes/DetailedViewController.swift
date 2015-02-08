//
//  DetailedViewController.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/7/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func tapBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBOutlet weak var synopsisLabel: UILabel!
    var movie: NSDictionary = NSDictionary()

    @IBOutlet weak var imageViewPoster: UIImageView!
    
    @IBOutlet weak var scrollViewDude: UIScrollView!

    func back(sender: AnyObject){
        println("adsf")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var posterImageUrl = movie.valueForKeyPath("posters.original") as String
        posterImageUrl = posterImageUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: nil, range: nil)
        imageViewPoster.alpha = 0
        imageViewPoster.setImageWithURL(NSURL(string: posterImageUrl))
        synopsisLabel.text = movie.valueForKeyPath("synopsis") as? String
        synopsisLabel.sizeToFit()

        scrollViewDude.contentSize = CGSize(width: synopsisLabel.frame.width, height: synopsisLabel.frame.height + 10)

        


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(2.5, animations: { () -> Void in
            self.imageViewPoster.alpha = 1
            self.scrollViewDude.backgroundColor = UIColor(white:0.80, alpha:0.8)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
