//
//  MainViewController.swift
//  FlappyBird
//
//  Created by Quan Nguyen Dinh on 11/13/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import Firebase

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    @IBAction func startAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func settingAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func exitAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GuildViewController")
        self.present(controller, animated: true, completion: nil)
    }
}



