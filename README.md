# 관광명소 갤러리앱
----

## 기능
- 관광명소 사진을 보여주며, 3초에 한번씩 다음 사진으로 전환됩니다.

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

