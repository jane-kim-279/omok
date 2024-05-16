package omok2;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/omokfind")
public class omokfind extends HttpServlet {
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
		String name = request.getParameter("name");
        String tel = request.getParameter("tel");
		String result = null;
        if ("findId".equals(command)) {
            result = dao.findId(name, tel);
            if (result != null && !result.isEmpty()) {
            	
            	out.println("<script type='text/javascript'>");
    			out.println("alert('"+ name + " 님의 아이디는 [" + result + "] 입니다.');" );
    			out.println("location.href = '/omok2/Login.jsp';");
    	        out.println("</script>");

            } else {
            	out.println("<script type='text/javascript'>");
    			out.println("alert('ID를 찾을 수 없습니다.');");
    			out.println("location.href = '/omok2/Find.jsp';");
    	        out.println("</script>");
            }
        } else {
            result = dao.findPassword(name, tel);
            if (result != null && !result.isEmpty()) {
            	out.println("<script type='text/javascript'>");
    			out.println("alert('"+ name + " 님의 비밀번호는 [" + result + "] 입니다.');" );
    			out.println("location.href = '/omok2/Login.jsp';");
    	        out.println("</script>");
            } else {
            	out.println("<script type='text/javascript'>");
    			out.println("alert('비밀번호를 찾을 수 없습니다.');");
    			out.println("location.href = '/omok2/Find.jsp';");
    	        out.println("</script>");
            }
        }
        out.println("</body></html>");
        out.close();
    }
}