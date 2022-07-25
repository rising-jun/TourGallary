# 관광명소 갤러리앱
----

## 기능
- 관광명소 사진을 보여주며, 3초에 한번씩 다음 사진으로 전환됩니다.

## 실행화면
![Simulator Screen Recording - iPhone 13 - 2022-07-25 at 16 45 37](https://user-images.githubusercontent.com/62687919/180725194-e2af760e-b357-4c51-a691-82477e578020.gif)

## 개발의도와 이에 대한 코드해석
https://github.com/rising-jun/TourGallary/issues/2, 
https://github.com/rising-jun/TourGallary/pull/5, 
https://github.com/rising-jun/TourGallary/pull/6

## 고민과 해결

- SplashViewController 메모리 해제 X
문제 : SplashViewController가 메모리에서 해제되지 않았습니다.
원인 : window.rootViewController가 SplashViewController를 참조하고 있었기에, 해제되지 않았습니다.
해결 : 메모리 그래프를 통하여 window.rootViewController의 참조를 확인하였고 해당 rootViewController를 해제해주었습니다.
https://github.com/rising-jun/TourGallary/pull/8

- SplashReactor 메모리 해제 X
문제 : SplashViewController가 메모리에서 해제되지 않았습니다.
원인 : flatMap 함수 안에서 weak를 사용하지 않고 self를 참조하여 메모리릭이 발생하였습니다.
해결 : 메모리 그래프를 통하여 SplashReactor의 flatMap에서 순환참조를 확인하였고 [unowned self]를 사용하여 해결하였습니다.
https://github.com/rising-jun/TourGallary/pull/8

## 라이브러리 선택 이유.
1. ReactorKit
- 정해진 틀의 MVVM을 사용할 수 있기에 다른 개발자가 읽었을 때, 로직에 대한 코드를 위치 추측 가능.
- isStubenabled을 사용하여 별도의 ViewModel추상화 없이 Stub객체처럼 사용 가능. -> Testable하기에 + Reactor에 대한 추상화를 하지 않아도 되기에 설계복잡도가 낮음.

2. RxSwift
- 비동기 코드들을 보다 가독성 높게 작성 가능.
- Reactor의 Input, Output 흐름관리를 위해 사용.

3. RxDataSource 
- 새로 업데이트된 객체에 대해서만 ReloadItem해주기에 기존 RxCocoa의 collectionView.rx.items에서 RxDataSource를 사용. -> CollectionView 성능 향상 -> Main쓰레드의 부담을 덜어줌.

4. Moya
- URLSession보다 간단한 네트워크 요청 가능. 사실 간단한 API요청이라 사용할 필요가 없었지만 URLProtocol보다 간단한 MockData 테스트를 위해 사용.

