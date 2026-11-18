# 청년 정책 맞춤 추천 (해커톤 MVP, 2시간)

## 목적
20~30대가 나이·지역·소득·취업상태·주거형태를 입력하면
받을 수 있는 청년 정책과 그 이유를 보여준다.

## 범위 (이것만 만든다)
- 입력 폼 1개 → 결과 카드 목록
- 정책 데이터: /frontend/policies.json (DB 없음)
- 조건 매칭: 프론트엔드 JS 규칙 기반
- 설명 생성: Lambda 1개 → Amazon Bedrock
- 로그인, DB, 알림 기능 없음 (알림 버튼은 토스트만)

## 파일 담당
- /frontend/index.html : 프론트 (HTML+CSS+JS 한 파일)
- /frontend/policies.json : 정책 데이터
- /lambda/handler.py : Lambda (Python 3.12)

## 데이터 형식 (policies.json, 배열)
{ "id": "p1", "name": "", "minAge": 19, "maxAge": 34,
  "regions": ["전국"], "maxIncome": null,
  "employment": ["재직","구직","학생"], "housing": ["월세"],
  "benefit": "", "deadline": "2026-12-31", "url": "" }
- regions에 "전국"이 있으면 모든 지역 해당
- maxIncome 단위는 만원, null이면 소득 조건 없음

## API
POST {Lambda 함수 URL}
요청: { "user": { "age": 27, "region": "서울", "income": 3000,
                  "employment": "재직", "housing": "월세" },
        "policies": [매칭된 정책 객체 배열] }
응답: { "results": [ { "id": "p1", "reason": "한두 문장 설명" } ] }
- 실패 시 results는 빈 배열 → 프론트는 기본 문구 표시

## 규칙
- 코드는 단순하게, 외부 라이브러리 최소화
- 한국어 UI, 모바일 화면 우선
- 자기 담당 파일만 수정한다
