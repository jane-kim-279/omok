package omok2;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



@WebServlet("/Mypage/*")
public class mypageController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	//한 번 선언하면, destroy 할 때까지 생성이 되어서 존재한다. 
	private MemberDAO dao;
	
	//처음 실행할 때 단 한 번만 실행 
	public void init() throws ServletException {
		dao = new MemberDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	private void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String page = null;
		String action = request.getPathInfo();
		
		String userId = null;
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if (cookie.getName().equals("user")) {
	                userId = URLDecoder.decode(cookie.getValue(), "UTF-8");
	                break;
	            }
	        }
	    }

		System.out.println("action : "+action);
		System.out.println(userId);
		if ("/viewPage.jsp".equals(action)) {
			// 비즈니스 로직  처리 
			List<MemberVO> list = dao.listMembers(userId);
			List<GameVO> game = dao.gameList(userId);
			request.setAttribute("memberList", list);
			request.setAttribute("gameList", game);
			page = "/Mypage.jsp";
			System.out.println(list);
			System.out.println(game);
			
		} else if ("/Edit.do".equals(action)) {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=utf-8");
			
			MemberVO vo = new MemberVO();
			vo.setUserid(request.getParameter("id"));
			vo.setUserpwd(request.getParameter("pwd"));
			vo.setUsername(request.getParameter("name"));
			vo.setUsertel(request.getParameter("tel"));
			dao.updateMember(vo);
			System.out.println("수정");
			
			PrintWriter out = response.getWriter();
	        out.println("<script type='text/javascript'>");
	        out.println("alert('수정이 완료되었습니다, 마이 페이지로 돌아갑니다.');");
	        out.println("location.href = '/omok2/Main.jsp';");
	        out.println("</script>");
	        
	        return;
			
		} else if ("/logout.do".equals(action)) {
			request.setCharacterEncoding("UTF-8");
	        response.setContentType("text/html;charset=utf-8");
	        
	        // 쿠키 삭제
	        if (cookies != null) {
		        for (Cookie cookie : cookies) {
		            if (cookie.getName().equals("user")) {
		            	System.out.println("쿠키");
		            	cookie.setMaxAge(0); // 쿠키 만료
		            	cookie.setPath("/");
		                response.addCookie(cookie);
		                break;
		            }
		        }
		    }
	        
	        // alert 띄우기
	        PrintWriter out = response.getWriter();
	        out.println("<script type='text/javascript'>");
	        out.println("alert('로그아웃 되었습니다');");
	        out.println("location.href = '/omok2/Main.jsp';");
	        out.println("</script>");
	        System.out.println(" 삭제 ");
	        return;
		}
		request.getRequestDispatcher(page).forward(request, response);
		
	}

}
