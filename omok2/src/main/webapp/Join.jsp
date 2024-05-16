<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입창 </title>
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

input[type=text], input[type=password] {
    width: calc(100% - 20px);
    padding: 8px 10px;
    margin: 5px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

input[type=button], input[type=reset] {
    background-color: #007bff;
    color: white;
    padding: 10px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    width: 100%;
    box-sizing: border-box;
}

input[type=button]:hover, input[type=reset]:hover {
    background-color: #0056b3;
}

.button-group {
    margin-top: 10px;
    display: flex;
    flex-direction: column;
}
</style>
<script>
	function fn_sendMember() {
		var frmMember = document.frmMember;
		var id = frmMember.id.value;
		var pwd = frmMember.pwd.value;
		var pwd2 = frmMember.pwd2.value;
		var name = frmMember.name.value;
		var tel = frmMember.tel.value;
		
		if(id.length == 0 || id == "") {
			alert ("아이디는 필수입니다."); 
		} else if (pwd.length == 0 || pwd == "") {
			alert ("비밀번호는 필수입니다."); 
		} else if (pwd != pwd2){
			alert ("비밀번호와 확인이 동일하지 않습니다."); 
		} else if (name.length == 0 || name == "") {
			alert ("닉네임은 필수입니다."); 
		} else if (tel.length == 0 || tel == "") {
			alert ("이메일은 필수입니다."); 
		} else {
			frmMember.method = "post";
			frmMember.action = "omokjoin";
			frmMember.submit();
		}
		
	}
</script>
</head>
<body>
	<form name = "frmMember">
		<table>
			<th> 회원 가입창 </th>
			<tr>
				<td> 아이디 </td>
				<td> <input type = "text" name = "id"> </td>
			</tr>
			<tr>
				<td> 비밀번호 </td>
				<td> <input type = "password" name = "pwd"> </td>
			</tr>
			<tr>
				<td> 비밀번호 확인 </td>
				<td> <input type = "password" name = "pwd2"> </td>
			</tr>
			<tr>
				<td> 닉네임 </td>
				<td> <input type = "text" name = "name"> </td>
			</tr>
			<tr>
				<td> 전화번호 </td>
				<td> <input type = "text" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" name = "tel"> </td>
			</tr>
		</table>
		<input type = "button" value = "가입하기" onclick = "fn_sendMember()">
		<input type = "reset" value = "다시입력">
		<input type = "hidden" name = "command" value = "addMember" />
	</form> 
</body>
</html>