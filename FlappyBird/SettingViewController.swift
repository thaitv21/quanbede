//
//  SettingViewController.swift
//  FlappyBird
//
//  Created by Quan Nguyen Dinh on 11/13/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var musicSlider: UISlider!
    @IBOutlet var soundSlider: UISlider!
    var initValue: Float = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        musicSlider.setThumbImage(UIImage(named: "Crate"), for: .normal)
        soundSlider.setThumbImage(UIImage(named: "Crate"), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.soundSlider.value = AudioClass.shared.player?.volume ?? 0.0
        self.initValue = soundSlider.value
    }
    

    @IBAction func OkAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        AudioClass.shared.changeVolume(value: self.initValue)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func soundAction(_ sender: Any) {
        AudioClass.shared.changeVolume(value: Float(soundSlider.value))
    }
    
    @IBAction func musicAction(_ sender: Any) {
        
    }
    
}
