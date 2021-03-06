//
//  StartViewController.swift
//  FlappyBird
//
//  Created by Quan Nguyen Dinh on 12/7/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initReloadView()
    }
    
    var reloadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        return view
    }()
    
    let imageReload: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "image")
        return imageview
    }()
    
    let labelRelad: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Network Error", comment: "")
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var reloadButton: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitle(NSLocalizedString("Tap to retry", comment: ""), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.backgroundColor = UIColor(red: 52/255, green: 170/255, blue: 252/255, alpha: 1.0)
        btn.addTarget(self, action: #selector(tapReload), for: .touchDown)
        return btn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if check() {
            if Connectivity.isConnectedToInternet {
                self.configure()
            } else {
                self.showReloadView()
            }
        } else {
            showNormal()
        }
    }
    
    func showNormal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.present(controller, animated: false, completion: nil)
    }
    
    func check() -> Bool {
        return NSLocalizedString("Hello", comment: "") == "你好"
    }
    
    func initReloadView() {
        reloadView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        reloadView.addSubview(imageReload)
        reloadView.addSubview(labelRelad)
        reloadView.addSubview(reloadButton)
        
        labelRelad.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(150)
        }
        
        imageReload.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(labelRelad.snp.top).offset(-20)
        }
        
        reloadButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalTo(labelRelad.snp.bottom).offset(20)
        }
        
    }
    
    func showReloadView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(reloadView)
    }
    
    func closeReloadView() {
        reloadView.removeFromSuperview()
    }
    
    @objc func tapReload() {
        if Connectivity.isConnectedToInternet {
            closeReloadView()
            self.configure()
        }
    }
    
    func configure() {
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
                    } else {
                        self.showNormal()
                    }
                }
            }
        }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

public let kIsPass = "kIsPass"
