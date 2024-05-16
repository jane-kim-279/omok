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



@WebServlet("/Game/*")
public class GameController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	private void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		MemberDAO dao = new MemberDAO();
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
		if ("/result.do".equals(action)) {
			// 비즈니스 로직  처리 
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html;charset=utf-8");
			dao.resultUpdate(userId);
			PrintWriter out = response.getWriter();
			out.println("<script type='text/javascript'>");
	        out.println("location.href = '/omok2/Main.jsp';");
	        out.println("</script>");
			
		} 
		
	}

}
