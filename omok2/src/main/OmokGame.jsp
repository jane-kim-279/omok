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

<div id="container">
    <!-- 오목 게임 -->
    <div id="omokContainer">
        <table>
            <!-- 테이블과 셀은 자바스크립트로 생성 -->
        </table>
        <div class="info">
            <div class="player-info"></div>
            <div class="forbidden-info"></div>
            <div class="winner-info"></div>
            <button class="btn" id="restart-btn">게임 초기화</button>
            <button class="btn" id="end-btn">게임 종료</button>
        </div>
    </div>

    <!-- 채팅 -->
    <div id="chatContainer">
        <h2>Chat</h2>
        <form>
            <input id="user" type="text" value="annonymous">
            <input id="textMessage" type="text">
            <input onclick="sendMessage()" value="Send" type="button">
            <input onclick="disconnect()" value="Disconnect" type="button">
        </form>
        <br>
        <textarea id="messageTextArea" rows="10" cols="30"></textarea>
    </div>
</div>

<script type="text/javascript">
    var webSocket = new WebSocket("ws://localhost:8090/Omok/broadsocket");

    var messageTextArea = document.getElementById("messageTextArea");

    webSocket.onopen = function(message) {
        messageTextArea.value += "Server connect \n";
    };

    webSocket.onclose = function(message) {
        messageTextArea.value += "Server disconnect \n";
    };

    webSocket.onerror = function(message) {
        messageTextArea.value += "error ! \n";
    };

    webSocket.onmessage = function(message) {
        messageTextArea.value += message.data + "\n";
    };

    function sendMessage() {
        var user = document.getElementById("user");
        var message = document.getElementById("textMessage");
        messageTextArea.value += user.value + "(me) => " + message.value + "\n";
        webSocket.send("{{" + user.value + "}}" + message.value);
        message.value = "";
    }

    function disconnect() {
        webSocket.close();
    }
</script>

<!-- 게임 로직 -->
<script>
    const table = document.querySelector('table');
    const playerInfo = document.querySelector('.player-info');
    const forbiddenInfo = document.querySelector('.forbidden-info');
    const winnerInfo = document.querySelector('.winner-info');
    const restartBtn = document.getElementById('restart-btn');
    const endBtn = document.getElementById('end-btn');

    let thisTurn = "O"; // 현재 차례 저장
    let allArr = 0; // 놓인 돌의 총 수 저장

    // 게임 보드 생성
    for (let i = 1; i <= 8; i++) {
        const row = document.createElement('tr');
        for (let j = 1; j <= 8; j++) {
            const cell = document.createElement('td');
            cell.id = '';
            row.appendChild(cell);
        }
        table.appendChild(row);
    }

    // 게임 보드에 이벤트 리스너 추가
    table.addEventListener('click', boxClick);
    restartBtn.addEventListener('click', restartGame);
    endBtn.addEventListener('click', endGame);

    function boxClick(event) {
        if (event.target.textContent) {
            forbiddenInfo.textContent = "그 자리에는 놓을 수 없습니다";
        } else {
            allArr++;
            forbiddenInfo.textContent = "";
            event.target.textContent = thisTurn;
            event.target.classList.add(thisTurn === "O" ? 'black' : 'white');
            
            const winArr = checkWin(event.target);
            if (winArr.length >= 5) {
                winnerInfo.textContent = '이(가) 이겼습니다!';
                table.removeEventListener('click', boxClick);
            } else if (allArr === 64) {
                winnerInfo.textContent = '비겼습니다!';
                table.removeEventListener('click', boxClick);
            }
            thisTurn = thisTurn === "O" ? "X" : "O";
            playerInfo.textContent = '현재 플레이어 : ';
        }
    }

    function checkWin(cell) {
        const directions = [
            [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]
        ];
        const row = parseInt(cell.id.charAt(0));
        const col = parseInt(cell.id.charAt(1));
        const currentStone = cell.textContent; 
        let winArr = []; 
        
        for (const dir of directions) {
            let count = 1;
            const dx = dir[0], dy = dir[1]; 
            
            for (let i = 1; i < 5; i++) {
                const newRow = row + dir[0] * i;
                const newCol = col + dir[1] * i;
                const newCell = document.getElementById(newRow.toString() + newCol.toString());
                if (newCell && newCell.textContent === currentStone) {
                    count++;
                    winArr.push(newCell);
                } else {
                    break;
                }
            }
            
            for (let i = 1; i < 5; i++) {
                const newRow = row - dx * i;
                const newCol = col - dy * i;
                const newCell = document.getElementById(newRow.toString() + newCol.toString());
                if (newCell && newCell.textContent === currentStone) {
                    count++;
                    winArr.push(newCell);
                } else {
                    break;
                }
            }
            
            if (count >= 5) {
                winArr.push(cell);
                break;
            } else {
                winArr = [];
            }
        }
        return winArr;
    }

    function restartGame() {
        const cells = document.querySelectorAll('td');
        cells.forEach(cell => {
            cell.textContent = '';
            cell.classList.remove('black', 'white');
        });
        thisTurn = "O";
        allArr = 0;
        playerInfo.textContent = '현재 플레이어 : ';
        forbiddenInfo.textContent = "";
        winnerInfo.textContent = "";
        table.addEventListener('click', boxClick);
    }

    function endGame() {
        winnerInfo.textContent = "게임이 종료되었습니다.";
        table.removeEventListener('click', boxClick);
    }
</script>

</body>
</html>