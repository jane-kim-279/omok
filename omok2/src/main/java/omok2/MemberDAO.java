package omok2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import omok2.MemberVO;

public class MemberDAO {
	private Connection con;
	private PreparedStatement pstmt;
	private DataSource dataFactory;
	
	public MemberDAO() {
        try {
        	Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource) envContext.lookup("jdbc/oracle");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }
	
	public void addMember(MemberVO vo) {
		try { 
			con = dataFactory.getConnection();
			String id = vo.getUserid();
			String pwd = vo.getUserpwd();
			String name = vo.getUsername();
			String tel = vo.getUsertel();
			
			String query = "insert into Users";
			query += " (userid, userpwd, username, usertel)";
			query += " values(?, ?, ?, ?)";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, pwd);
			pstmt.setString(3, name);
			pstmt.setString(4, tel);
			pstmt.executeUpdate();
			pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally { 
			try { pstmt.close(); } catch(Exception e) {}
			try { con.close(); } catch(Exception e) {} 
		}
	}
	



	 public boolean login(String id, String pwd) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	     
		boolean result = false;
		try {
			con = dataFactory.getConnection();
			String query = "select decode(count(*), 1, 'true', 'false') as result from Users";
			query += " where userid=? and userpwd=?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, pwd);
			rs = pstmt.executeQuery();
			rs.next();
			result = Boolean.parseBoolean(rs.getString("result"));
			pstmt.close();
				
		} catch (Exception e) {
			e.printStackTrace();
		} finally { // 오류가 있더라도 무조건 종료를 해야 하니까 finally에 작성
			try { rs.close(); } catch(Exception e) {}
			try { pstmt.close(); } catch(Exception e) {}
			try { con.close(); } catch(Exception e) {} 
		}
		return result;
	 }
	 
	 
	 public String findId(String name, String tel) {
	     ResultSet rs = null;
	     String id = "";

	     try {
	        con = dataFactory.getConnection();
	        String query = "SELECT userid FROM Users WHERE username = ? AND usertel = ?";
	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, name);
	        pstmt.setString(2, tel);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	        	id = rs.getString("userid");
		        System.out.println(id);
	        }
	        return id;
	     } catch (SQLException e) {
	        e.printStackTrace();
	        return "";
	     } finally {
	        try {
	           if (rs != null) rs.close();
	           if (pstmt != null) pstmt.close();
	           if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally { // 오류가 있더라도 무조건 종료를 해야 하니까 finally에 작성
				try { rs.close(); } catch(Exception e) {}
				try { pstmt.close(); } catch(Exception e) {}
				try { con.close(); } catch(Exception e) {} 
			}
	     }
	  }
	    
	 public String findPassword(String name, String tel) {
	    ResultSet rs = null;
	    String pwd = "";
	    try {
	      con = dataFactory.getConnection();
	      String query = "SELECT userpwd FROM Users WHERE username = ? AND usertel = ?";
	      pstmt = con.prepareStatement(query);
	      pstmt.setString(1, name);
	      pstmt.setString(2, tel);
	      rs = pstmt.executeQuery();
	        if (rs.next()) {
				pwd = rs.getString("userpwd");
			} 
	        return pwd;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return "";
	    } finally {
	        try {
	        	if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (con != null) con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally { 
				try { rs.close(); } catch(Exception e) {}
				try { pstmt.close(); } catch(Exception e) {}
				try { con.close(); } catch(Exception e) {} 
			}
	    }
	 }
	    
	 public List<MemberVO> listMembers (String id) {
	    ResultSet rs = null;
	    MemberVO vo = new MemberVO();
	    List<MemberVO> list = new ArrayList<>();

	    try {
	    	con = dataFactory.getConnection();
	    	String query = "SELECT * FROM Users WHERE userid = ?";
	    	pstmt = con.prepareStatement(query);
	    	pstmt.setString(1, id);
	    	rs = pstmt.executeQuery();
	    	if (rs.next()) { 
	    		vo.setUserid(rs.getString("userid"));
	    		vo.setUserpwd(rs.getString("userpwd"));
	    		vo.setUsername(rs.getString("username"));
	    		vo.setUsertel(rs.getString("usertel"));
	    		list.add(vo);
	    	}

		} catch (Exception e) {
			e.printStackTrace();
		} finally { 
			try { rs.close(); } catch(Exception e) {}
			try { pstmt.close(); } catch(Exception e) {}
			try { con.close(); } catch(Exception e) {} 
		}
	    return list;

		}
	 
	 
	
	 public List<GameVO> gameList (String id){
		 ResultSet rs = null;
		 List<GameVO> list = new ArrayList<>();

		 try {
			 con = dataFactory.getConnection();
			 String query = "SELECT * FROM RECORDS WHERE USERID = ?";
			 pstmt = con.prepareStatement(query);
			 pstmt.setString(1, id);
			 rs = pstmt.executeQuery();
			 
			 while (rs.next()) { 
				 GameVO vo = new GameVO();
				 vo.setUserid(rs.getString("userid"));
				 vo.setGamedate(rs.getString("gamedate"));
				 list.add(vo);
			 }

		 } catch (Exception e) {
			 e.printStackTrace();
		 } finally { 
			 try { rs.close(); } catch(Exception e) {}
			 try { pstmt.close(); } catch(Exception e) {}
			 try { con.close(); } catch(Exception e) {} 
		 }
		 return list;

	 }
	 

	 public void updateMember(MemberVO vo) {
		 try { 
			 con = dataFactory.getConnection();
			 String id = vo.getUserid();
			 String pwd = vo.getUserpwd();
			 String name = vo.getUsername();
			 String tel = vo.getUsertel();
				
			 String query = "update Users";
			 query += " set userpwd = ?, username = ?, usertel = ?";
			 query += " where userid = ?";
			 pstmt = con.prepareStatement(query);
			 pstmt.setString(1, pwd);
			 pstmt.setString(2, name);
			 pstmt.setString(3, tel);
			 pstmt.setString(4, id);
			 pstmt.executeUpdate();
			 pstmt.close();
		 } catch (Exception e) {
			 e.printStackTrace();
		 } finally { 
			 try { pstmt.close(); } catch(Exception e) {}
			 try { con.close(); } catch(Exception e) {} 
		 }
	 }
	 
	 public String getUserNameById(String id) {
		    String name = null;
		    try {
		        con = dataFactory.getConnection();
		        String query = "select username from users where userid=?";
		        pstmt = con.prepareStatement(query);
		        pstmt.setString(1, id);
		        ResultSet rs = pstmt.executeQuery();
		        if(rs.next()) {
		            name = rs.getString("username");
		        }
		        rs.close();
		        pstmt.close();
		        con.close();
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return name;
		}
 
	 
	 public void resultUpdate(String id) {
		 try {
			 con = dataFactory.getConnection();
			 String query = "insert into RECORDS";
			 query += " (userid)";
			 query += " values(?)";
			 pstmt = con.prepareStatement(query);
			 pstmt.setString(1, id);
			 pstmt.executeUpdate();
			 pstmt.close();
			 con.close();
		 } catch (Exception e) {
			 e.printStackTrace();
		 } finally { 
			 try { pstmt.close(); } catch(Exception e) {}
			 try { con.close(); } catch(Exception e) {} 
		 }
	 }
}

		
	    
	  




