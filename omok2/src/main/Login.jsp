<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
@charset "UTF-8";

body {
    font-family: Arial, sans-serif; 
    background-color: #f0f7fc; 
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh; /* 뷰포트 높이 전체를 사용 */
    margin: 0;
}

table {
    background: white; /* 테이블 배경색 */
    padding: 20px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1); /* 그림자 효과 */
    border-radius: 8px; /* 테두리 둥글게 */
    width: 360px; /* 테이블 너비 */
}

th {
    font-size: 24px; /* 제목 크기 */
    padding-bottom: 10px; /* 제목 아래 여백 */
    text-align: center; /* 텍스트 중앙 정렬 */
    colspan: 2; /* 제목이 차지할 열의 수 */
}

td {
    padding: 10px; /* 셀 패딩 */
    text-align: center; /* 텍스트 중앙 정렬 */
}

input[type=text], input[type=password] {
    width: calc(100% - 20px); /* 입력 필드 너비 */
    padding: 8px 10px; /* 입력 필드 내부 여백 */
    margin: 5px 0; /* 입력 필드 외부 여백 */
    display: inline-block;
    border: 1px solid #ccc; /* 테두리 색상 */
    border-radius: 4px; /* 테두리 둥글게 */
    box-sizing: border-box; /* 박스 사이징 */
}

input[type=button] {
    background-color: #007bff; /* 기본 배경색 설정: 파란색 */
    color: white;
    padding: 10px 20px;
    margin: 8px 2px; /* 버튼 사이의 간격 조정 */
    border: none;
    border-radius: 4px;
    cursor: pointer; /* 마우스 포인터 */
    width: 100%; /* 버튼 너비 조정 */
    box-sizing: border-box; 
}

input[type=button]:hover {
    background-color: #0056b3; /* 호버 시 배경색 설정: 보다 어두운 파란색 */
}

.button-group {
    margin-top: 10px; /* 버튼 그룹 상단 여백 */
    display: flex; /* 플렉스박스 레이아웃 */
    flex-direction: column; /* 버튼 세로 정렬 */
}

.full-width {
    width: 100%; 
}

</style>
<script>
	function fn_login() {
		var frmLogin = document.frmLogin;
		var id = frmLogin.id.value;
		var pwd = frmLogin.pwd.value;
		
		if(id.length == 0 || id == "") {
			alert("아이디를 입력해주세요.");
		} else if(pwd.length == 0 || pwd == "") {
			alert("비밀번호를 입력해주세요.");
		} else {
			frmLogin.method = "post";
			frmLogin.action = "omoklogin";
			frmLogin.submit();
		}
	}
</script>
</head>   
<body>
	<form name="frmLogin">
		<table>
			<th>로그인</th>
			<tr>
				<td>아이디</td>
				<td><input type="text" name="id"></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pwd"></td>
			</tr>
		</table>
		<input type="button" value="로그인" onclick="fn_login()">
		<input type="button" value="아이디 / 비밀번호 찾기" onclick="location.href='/omok2/Find.jsp'">
		<br>
		<input type="button" value="회원가입" name = "join"  onclick="location.href='/omok2/Join.jsp'">
		<input type="hidden" name="command" value = "login">
	</form>
</body>
</html>
