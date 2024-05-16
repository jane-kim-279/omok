<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 아이디/ 비밀번호 찾기 </title>
<style>
@charset "UTF-8";

body {
    font-family: Arial, sans-serif; 
    background-color: #f0f7fc; 
    display: flex; 
    justify-content: center; 
    align-items: center; 
    height: 100vh; 
    margin: 0; 
}

table {
    background: white; 
    padding: 20px; 
    box-shadow: 0 0 10px rgba(0,0,0,0.1); 
    border-radius: 8px; 
    width: 400px; 
}

th {
    font-size: 24px; 
    padding-bottom: 10px; 
    text-align: center; 
}

td {
    padding: 10px; 
    text-align: center; 
}

input[type=text] {
    width: calc(100% - 20px); 
    padding: 8px 10px; 
    margin: 5px 0; 
    display: inline-block; 
    border: 1px solid #ccc; 
    border-radius: 4px; 
    box-sizing: border-box; 
}

input[type=radio] {
    width: 1rem; 
    height: 1rem; 
    margin-right: 5px; 
    border-radius: 50%; 
    border: 1.5px solid #999; 
    appearance: none; 
    cursor: pointer; 
    position: relative; 
}

input[type=radio]:checked {
    background-color: #007bff; /* 라디오 버튼 체크 색상을 파란색(#007bff)으로 설정 */
    border: none;
}

input[type=radio]:checked::after {
    content: '✓';
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white; /* 체크 표시 색상을 흰색으로 설정 */
    font-size: 0.7rem;
}

label {
    display: inline;
    margin-left: 4px;
}

input[type=button] {
    background-color: #007bff; 
    color: white; 
    padding: 10px 20px; 
    margin: 8px 0; 
    border: none; 
    border-radius: 4px; 
    cursor: pointer; 
    width: 100%; 
}

input[type=button]:hover {
    background-color: #0056b3; 
}
</style>
<script>
	function fn_find() {
		let frmFind = document.frmFind;
        let name = frmFind.name.value;
        let tel = frmFind.tel.value;
        let idpw = frmFind.finder.value;


        if (name.length === 0 || name === "") {
            alert("닉네임을 입력하세요.");
        } else if (tel.length === 0 || tel === "") {
            alert("전화번호를 입력하세요.");
        } else {
            if (idpw == 1) {
                frmFind.command.value = "findId";
            } else {
                frmFind.command.value = "findPwd";
            }
            frmFind.method = "post";
            frmFind.action = "omokfind";
            frmFind.submit();
        }
    }
</script>
</head>
<body>
	<form name="frmFind">
		<table>
			<th colspan= '2'> 아이디 / 비밀번호 찾기 </th>
			<tr>
				<td colspan = '2'> 찾으려는 항목을 선택해주세요. </td>
			</tr>
			<tr>
				<td><input type = "radio" name="finder" value="1" id="f1" checked> <label for="f1"> 아이디 </label> </td>
                <td><input type = "radio" name="finder" value="2" id="f2" > <label for="f2"> 비밀번호 </label> </td>
			<tr>
				<td> 닉네임 </td>
				<td> <input type = "text" name = "name"> </td>
			</tr>
			<tr>
				<td> 전화번호 </td>
				<td> <input type = "text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name = "tel"> </td>
			</tr>
			</tr>

		</table>
		<input type="button" value="찾기" onclick="fn_find()">
		<input type="button" value="로그인" onclick="location.href='/omok2/Login.jsp'">
		<input type="button" value="회원가입" name = "join"  onclick="location.href='/omok2/Join.jsp'">
		<input type="hidden" name="command" value = "findId" />
	</form>
</body>
</html>