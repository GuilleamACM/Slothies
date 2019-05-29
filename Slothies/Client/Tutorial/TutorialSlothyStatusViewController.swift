//
//  TutorialSlothyStatusViewController.swift
//  Slothies
//
//  Created by Guilherme Augusto Campos de Melo on 5/28/19.
//  Copyright © 2019 Slothies Inc. All rights reserved.
//

import UIKit

class TutorialSlothyStatusViewController: UIViewController {

    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusBlur: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusView.layer.cornerRadius = 10
        statusView.layer.masksToBounds = true
        statusBlur.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        statusBlur.addSubview(blurEffectView)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
