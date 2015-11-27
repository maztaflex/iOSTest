# GoogleAnalyicsDemo 

1. SDK 설치 
- Menual or CocosPods를 이용한 SDK 설치 
- 계성 생성및 기본적인 설정은 아래 링크 참조 
- https://developers.google.com/analytics/devguides/collection/ios/v3/

2. GAModel.h, GAModel.m
- (void)initGA : GA 초기화 
- (void)sendGAWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label : 이벤트 전송 
- (void)sendScreenName:(NSString *)screenName : 현재 화면 전송

3. 각 함수 적용 예제는 샘플 소스 AppDelegate.m , ViewController.m 파일 참고

4. 기본적인 이벤트 , 화면 이름 전송에 대한 예제이며, 자세한 Analytics는 사용법은 위 링크에서 참고  
