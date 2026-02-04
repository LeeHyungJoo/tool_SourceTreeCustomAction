#DiffFromMaster

소스트리(SourceTree)에서 특정 커밋을 선택하면,  
**Master 브랜치와 비교한 변경 사항**을 **Beyond Compare 4**를 이용해 HTML 리포트로 만들어주는 스크립트.

## 기능
- 왼쪽(Master) vs 오른쪽(내 커밋) 좌우 비교.
- 변경된 코드 내용만 깔끔하게 출력 (Context 모드).
- 한글 깨짐 방지 완벽 처리.


## 설정 방법 (Setup)

### 1. 스크립트 경로 수정
`bc_report.bat` 파일을 메모장으로 열어서, `gen_report.txt`가 있는 **실제 경로**로 수정해줘야 함.

```bat
:: 예시
set "BC_SCRIPT=D:\내스크립트위치\gen_report.txt"

```

### 2. SourceTree Custom Action 등록

소스트리 메뉴에서 `Tools` > `Options` > `Custom Actions` > `Add` 클릭 후 아래처럼 입력.

| 항목 | 입력값 | 중요 포인트 |
| --- | --- | --- |
| **Menu Caption** | `Diff Report 생성` | 아무거나 편한 이름 |
| **Script to run** | `bc_report.bat` 경로 | `...` 버튼 눌러서 선택 |
| **Parameters** | `$SHA master` | **$SHA랑 master 사이 띄어쓰기 필수** |
| **Show Full Output** | `Check (V)` | **무조건 체크해야 함** |

---

## 사용법

1. SourceTree **Log/History** 탭으로 이동.
2. 비교하고 싶은(작업한) 커밋에 대고 **마우스 우클릭**.
3. `Custom Actions` > `Diff Report 생성` 클릭.
4. 검은 창 뜨고 잠시 기다리면 끝.
5. **바탕화면**에 생긴 `DiffReport_날짜` 폴더 안의 **`index.html`** 실행.

## 팁

* 리포트에서 소스 코드가 너무 길면 자동으로 줄바꿈 처리됨.
* 변경된 부분 위주로 보여주니까 스크롤 압박 없이 리뷰 가능.
