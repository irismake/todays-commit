# **오늘의 커밋 (Today’s Commit)**

SwiftUI 기반으로 제작된 iOS 애플리케이션으로, 사용자의 방문 기록을 **GitHub 잔디 스타일 UI**로 시각화합니다.  
25×25 셀 기반의 커스텀 행정구역 지도 데이터를 활용하여, 사용자가 방문한 장소를 직관적이고 재미있게 기록할 수 있습니다.


&nbsp;

## **Project Overview**

오늘의 커밋은 **SwiftUI**, **Kakao Maps SDK**, **FastAPI 백엔드**와 연동되는 iOS 전용 애플리케이션입니다.  
소셜 로그인(Apple / Kakao), 방문 장소 기록, 커밋 시각화 등 다양한 기능을 제공합니다.

&nbsp;

## **Key Features**
- GitHub 잔디 스타일의 셀 기반 방문 기록 UI.
- 카카오맵 기반 장소 검색 및 기록.
- Apple / Kakao 소셜 로그인.
- FastAPI + PostgreSQL 서버 연동.
- 사용자 위치 기반 기록 및 거리 계산.

&nbsp;

## **Technologies Used**

### **Frontend**
- **Framework**: SwiftUI (with UIKit 일부 병행)
- **UI Components**:  
  - Custom Grid System (25×25)  
  - Overlay / Toast 시스템  
  - Dynamic Light & Dark Mode 지원
  - 반응형 UI 적용 (아이패드 지원)
- **State Management**: ObservableObject, EnvironmentObject 기반 커스텀 Manager 구조
  - `LocationManager`, `MapManager`, `PlaceManager`, `LayoutManager`, `GrassManager`

&nbsp;

### **Clone the Repository**
```bash
git clone https://github.com/todayscommit/todayscommit-ios.git
cd todayscommit-ios
```

&nbsp;

### **Install Dependencies**
- Swift Package Manager 자동 종속성 설치
- `.xcworkspace` 파일 열기

&nbsp;

### **Run the Project**
```bash
open TodaysCommit.xcworkspace
```
Xcode에서 **Run ▶︎ iPhone Simulator** 실행

&nbsp;

## **Project File Structure**
```bash
.
├── Assets.xcassets        # 앱 아이콘 및 색상/이미지 에셋
├── Components             # 공용 UI 컴포넌트 (Toast, Overlay 등)
├── Managers               # 상태 관리 (MapManager, PlaceManager 등)
├── Models                 # 데이터 모델 (Place, Commit, Grass 등)
├── Views                  # SwiftUI View 계층 (CommitMapView 등)
├── AppDelegate.swift
├── TodaysCommitApp.swift  # 앱 진입점
└── README.md
```

&nbsp;

## **Environment Variables**
앱은 Info.plist 및 Build Settings 기반 환경변수를 사용합니다.

- `KAKAO_APP_KEY` : Kakao SDK 인증 키  
- `ADSMOB_ID` : AdMob ID  
- `BACKEND_API_URL` : 서버 API 주소 (테스트/배포용 분리 가능)

&nbsp;

## **Branching Strategy**
- `main` : 배포용 안정화 브랜치  
- `dev` : 주요 개발 브랜치  
- `feature/*` : 기능 단위 브랜치  

&nbsp;

## **Commit Format**

### **Title**
```bash
[TYPE]: [Short description]
```

### **Types**
- `feat` : 새로운 기능 추가  
- `fix` : 버그 수정  
- `docs` : 문서 관련 수정  
- `style` : 코드 스타일 변경  
- `refactor` : 리팩토링  
- `test` : 테스트 코드 관련  
- `chore` : 유지보수 / 환경 설정  
