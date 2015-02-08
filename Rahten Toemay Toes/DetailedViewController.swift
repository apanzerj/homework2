//
//  DetailedViewController.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/7/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func tapBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBOutlet weak var synopsisLabel: UILabel!
    var movie: NSDictionary = NSDictionary()

    @IBOutlet weak var imageViewPoster: UIImageView!
    

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
        var y_value = synopsisLabel.frame.origin.y
        var bounds = UIScreen.mainScreen().bounds
        var w_value = bounds.width - 10 as CGFloat
        var h_value = 10 as CGFloat
        synopsisLabel.frame = CGRect(x: 5, y: y_value, width: w_value, height: h_value)
        synopsisLabel.backgroundColor = UIColor(white:0.80, alpha:1)




        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(2.5, animations: { () -> Void in
            self.imageViewPoster.alpha = 1
            
            self.synopsisLabel.alpha = 0.8
            self.synopsisLabel.sizeToFit()
            var frame = self.synopsisLabel.frame
            self.synopsisLabel.frame = CGRect(x: frame.origin.x, y: UIScreen.mainScreen().bounds.height - frame.height - 5, width: frame.width, height: frame.height)
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
