//
//  ViewController.swift
//  RainTalk
//
//  Created by Jinu on 2020/01/01.
//  Copyright © 2020 Jinu. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {

    var box = UIImageView()
    var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* Firebase Remote Config */
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        // 서버와 연결이 안 될 경우 plist 내 default 값 사용
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        /* 서버에 저장되어 있는 변수 값 받는 부분 */
        // TimeInterval 내 숫자는 받는 반복 시간대
        // ex) 0이면 무한 반복, 3600이면 3600초이므로 1시간마다 fetch
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate(completionHandler: { (error) in
              // ...
            })
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
          self.displayWelcome()
        }
        
        self.view.addSubview(box)
        box.snp.makeConstraints {
            (make) in
            make.center.equalTo(self.view)
        }
        box.image = #imageLiteral(resourceName: "loading_icon")
        //self.view.backgroundColor = UIColor(hexString: "#000000")
    }
    
    func displayWelcome() {
        let color = remoteConfig["splash_background"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
    
        print(color!)
        
        if(caps) {
            let alert =  UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
                exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        self.view.backgroundColor = UIColor(hexString: color!)
    }


}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
