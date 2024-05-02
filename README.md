# schedule_calendar



## 메인 페이지 

|<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/da59a8dd-f283-464c-bb5b-c7e50cd40a39" width="200" height="400"/>|<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/398ff24d-88ab-423f-91cb-d5244adc9e51" width="200" height="400"/>|
|------|---|
|메인 달력 이동|1주, 2주, 월별|

`tableCalendar` 라이브러리를 사용하여 달력 구현

라이브러리에 `calendarFormat`을 이용하여 1주, 2주, 월간 기능을 사용하였습니다.

2주, 월간은 하단에 `ListView`로 일정을 구현

1주는 `paint`를 사용하여 막대형태로 구현하였습니다. 

`touchable` 라이브러리를 이용하여 터치이벤트를 구현하였습니다.


## CRUD (google map, kakao 키워드, fcm)

#### Firebase

<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/7bc69142-ea05-42f3-8eef-47408d4e56de" width="400" height="150"/>

데이터베이스로는 파이어베이스를 사용하였습니다.


```
- alarm
    ㄴ alarmData
      ㄴ id 
      ㄴ alarmDate
      ㄴ alarmTime
    ㄴ isChecked
- content
- date
- endTime
- GoogleMapCheck
  ㄴ GoogleMapData
    ㄴ formated_address
    ㄴ lat
    ㄴ lng
    ㄴ name
  ㄴ isChecked
- id
- startTime
```



#### 일정추가 및 google map, kakao 키워드 검색


|<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/5525d6d0-c1b1-4d74-b2cd-d61cc17abbfd" width="200" height="400"/>|
|---|
|키워드 검색으로 위치 및 일정 추가|

일정의 날짜와 시간은 `TimePicker`, `DatePicker`를 사용하였습니다.

`kakao API`의 키워드 검색 오픈API를 사용하여 원하는 장소를 검색하여 경도와 위도 그리고 검색한 장소의 이름 및 주소를 구하고

좌표를 시각화 해줄 것으로는 `google map API`을 사용하여 구현하였습니다.




#### 일정수정 및 삭제


|<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/6735da58-1c67-4df0-b2a2-75b82aa51656" width="200" height="400"/>|
|---|
|일정 수정 및 삭제하기|

수정을 구현하여 데이터를 변경할 수 있게 구현하였고 삭제는 `Dismissible`위젯을 사용하여 당겨서 삭제하게 구현을 하였습니다.


#### FCM

|<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/bd81d16c-0f45-4187-be64-605952c6c140" width="200" height="400"/>|
|---|
|FCM으로 보내고 받기|

푸시알림을 구현하고자 `FireBase`의 `FCM`을 사용하였습니다. 

알림을 받고자 하는 날짜와 시간을 입력받는 것은 `DatePicker`와 `TimePicker`을 사용하여 받고

서버로 보낸 뒤 받고 입력한 시간에 알림을 보여줍니다. 

현재 `FCM`은 `ANDROID`만 가능하고 `IOS`의 경우 `FCM`의 기능을 숨겨놓았습니다.




## 로그인, 로그아웃, 가입, 탈퇴
|<img src="https://github.com/woowoosik/flutter_calendar/assets/49232649/11b0a7af-8a94-4d97-a03c-df2e78c8a5b4" width="200" height="400"/>|
|---|
|가입하고 탈퇴하기|

가입은 `Firebase Authentication`을 사용하였습니다. 

탈퇴 시에는 확인하기 위하여 `Dialog`로 이메일과 비밀번호를 입력받아 다시 로그인을 하는 과정을 추가하였습니다. 




