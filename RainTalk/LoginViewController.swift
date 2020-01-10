//
//  LoginViewController.swift
//  RainTalk
//
//  Created by Jinu on 2020/01/12.
//  Copyright © 2020 Jinu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    
    let rc = RemoteConfig.remoteConfig()
    var color: String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar = UIView()
        self.view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints { (m) in
            m.left.top.right.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        color = rc["splash_background"].stringValue
        //print(color)
        statusBar.backgroundColor = UIColor(hexString: color)
        loginButton.backgroundColor = UIColor(hexString: color)
        signinButton.backgroundColor = UIColor(hexString: color)
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
