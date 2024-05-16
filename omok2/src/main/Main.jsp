<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>오목 게임 시작화면</title>
	<style>
	  body {
	    font-family: Arial, sans-serif; 
	    background-color: #f0f7fc; 
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    height: 100vh; 
	    margin: 0;
	}
	
	.container {
	    background: white; 
	    padding: 20px;
	    box-shadow: 0 0 10px rgba(0,0,0,0.1); 
	    border-radius: 8px; 
	    width: 360px; 
	    text-align: center; 
	}
	
	h1 {
	    color: #333;
	    margin-bottom: 20px; 
	}
	
	button {
	    background-color: #007bff; 
	    color: white;
	    padding: 10px 20px;
	    margin: 8px 2px; 
	    border: none;
	    border-radius: 4px;
	    cursor: pointer; 
	    width: 100%; /* 버튼 너비 조정 */
	    box-sizing: border-box; /* 박스 사이징 */
	}
	
	button:hover {
	    background-color: #0056b3; 
	}
	
	a {
	    text-decoration: none; /* 링크 밑줄 제거 */
	    color: white; /* 링크 텍스트 색상 */
	}
	   
	  </style>
</head>
<body>
 <div class="container">
    <h1>오목게임</h1>
    <button class="login-btn" onclick="startLogin()">로그인/회원가입</button>
    <button class="creatroom" onclick="goToCreatRoom()">방 들어가기</button>      
    <button class="myroom" onclick="goToMyPage()">마이페이지</button>
  </div>

  <script>
	function startLogin() {
	  	// 로그인 / 회원가입 페이지로 이동 
	  	window.location.href = "Login.jsp"; // 로그인/회원가입 jsp 파일 경로 
	}
    function goToCreatRoom() { 
    	//방 생성 페이지로 이동 
    	window.location.href = "index.jsp"; // 방 생성 jsp 파일 경로 
    }
    function goToMyPage(){
    	//마이페이지로 이동 
    	window.location.href = "Mypage/viewPage.jsp"; // 마이페이지 jsp 파일 경로 
    }
    
	function checkLoginStatus() {
	      if (document.cookie.indexOf("user") >= 0) {
	         
	    	  // 로그인 쿠키가 존재하면 로그인/회원가입 버튼을 숨김
	          document.querySelector('.login-btn').style.display = 'none'; 
	    	  
	      }  else if (document.cookie.indexOf("user") < 0) {
	         
	    	  // 로그인 쿠키가 존재하지 않으면, 나머지
	          document.querySelector('.creatroom').style.display = 'none';  
	          document.querySelector('.myroom').style.display = 'none'; 
	      }
	}
	  
	// 페이지 로드 시 로그인 상태 확인
	window.onload = function() {
	      checkLoginStatus();
	}
	  
	  
  </script>
</body>
</html>