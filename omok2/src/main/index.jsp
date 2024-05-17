<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>오목 게임</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f7fc; /* 파란색 배경 */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        #container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: row; /* 가로로 배치 */
            align-items: flex-start; /* 위에 정렬 */
            width: 80%; /* 화면의 80%를 차지 */
        }
        #omokContainer {
            margin-right: 20px; /* 오른쪽 여백 */
            margin-left: 20px; /* 왼쪽 여백 */
            flex-grow: 2; /* 2배 크기 */
        }
        #chatContainer {
            margin-right: 20px; /* 오른쪽 여백 */
            align-self: flex-start; /* 위에 정렬 */
            width: 40%; /* 채팅 컨테이너 너비 */
        }
        input[type="text"], input[type="button"] {
            padding: 10px;
            margin: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: calc(100% - 20px); /* 조정 */
        }
        textarea {
            padding: 10px;
            margin: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: calc(100% - 20px);
            height: 150px; /* 작은 창으로 설정 */
            resize: none;
        }
        table {
            border-collapse: collapse;
            margin: 20px auto;
        }
        td {
            border: 1px solid black;
            width: 40px;
            height: 40px;
            text-align: center;
            transition: background-color 0.3s;
            cursor: pointer;
        }
        td:hover {
            background-color: lightgray;
        }
        .info {
            margin-top: 20px;
            text-align: center;
        }
        .black {
            background-color: black;
            color: white;
        }
        .white {
            background-color: white;
            color: black;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

	<h3 id="stones" align="center"></h3>
	<div id="game">
		<canvas id="gameboard" width="750" height="750"></canvas>
    	<p id="status">No Connection<p/> <p id="more-client"></p>
	</div>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script type="text/javascript">
	var usr = 1; // means black color
	var chance = true;
	
	// inintalize whole board
	var gameboard = [];
	
	for (var i=0; i<19; i++) {
		gameboard[i] = [];
		for (var j=0; j<19; j++) {
			gameboard[i][j] = 0;
		}
	}
	window.onload = function() {
		var canvas = document.getElementById("gameboard");
		var context = canvas.getContext('2d');
		var connection = new WebSocket("ws://localhost:8090/omok2/socket");
		
		connection.onopen = function() {
			var jsonStr = {type: "ClientConnect"};
			connection.send(JSON.stringify(jsonStr));
	    	init_area();
	    	document.getElementById("status").innerHTML = "Black Stones. You play first.";
	        document.getElementById("stones").innerHTML = "BLACK";
	    };
	    
	    connection.onerror = function (error) {
	        console.log('WebSocket Error ' + error);
	    };
	    
	    connection.onmessage = function(message) {
	    	try {
	    		console.log(message.data);
	            var json = JSON.parse(message.data);
	            console.log("json: ", json);
			} catch (e) {
	            return;
	        }
	        
			if(json.type == 'gameboard-index') {
				var i = json.data1;
				var j = json.data2;
				var color = json.color;
				gameboard[i][j] = json.color;
				drawnodes(i, j, color);
				if(json.color != usr) {
					chance = true;
					document.getElementById("status").innerHTML = "Your turn.";
				}
			} else {
				if(json.type == 'second-client') {
					console.log("second-client 반응");
					document.getElementById("status").innerHTML = "White Stones. You play second.";
	        		document.getElementById("stones").innerHTML = "WHITE";
	        		usr = -usr;
	        		chance = false;
				} else {
					if(json.type == 'winner') {
						document.getElementById("status").style.color = "#C2185B";
	        			var i = json.data1;
						var j = json.data2;
						var color = json.color;
						gameboard[i][j] = json.color;
						drawnodes(i, j, color);
	        			if(json.color == 1) {
	        				document.getElementById("status").innerHTML = "Black stones player wins";
	        				if(usr == 1){
	        					setTimeout(function(){alert("Black stones player wins"); window.location.href = 'Game/result.do';}, 3000);
	        				} else {
	        					setTimeout(function(){alert("Black stones player wins"); window.location.href = 'Main.jsp';}, 3000);
	        				}
	        			}
	        			else {
	        				document.getElementById("status").innerHTML = "White stones player wins";
	        				if(usr != 1){
	        					setTimeout(function(){alert("White stones player wins"); window.location.href = 'Game/result.do';}, 3000);
	        				} else {
	        					setTimeout(function(){alert("White stones player wins"); window.location.href = 'Main.jsp';}, 3000);
	        				}
	        			}
	        			disableScreen();
	        			
					}
					else {
						if(json.type == 'history') {
							console.log("history 실행");
							for (var i = 0; i < json.data.length; i++) {
			        			for (var k = 0; k < json.data[i].length; k++) {
			            			var ro = json.data[i][k].data1;
			            			var co = json.data[i][k].data2;
			            			gameboard[ro][co] = json.data[i][k].color;
									drawnodes(json.data[i][k].data1, json.data[i][k].data2, json.data[i][k].color);
								}
							}
						}
						else {
							if(json.type == 'more-clients') {
								console.log("more-clients 실행");
								document.getElementById("more-client").innerHTML = "Just Watch..";
			    				document.getElementById("status").style.color = "white";
			    				document.getElementById("stones").style.color = "white";
			    				disableScreen();
							}
							else {
								if(json.type == 'chance') {
									chance = true;
								}
								else{
									if(json.type == 'close-win') {
										if(json.color == 0) {
					        				document.getElementById("status").style.color = "#C2185B";
					        				document.getElementById("status").innerHTML = "White stones player wins";
					        				disableScreen();
					        			}
					        			if(json.color == 1) {
					        				document.getElementById("status").style.color = "#C2185B";
			    							document.getElementById("status").innerHTML = "Black stones player wins";
					        				disableScreen();
					        			}
									}
									else{
										console.log("조건문 해당 사항 없음. json: ", json);
									}
								}
							}
						}
					}
				}
			}
	    };
	    
	    function disableScreen() {
		    var div= document.createElement("div");
		    div.className += "overlay";
		    document.body.appendChild(div);
		}
	    
	    function init_area() {
			for(var i=0; i<19; i++) {
				horizontaldraw(i);
				verticaldraw(i);
				context.strokeStyle = "#6D6E70";
				context.stroke();
			}
		}

		function horizontaldraw(i) {
			context.moveTo(20 + 40 * i, 20);
			context.lineTo(20 + 40 * i, 740);
		}


		function verticaldraw(i) {
			context.moveTo(20, 20 + 40 * i);
			context.lineTo(740, 20 + 40 * i);
		}
		
		function drawnodes(i, j, user) {
			var canvas = document.getElementById('gameboard');
			var context = canvas.getContext('2d');
			context.beginPath();
			context.arc(20 + 40 * i, 20 + 40 * j, 10, 0, 2 * Math.PI);
			context.closePath();
			var gradient = context.createRadialGradient(20 + 40 * i, 20 + 40 * j, 0, 20 + 40 * i, 20 + 40 * j, 12)
			if (user == 1) {
				gradient.addColorStop(0, "#4764AE");
				gradient.addColorStop(1, "#4764AE");
			} else {
				gradient.addColorStop(0, "#11BE31");
				gradient.addColorStop(1, "#11BE31");
			}
			context.fillStyle = gradient;
			context.fill();
		}
		
		canvas.onclick = function(event) {
			if(!chance) {return;} // when chance = false then it just returns.

			var x = event.offsetX;
			var y = event.offsetY;
			
			var i = Math.floor(x / 40);
			var j = Math.floor(y / 40);
			
			console.log("i, j: ", i, ", ", j);
			if (gameboard[i][j] == 0) {
				// send it to server
				var data = { type: "gameboard-index", data1: i, data2: j, color: usr};
				connection.send(JSON.stringify(data));
				chance = false;
				document.getElementById("status").innerHTML = "Not your turn.";
			}
		};
		
		
		
		function disconnect() {
	        connection.close();
	    }
	}

</script>

</body>
</html>