//
//  WViewController.swift
//  Octlite
//
//  Created by Pop Pro on 11/26/15.
//  Copyright © 2015 Poppro. All rights reserved.
//

import UIKit

class WViewController: UIViewController {

    @IBOutlet weak var trophy: UIImageView!
    @IBOutlet weak var octile2: UIImageView!
    @IBOutlet weak var octile1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Start(sender: UIButton) {
        let angle = CGFloat(5)
        UIView.animateWithDuration(0.60, animations: {
            self.octile1.transform = CGAffineTransformMakeRotation((angle))
        })
    }
    
    @IBAction func TB(sender: UIButton) {
        let angle = CGFloat(5)
        UIView.animateWithDuration(0.15, animations: {
        self.trophy.alpha = 0.3
        })
        UIView.animateWithDuration(0.60, animations: {
            self.octile2.transform = CGAffineTransformMakeRotation((angle))
        })
    }
    

}
