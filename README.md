# RainTalk
### Howlab의 유튜브 강의(http://bit.ly/2WyKGxc)를 따라하는 프로젝트
### Firebase & Swift 5를 사용한 채팅 앱 만들기
---
# #1 [Splash 만들기]
> 링크: https://youtu.be/hTWGiPU-SoU
1. XCode 프로그램 오픈 후 "iOS" 탭의 [Single View Application] 선택 후 프로젝트 생성
2. Constraints를 사용할 수 있으나 사용 시 복잡한 레이아웃 설정 시 어려움이 있음.<br>따라서, `SnapKit`이라는 라이브러리 사용(https://github.com/SnapKit/SnapKit)
3. 서버에 환경변수 지정을 위해 `Google Firebase` 내 기능인 **Remote Config** 사용
4. 프로젝트 폴더 내 `Podfile`에 아래 코드 입력(해당 코드는 target ... do 코드 전에 입력)<br>
```bash
# Add Library
pod 'SnapKit', '~> 5.0.0'

# Add Firebase Library
pod 'Firebase/Analytics'
pod 'Firebase/RemoteConfig'
```
