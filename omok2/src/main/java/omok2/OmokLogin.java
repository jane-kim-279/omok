package omok2;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/omoklogin")
public class OmokLogin extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doHandle(request, response);
    }

    protected boolean doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // id, password를 request로부터 꺼내온다.
        String _id = request.getParameter("id");
        String _pwd = request.getParameter("pwd");

        // DAO 객체를 생성한다.
        // DAO 객체는 DB와 연결하여 데이터를 주고 받는 객체이다.
        // 이미 MemberDAO Login 메소드를 구현해 놓으셨기 때문에 그것을 사용하면 됩니다
        MemberDAO dao = new MemberDAO();

        // 로그인 호출 결과를 받는다.
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=utf-8");
        boolean result = dao.login(_id,_pwd);
		PrintWriter out = response.getWriter();
		
		if (result) {
			out.print("<script>alert('로그인에 성공하였습니다');</script>");
			out.print("<script>location.href='Main.jsp';</script>");
			Cookie userCookie = new Cookie("user", URLEncoder.encode(_id, "UTF-8"));
			userCookie.setMaxAge(60*60*24); // 쿠키 유효 기간을 1일로 설정
			userCookie.setPath("/");
			response.addCookie(userCookie);
			
		} else {
			out.print("<script>alert('로그인에 실패하였습니다. 아이디와 비밀번호를 다시 확인해주세요');</script>");
			out.print("<script> history.go(-1)</script>");
		}
		return result;
    }
   
}
