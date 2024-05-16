package omok2;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@ServerEndpoint("/socket")
public class Socket {
	// 접속 된 클라이언트 WebSocket session 관리 리스트
	private static List<Session> sessions = new ArrayList<>();
	private static List<String> history = new ArrayList<>();
	int win = 0;
	long[][] gameboard = new long[30][30];
	
	public void winCheck(int row, int col, long usrValue) {
		win = 0; 

	    // forward vertically
		forward_check(row, col, 1, usrValue);

		// backward vertically
		backward_check(row, col, 1, usrValue);

		if(win >= 5) {
			return;
		} else {
	        win = 0;
		}

		// forward horizontally
		forward_check(col, row, 0, usrValue);

		// backward horizontally
		backward_check(col, row, 0, usrValue);

		if(win >= 5) {
			return;
		} else {
			win = 0;
		}

		// diagonal forward downwards check
		diagonalForwardDown(row, col, usrValue);

		// diagonal backward upwards check
		diagonalBackwardUp(row, col, usrValue);

		if(win >= 5) {
			return;
		} else {
			win = 0;
		}

		// diagonal forward upwards check
		diagonalForwardUp(row, col, usrValue);

		// diagonal backward downward check
		diagonalBackwardDown(row, col, usrValue);

		if(win >= 5) {
			return;
		} else {
			win = 0;
		}
	 }
	
	 public void forward_check(int dir,int value,int pro,long usr) {
		 int next;
		 if(dir <= 14) {
			 next = 4;
		 } else {
			 next = 18 - dir;
		 }

		 if(pro == 1) {
			 for(int c = dir; c <= dir+next; c++) {
				 if(gameboard[c][value] == 0 || gameboard[c][value] != usr) {
					 break;
				 }
				 if(gameboard[c][value] == usr ) {
					 win++;
				 }
			 }	
		 } else {
			 for(int c = dir; c <= dir+next; c++) {
				 if(gameboard[value][c] == 0 || gameboard[value][c] != usr) {
					 break;
				 }
				 if(gameboard[value][c] == usr ) {
			    	win++;
				 }
			 }	
		 }
		 if(win == 1) {
			 win = 0;
		 }
	}

	// first argument tells the searching - horizon or vertical and second argument for gameboard.
	 public void backward_check(int dir, int value, int pos, long usr) {
		int previous;

	    if (dir >= 4) {
	    	previous = 4;
	    } else {
	    	previous = dir;
	    }

	    if(pos == 1) {
			for(int c = dir; c >= dir - previous ; c--) {
		    	if(gameboard[c][value] == 0 || gameboard[c][value] != usr) {
		    		break;
	    		} 
		    	if(gameboard[c][value] == usr ) {
		    		win++;
		    	}
	    	}
	    } else {
			for(int c = dir; c >= dir-previous; c--) {
		    	if(gameboard[value][c] == 0 || gameboard[value][c] != usr) {
		    		break;
	    		}
		    	if(gameboard[value][c] == usr ) {
		    		win++;
		    	}
	    	}   
	    }
	}

	public void diagonalForwardDown(int row, int col, long usr) {
		int funWin = 0;
		for(int c = 0; c <= 4; c++) {
			if(row + c <= 18 && col + c <= 18) {
				if(gameboard[row+c][col+c] == 0 || gameboard[row+c][col+c] != usr) {
					break;
				}
				if(gameboard[row+c][col+c] == usr) {
					funWin++;
					win++;
				}
			}
		}
		if(funWin == 5) {
			win = 5;
			return;
		}
		if(win >= 1) {
			win--;
		}
	}

	public void diagonalBackwardUp(int row, int col, long usr) {
		int funWin = 0;
		for(int c = 0; c <= 4; c++) {
			if(row - c >= 0 && col - c >= 0) {
				if(gameboard[row-c][col-c] == 0 || gameboard[row-c][col-c] != usr) {
					break;
				} 
				if(gameboard[row-c][col-c] == usr) {
					funWin++;
					win++;
				}
			}
		}
		if(funWin == 5) {
			win = 5;
			return;
		}
	}

	public void diagonalBackwardDown(int row, int col, long usr) {
		int funWin = 0;
		for(int c = 0; c <= 4; c++) {
			if(row + c <= 18 && col - c >= 0) {
				if(gameboard[row+c][col-c] == 0 || gameboard[row+c][col-c] != usr) {
					break;
				} 
				if(gameboard[row+c][col-c] == usr) {
					win++;
					funWin++;
				}
			}
		}
		if(funWin == 5) {
			win = 5;
			return;
		}
	}

	public void diagonalForwardUp(int row, int col, long usr) {
		int funWin = 0;
		for(int c = 0; c <= 4; c++) {
			if(row - c >= 0 && col + c <= 18) {
				if(gameboard[row-c][col+c] == 0 || gameboard[row-c][col+c] != usr) {
					break;
				} 
				if(gameboard[row-c][col+c] == usr) {
					win++;
					funWin++;
				}
			}
		}
		if(funWin == 5) {
			win = 5;
			return;
		}
		if(win >= 1) {
			win--;
		}
	}
	
	// WebSocket으로 브라우저가 접속하면 요청되는 함수
	@OnOpen
	public void handleOpen(Session userSession) throws Exception, EncodeException {
		 // 클라이언트가 접속하면 WebSocket세션을 리스트에 저장한다.
		 sessions.add(userSession);
		 System.out.println("client is now connected...");
		 System.out.println(sessions.size());
		 if(sessions.size()>2) {
			 String str = "{\"type\": \"more-clients\"}";
			Iterator<Session> iterator = sessions.iterator();
			while(iterator.hasNext()) {
				iterator.next().getBasicRemote().sendText(str);
			}
		 }
//		 System.out.println("세션 인덱스 : " +sessions.indexOf(userSession));
		 history.add(sessions.indexOf(userSession), "");
//		 System.out.println("히스토리 저장 확인: " + history.get(sessions.indexOf(userSession)));
		 if(history.size() > 0) {
			 System.out.println("히스토리 히스토리");
			 String str = "{\"type\": \"history\", \"data\": \"";
			 str += history.toString();
			 str += "\"}";
			Iterator<Session> iterator = sessions.iterator();
			while(iterator.hasNext()) {
				iterator.next().getBasicRemote().sendText(str);
			}
		 }
	}
	@OnMessage
	public void handleMessage(String message, Session userSession) throws IOException {
		 System.out.println("메세지 핸들: " + message);
		 JSONParser p = new JSONParser();
		 try {
			JSONObject obj = (JSONObject) p.parse(message);
			if("ClientConnect".equals(obj.get("type"))) {
				System.out.println("Client "+ sessions.size());
				if(sessions.size() == 2) {
					System.out.println("Two Client Connection");
					String str = "{\"type\": \"second-client\"}";
					sessions.get(sessions.indexOf(userSession)).getBasicRemote().sendText(str);
//					Iterator<Session> iterator = sessions.iterator();
//					while(iterator.hasNext()) {
//						iterator.next().getBasicRemote().sendText(str);
//					}
					str = "{\"type\": \"chance\"}";
					if(history.size() > 1) {
						sessions.get(0).getBasicRemote().sendText(str);
					}
				}
			}
			else {
				if("gameboard-index".equals(obj.get("type"))) {
					System.out.println("gameboard");
					int i = Integer.parseInt(String.valueOf(obj.get("data1"))) ;
					int j = Integer.parseInt(String.valueOf(obj.get("data2")));
					System.out.println("서버측 i, j, color: " + i + ", " + j + ", " + obj.get("color"));
					gameboard[i][j] = (long) obj.get("color");
					winCheck(i, j, (long)obj.get("color"));
					String json_msg = "";
					if(win >= 5) {
						System.out.println("Winner: " + win);
						json_msg = "";
						json_msg = "{\"type\": \"winner\", \"data1\": \"";
						json_msg += obj.get("data1");
						json_msg += "\", \"data2\": \"";
						json_msg += obj.get("data2");
						json_msg += "\", \"color\": \"";
						json_msg += obj.get("color");
						json_msg += "\"}";
					}
					else {
						json_msg = "";
						json_msg = "{\"type\": \"gameboard-index\", \"data1\": \"";
						json_msg += obj.get("data1");
						json_msg += "\", \"data2\": \"";
						json_msg += obj.get("data2");
						json_msg += "\", \"color\": \"";
						json_msg += obj.get("color");
						json_msg += "\"}";
						System.out.println("history 인덱스 : " + sessions.indexOf(userSession));
						history.set(sessions.indexOf(userSession), json_msg);
					}
					for(int k=0; k<sessions.size(); k++) {
						sessions.get(k).getBasicRemote().sendText(json_msg);
					}
				}
				else {
					System.out.println("여기 에러");
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}
	@OnClose
	public void handleClose(Session userSession) {
		// session 리스트로 접속 끊은 세션을 제거한다.
		sessions.remove(userSession);
		// 콘솔에 접속 끊김 로그를 출력한다.
		System.out.println("client is now disconnected...");
	}
	
	
}