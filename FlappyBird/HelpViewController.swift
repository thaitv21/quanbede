//
//  HelpViewController.swift
//  ThreeEatOne
//
//  Created by 卢秋星 on 2018/7/14.
//  Copyright © 2018年 Sven Deichsel. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class HelpViewController: UIViewController, WKNavigationDelegate {
    
    var appleStoreUrl = ""
    
    var callback: (() -> Void)?
    
    var wk:WKWebView!
    
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
        label.text = "网络错误"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var reloadButton: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitle("请点击重试", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.backgroundColor = UIColor(red: 52/255, green: 170/255, blue: 252/255, alpha: 1.0)
        btn.addTarget(self, action: #selector(tapReload), for: .touchDown)
        return btn
    }()
    
    var url: URL!
    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(UIApplication.shared.statusBarFrame.height), width: UIScreen.main.bounds.width, height: 2))
        self.progressView.tintColor = UIColor.green      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wk = WKWebView()
        self.view.addSubview(wk)
        self.view.addSubview(progressView)
        self.view.backgroundColor = .black
        wk.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        wk.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        self.navigationController?.isNavigationBarHidden = true
        wk.navigationDelegate = self
        
        initReloadView()
//
//        if(appleStoreUrl == "") {
//            url = URL(fileURLWithPath: Bundle.main.bundlePath + "/modules/index.html")
//            let closeBtn = UIButton(type: .system)
//            closeBtn.titleLabel?.font = UIFont.init(name: "ionicons", size: 24)
//            closeBtn.setTitle("", for: .normal)
//            closeBtn.setTitleColor(UIColor.black, for: .normal)
//            closeBtn.addTarget(self, action: #selector(self.closePanel), for: .touchUpInside)
//            closeBtn.frame = CGRect(x: 16, y: CGFloat(UIApplication.shared.statusBarFrame.height), width: 44, height: 44)
//            self.view.addSubview(closeBtn)
//        }else{
            url = URL(string: appleStoreUrl)!
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.rect()
            }
//        }
        
        wk.load(URLRequest(url: url))
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
    
    override func viewWillLayoutSubviews() {
        if let cb = self.callback {
            cb()
        }
    }
    
    func rect(){
        let w = UIScreen.main.bounds.width
        let bh:CGFloat = 44
        let bview = UIView()
        let line = UIView(frame: CGRect.init(x: 0, y: 0, width: w, height: 0.5))
        line.backgroundColor = UIColor.gray
        bview.backgroundColor = UIColor.white
        self.view.addSubview(bview)
        bview.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(bh)
        }
        bview.addSubview(line)
        self.wk.snp.makeConstraints { (make) in
            make.bottom.equalTo(bview.snp.top)
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview().offset(20)
            }
        }
        let homeBtn = UIButton(type: .system)
        homeBtn.tag = 0
        homeBtn.frame = CGRect(x: 0, y: 0, width: w / 4, height: bh)
        homeBtn.titleLabel?.font = UIFont.init(name: "ionicons", size: 28)
        homeBtn.setImage(UIImage(named: "ic_home"), for: .normal)
        homeBtn.addTarget(self, action: #selector(self.bfun), for: .touchUpInside)
        bview.addSubview(homeBtn)
        
        let backBtn = UIButton(type: .system)
        backBtn.tag = 1
        backBtn.frame = CGRect(x: w / 4, y: 0, width: w / 4, height: bh)
        backBtn.titleLabel?.font = UIFont.init(name: "ionicons", size: 28)
        backBtn.setImage(UIImage(named: "ic_left"), for: .normal)
        backBtn.addTarget(self, action: #selector(self.bfun), for: .touchUpInside)
        bview.addSubview(backBtn)
        
        let prevBtn = UIButton(type: .system)
        prevBtn.tag = 2
        prevBtn.frame = CGRect(x: w / 4 * 2, y: 0, width: w / 4, height: bh)
        prevBtn.titleLabel?.font = UIFont.init(name: "ionicons", size: 28)
        prevBtn.setImage(UIImage(named: "ic_right"), for: .normal)
        prevBtn.addTarget(self, action: #selector(self.bfun), for: .touchUpInside)
        bview.addSubview(prevBtn)
        
        let reloadBtn = UIButton(type: .system)
        reloadBtn.tag = 3
        reloadBtn.frame = CGRect(x: w / 4 * 3, y: 0, width: w / 4, height: bh)
        reloadBtn.titleLabel?.font = UIFont.init(name: "ionicons", size: 28)
        reloadBtn.setImage(UIImage(named: "reload"), for: .normal)
        reloadBtn.addTarget(self, action: #selector(self.bfun), for: .touchUpInside)
        bview.addSubview(reloadBtn)
        
    }
    @objc func closePanel(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func bfun(button: UIButton){
        if(button.tag == 0){
            let url = URL(string: self.appleStoreUrl)
            self.wk.load(URLRequest(url: url!))
        }else if(button.tag == 1){
            self.wk.evaluateJavaScript("history.go(-1);", completionHandler: nil)
        }else if(button.tag == 2){
            self.wk.evaluateJavaScript("history.go(1);", completionHandler: nil)
        }else if(button.tag == 3){
            self.wk.evaluateJavaScript("window.location.reload();", completionHandler: nil)
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
        wk.load(URLRequest(url: url))
        closeReloadView()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(self.wk.estimatedProgress), animated: true)
            if self.wk.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.wk.stopLoading()
        self.showReloadView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.wk.stopLoading()
        self.showReloadView()
    }
}
