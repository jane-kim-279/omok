package omok2;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/omokjoin")
public class OmokJoin extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}
	
	
	
	
	protected void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");
		MemberDAO dao = new MemberDAO();
		PrintWriter out = response.getWriter();
		String command = request.getParameter("command");
		if ("addMember".equals(command)) {
			String _id = request.getParameter("id");
			String _pwd = request.getParameter("pwd");
			String _name = request.getParameter("name");
			String _tel = request.getParameter("tel");
			MemberVO vo = new MemberVO();
			vo.setUserid(_id);
			vo.setUserpwd(_pwd);
			vo.setUsername(_name);
			vo.setUsertel (_tel);
			dao.addMember(vo);
			out.println("<script type='text/javascript'>");
			out.println("alert('"+ _name + " 님, 가입 축하합니다.');" );
			out.println("location.href = '/omok2/Login.jsp';");
	        out.println("</script>");
		} 

	}

}
