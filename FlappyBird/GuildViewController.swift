//
//  GuildViewController.swift
//  FlappyBird
//
//  Created by Quan Nguyen Dinh on 12/6/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import UIKit

class GuildViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @objc func tapImage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        self.present(controller, animated: true, completion: nil)
    }
    


}
