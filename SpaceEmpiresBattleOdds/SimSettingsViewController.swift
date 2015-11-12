//
//  SimSettingsViewController.swift
//  SpaceEmpiresBattleOdds
//
//  Created by Tibor Grose on 11/9/15.
//  Copyright © 2015 Tibor Grose. All rights reserved.
//

import UIKit

class SimSettingsViewController: UIViewController {
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var simIterationSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        simIterationSlider.value = Float(SimSettings.sharedInstance.simIterations)
        
        commitButton.addTarget(self, action: "commitChanges", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewWillDisappear(animated: Bool) {
        SimSettings.sharedInstance.simIterations = Int(simIterationSlider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commitChanges() {
        
        //SimSettings.sharedInstance.simIterations = Int(simIterationSlider.value)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
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
