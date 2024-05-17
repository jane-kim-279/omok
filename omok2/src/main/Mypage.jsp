<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> My Page </title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    align-items: center;
	    height: 100vh;
	    background-color: #f0f0f0;
	    text-align: center;
	    justify-content: center;
    	align-items: center;
	    margin: 0;
	    padding: 0;
	    
	}
	
	h1 {
	    margin-top: 30px;
	}
	
	.container {
	    width: 80%;
	    max-width: 350px;
	    margin: 50px auto;
	    padding: 20px;
	    background-color: #fff;
	    border-radius: 5px;
	    box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.1);
	    display: flex; 
	    flex-direction: column; 
	    align-items: center;
	}
	
	.info-section {
		width: 100%; 
		margin: 5px 0; 
		padding: 10px 0; 
		border-bottom: 1px solid #ddd; 
		text-align: center;
	}
	
	.info-section:last-child{
		border-bottom: none;
	}
	
	
	input[type="text"], input[type="password"], input[type="button"], input[type="submit"], input[type="reset"] {
	    width: 60%;
	    padding: 10px;
	    margin-bottom: 15px;
	    border: 1px solid #ccc;
	    border-radius: 3px;
	    box-sizing: border-box;
	    text-align: center;
	}
	
	.button-container{
		display: flex; 
		flex-direction: column;
		align-items: center; 
		width: 100%; 
	
	}
	
	
	input[type="button"], input[type="submit"], input[type="reset"] {
	    width: 60%;
	    padding: 10px;
	    margin-bottom: 15px;
	    background-color: #298BFE;
	    color: white;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	    transition: background-color 0.3s;
	    text-align: center;
	}
	
	input[type="button"]:hover, input[type="submit"]:hover, input[type="reset"]:hover {
	    background-color: #0056b3;
	    
	}
	
	details > table {
	        margin-top: 20px;
	        width: 100%;
	        text-align: center;
	        border: 1px solid #ccc;
	    }
	
	    table {
	        width: 100%;
	        border-collapse: collapse;
	        margin-top: 20px;
	    }
	
	    th {
	        border: 1px solid #ccc;
	        
	    }
	    

</style>
<script>
	function fn_update() {
		var frmMember = document.frmMember;
		var id = frmMember.id.value;
		var pwd = frmMember.pwd.value;
		var name = frmMember.name.value;
		var tel = frmMember.tel.value;
		
		if(pwd.length == 0 || id == "") {
			alert("수정 사항을 공백으로 둘 수 없습니다.");
		} else if(tel.length == 0 || tel == "") {
			alert("수정 사항을 공백으로 둘 수 없습니다.");
		} else {
			frmMember.method = "post";
			frmMember.action = "Edit.do";
			frmMember.submit();
			System.out.print(id, pwd, name, tel);
		}
	}
	const detailsElement = document.getElementById("resultDetails");

	detailsElement.addEventListener("toggle", function() {
	    if (detailsElement.open) {
	      console.log("내용이 열림");
	      
	    } else {
	      console.log("내용이 닫힘");

	    }
	  });
	
</script>
</head>
<body>
	<form name = "frmMember" method = "post"> 
		<table>
			<tr>
				<td colspan="2"> My Page</td>
			</tr>
			<tr>
				<td> ID </td>
				<td><input type="text" name="id" value="${memberList[0].userid }" readonly="readonly"></td>
			</tr>
			<tr>
				<td> PASSWORD </td>
				<td><input type="password" name="pwd" value="${memberList[0].userpwd }"></td>
			</tr>
			<tr>
				<td> NICK NAME</td>
				<td><input type="text" name="name" value="${memberList[0].username }"></td>
			</tr>
			<tr>
				<td>PHONE</td>
				<td><input type="text" name="tel" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="${memberList[0].usertel }"></td>
			</tr>
			<tr align="center">
				<td colspan='2'><input type="submit" value=" 수정 " onClick = "fn_update()" > </td>
			</tr>
			<tr align="center"> 
				<td colspan='2'> <input type="reset" value=" 취소하기 "></td>
			</tr>
			<tr align="center">
				<td colspan='2'><input type="button" value="메인으로 돌아가기" onClick = 'location.href = "/omok2/Main.jsp"'> </td>
			</tr>
			<tr align="center">
				<td colspan='2'><input type="button" value="로그아웃" onClick = 'location.href = "/omok2/Mypage/logout.do"'></td>
			</tr>
		</table>
	</form>
	<form>
		<details id="resultDetails">
        <summary> 게임 기록 상세보기 </summary>
        <table>
        	<tr align = "center">
        		<td> <b> NO </b> </td>
				<td> <b> 이긴 날짜 </b> </td>
			</tr>
	        <c:if test = "${empty gameList }">
				<tr> 
					<td colspan = 4>게임 진행 내역이 없습니다, <br> 즐거운 게임을 시작해 보세요. </td>
				</tr>
			</c:if>
			<c:forEach var = "game" items = "${gameList }" varStatus = "status">
			 	<tr align = "center"> 
			 		<td> ${status.index+1 } </td>
			 		<td> ${game.gamedate }</td>
			 	</tr>
			 </c:forEach>
		</table>
    </details>
	</form>
</body>
</html>