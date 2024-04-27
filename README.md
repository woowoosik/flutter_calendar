# schedule_calendar



## 메인 페이지 

|<img src="https://github.com/woowoosik/test/assets/49232649/71c8fa02-aa66-4cbe-8723-8db67750be73" width="200" height="400"/>|<img src="https://github.com/woowoosik/test/assets/49232649/5aea508d-78ff-4c13-91d8-3e5590541e44" width="200" height="400"/>|
|------|---|
|메인 달력 이동|1주, 2주, 월별|

`tableCalendar` 라이브러리를 사용하여 달력 구현

라이브러리에 `calendarFormat`을 이용하여 1주, 2주, 월간 기능을 사용하였습니다.

2주, 월간은 하단에 `ListView`로 일정을 구현

1주는 `paint`를 사용하여 막대형태로 구현하였습니다. 

`touchable` 라이브러리를 이용하여 터치이벤트를 구현하였습니다.




## CRUD (google map, kakao 키워드, fcm)

#### Firebase

<img src="https://github.com/woowoosik/test/assets/49232649/093bcb11-e4df-40f8-a135-76edad1db61c" width="400" height="150"/>

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


|<img src="https://github.com/woowoosik/test/assets/49232649/8d169e94-c904-42c0-baba-950d22cc8059" width="200" height="400"/>|
|---|
|키워드 검색으로 위치 및 일정 추가|

일정의 날짜와 시간은 `TimePicker`, `DatePicker`를 사용하였습니다.

`kakao API`의 키워드 검색 오픈API를 사용하여 원하는 장소를 검색하여 경도와 위도 그리고 검색한 장소의 이름 및 주소를 구하고

좌표를 시각화 해줄 것으로는 `google map API`을 사용하여 구현하였습니다.




#### 일정수정 및 삭제

|<img src="https://github.com/woowoosik/test/assets/49232649/e16c34f6-b25c-4c78-b06b-72fc9be3a4af" width="200" height="400"/>|
|---|
|일정 수정 및 삭제하기|

수정을 구현하여 데이터를 변경할 수 있게 구현하였고 삭제는 `Dismissible`위젯을 사용하여 당겨서 삭제하게 구현을 하였습니다.


#### FCM
|<img src="https://github.com/woowoosik/test/assets/49232649/380337b4-0c17-4aee-a745-53cb7bfd9471" width="200" height="400"/>|
|---|
|FCM으로 보내고 받기|

푸시알림을 구현하고자 `FireBase`의 `FCM`을 사용하였습니다. 

알림을 받고자 하는 날짜와 시간을 입력받는 것은 `DatePicker`와 `TimePicker`을 사용하여 받고

서버로 보낸 뒤 받고 입력한 시간에 알림을 보여줍니다. 

현재 `FCM`은 `ANDROID`만 가능하고 `IOS`의 경우 `FCM`의 기능을 제거하였습니다.




## 로그인, 로그아웃, 가입, 탈퇴
|<img src="https://github.com/woowoosik/test/assets/49232649/2878d764-7ec0-4cc7-9f7f-8292fa25fa3c" width="200" height="400"/>|
|---|
|가입하고 탈퇴하기|

로그인은 `Firebase Authentication`을 사용하였습니다. 

탈퇴 시에는 확인하기 위하여 `Dialog`로 이메일과 비밀번호를 입력받아 다시 로그인을 하는 과정을 추가하였습니다. 




