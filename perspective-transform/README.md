# Perspective Transform Viewer
<div>
<img src="https://user-images.githubusercontent.com/55565351/132447803-0f8d8b49-7d84-4b45-8eab-edb8fbc69343.gif" width="600" height="400"/>
<img src="https://user-images.githubusercontent.com/55565351/132447814-a65697d0-102e-404f-98b4-b27771aca162.gif" width="600" height="400"/>
</div>

## 프로젝트 개요
* 투시 변환 뷰어

## 빌드 방법
### Qt Creator 사용
* Windows
  1. image-video-viewer.pro 수정
  2. For OpenCV in Windows 주석 해제
  3. OpenCV 경로 설정
  4. Run
* Ubuntu
  1. image-video-viewer.pro 수정
  2. For OpenCV in Ubuntu 주석 해제
  3. OpenCV 경로 설정
  4. Run

## 사용 방법
* 첫 화면에서 Type 01, Type 02 중에 하나 클릭
* 투시 변환할 이미지 파일 선택해서 파일 열기
* Type 01
  1. SRC 포인트(X, Y)를 이미지의 width, height 비율로 지정한다
  2. 'Show Points' 버튼을 누르면 위치를 볼 수 있다
  3. DST width, height를 설정한다
  4. 'Show Result' 버튼을 누르면 투시 변환 결과를 볼 수 있다
  5. 'Back' 버튼을 누르면 다시 뒤로 간다
  6. SRC 값 변경 후 'Show Points' 버튼을 눌러서 업데이트를 하고 다시 'Show Result' 버튼을 누르면 결과를 볼 수 있다
* Type 02
  1. 'Set SRC 4 Points' 버튼을 눌러서 사진 위에 4개의 포인트를 마우스로 클릭해 찍는다
  2. DST width, height를 설정한다
  3. 'Show Result' 버튼을 누르면 투시 변환 결과를 볼 수 있다
  4. 'Back' 버튼을 누르면 다시 뒤로 간다
  5. SRC 포인트에 마우스를 대고 1초 정도 누르고 있으면 포인트를 옮길 수 있다 (옮길 때도 마우스를 누르고 있어야 한다)
  6. SRC 값 변경 후 다시 'Show Result' 버튼을 누르면 결과를 볼 수 있다

## 단축키
키 | 설명
--------- | --------
Backspace | 첫 화면으로 가기
Delete | SRC Points 삭제 및 리셋
