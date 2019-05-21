<%@ page import="java.sql.*"%>

<%
 String userName = request.getParameter("userName"); 
 
 String password = request.getParameter("password"); 
 
 Class.forName ("com.sql.jdbc.Driver"); 
 Connection con = DriverManager.getConnection("jdbc:sqlserver://arjundb1.database.windows.net:1433;database=arjundb11;user=arjundb1@arjundb1;password=Qwerty@12345;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;");
 
 Statement st = con.createStatement(); 
 ResultSet rs; 
 rs = st.executeQuery("select * from Users where username='" + userName + "' and password='" + password + "'");
	if (rs.next()) 
		{ 
			session.setAttribute("userid", userName); 
			response.sendRedirect("success.jsp"); 
		} 
	else 
		{ 
			out.println("Invalid password <a href='index.jsp'>try again</a>"); 
} 
%>
