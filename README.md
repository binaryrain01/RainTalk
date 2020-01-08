# RainTalk
### Howlab의 유튜브 강의(http://bit.ly/2WyKGxc)를 따라하는 프로젝트
### Firebase & Swift 5를 사용한 채팅 앱 만들기
---
# #1 [Splash 만들기]
> 링크: https://youtu.be/hTWGiPU-SoU
1. XCode 프로그램 오픈 후 "iOS" 탭의 [Single View Application] 선택 후 프로젝트 생성
2. https://firebase.google.com 접속하여 새 프로젝트 추가(프로젝트명은 **RainTalk**)
3. 생성한 프로젝트 Overview 페이지 들어간 다음 `앱 추가` 버튼 클릭하여 iOS 선택
4. 앱 등록 단계에서 **iOS 번들 ID** 부분에 프로젝트의 **Identity** 섹션의 `Bundle Identifier` 값 복사 후 입력
5. 구성 파일 다운로드 단계에서 `GoogleService-Info.plist` 파일 다운로드 후 RainTalk 프로젝트 Root에 복사
6. Pod Library 추가<br>- Constraints를 사용할 수 있으나 사용 시 복잡한 레이아웃 설정 시 어려움이 있음.<br>따라서, `SnapKit`이라는 라이브러리 사용(https://github.com/SnapKit/SnapKit)<br>- 서버에 환경변수 지정을 위해 `Google Firebase` 내 기능인 **Remote Config** 사용<br>- 프로젝트 폴더 내 `Podfile`에 아래 코드 입력(해당 코드는 target ... do 코드 전에 입력)
```bash
# Add Library
pod 'SnapKit', '~> 5.0.0'

# Add Firebase Library
pod 'Firebase/Analytics'
pod 'Firebase/RemoteConfig'
```
6. Terminal 창에 `pod install` 입력 후 Enter
7. **pod library** 설치 완료 후 프로젝트 폴더 내 `RainTalk.xcworkspace` 파일 Open
8. 온라인에서 찾은 이미지 파일을 프로젝트 내 `Assets.xcassets` 폴더에 **loading_icon**이라는 파일명으로 추가
9. `AppDelgate.swift` 파일 내 아래 코드 부분 확인 후 추가
```swift
import UIKit
import Firebase /* 추가코드 1번 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure() /* 추가코드 2번 */
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
```
10. `ViewController.swift` 파일 내 아래 코드 부분 확인 후 추가<br>- 레이아웃 설정 라이브러리인 SnapKit import<br>- view에 box 객체 선언 및 추가 후 makeConstraints 코드 사용하여 가운데 정렬<br>- App 배경화면을 RGB코드로 설정할 수 있도록 도와주는 **UIColor Extension** 코드 추가<br>- **self.view.backgroundColor = UIColor(hexString: "#000000")** 예시와 같이 hexa 코드 입력하여 배경색 설정
```swift
import UIKit
import SnapKit  /* 1. 레이아웃 설정 SnapKit 라이브러리 import */

class ViewController: UIViewController {

    var box = UIImageView() /* 2-1. App 배경화면에 사용할 ImageView 객체 선언 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* 2-2. box 객체를 self에 추가 */
        self.view.addSubview(box)
        /* 2-3. makeConstraints 사용하여 box 객체 view 내 가운데 정렬 */
        box.snp.makeConstraints {   
            (make) in
            make.center.equalTo(self.view)
        }
        box.image = #imageLiteral(resourceName: "loading_icon")
        /* 4. UIColor Extension 사용하여 background color 설정 */
        self.view.backgroundColor = UIColor(hexString: "#000000")
    }
}

/* 3. UIColor Extension 추가(Set Background Color using HEX code) */
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
```
11. **Google Firebase** 내 설정한 `Remote Config` 값 받아오도록 설정<br>- import Firebase 추가<br>- firebase 내 remote config 값 받아올 변수 선언<br>- remote config 기본 설정<br>- 서버와 연결이 안 될 경우 local에 저장되어 있는 plist 파일 내 default 값 사용하도록 설정<br>- 서버에 저장되어 있는 변수 값 fetch<br>- 서버에서 받아오거나 또는 실패하여 로컬에 저장된 변수 값에 따른 결과를 화면에 띄워주기
```swift
import UIKit
import SnapKit
import Firebase /* 1. Firebase 패키지 import */

class ViewController: UIViewController {

    var box = UIImageView()
    var remoteConfig: RemoteConfig! /* 2. Remote Config 값 받아올 변수 선언 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* 3. Firebase Remote Config 관련 기본 설정 */
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        /* 4. 서버와 연결이 안 될 경우 plist 내 default 값 사용 */
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        /* 5. 서버에 저장되어 있는 변수 값 받는 부분 */
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
    
    /* 6. fetch 성공 시 서버 값, 실패 시 local plist 파일 값 받아와서 화면 뿌려주기 */
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

```
12. `XCode Simulator` 작동하여 제대로 화면 뜨는지 확인
---
# #2 [LoginView 만들기]
