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
6. Pod Library 추가<br>- Constraints를 사용할 수 있으나 사용 시 복잡한 레이아웃 설정 시 어려움이 있음.<br>따라서, `SnapKit`이라는 라이브러리 사용(https://github.com/SnapKit/SnapKit)<br>- 서버에 환경변수 지정을 위해 `Google Firebase` 내 기능인 **Remote Config** 사용<br>- 프로젝트 폴더 내 `Podfile`에 아래 코드 입력(해당 코드는 target ... do 코드 전에 입력)<br>
```bash
# Add Library
pod 'SnapKit', '~> 5.0.0'

# Add Firebase Library
pod 'Firebase/Analytics'
pod 'Firebase/RemoteConfig'
```
6. Terminal 창에 `pod install` 입력 후 Enter
7. **pod library** 설치 완료 후 프로젝트 폴더 내 `RainTalk.xcworkspace` 파일 Open
