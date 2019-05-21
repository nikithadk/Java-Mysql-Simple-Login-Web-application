<%@ page import="java.sql.*"%>
<% 
	String userName = request.getParameter("userName"); 
	String password = request.getParameter("password"); 
	String firstName = request.getParameter("firstName"); 
	String lastName = request.getParameter("lastName"); 
	String email = request.getParameter("email"); 
	Class.forName ("com.sql.jdbc.Driver"); 
        Connection con = DriverManager.getConnection("jdbc:sqlserver://arjundb.database.windows.net:1433;database=arjundb;user=arjundb@arjundb;password=Qwerty@12345;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;");
 
	Statement st = con.createStatement(); 
	int i = st.executeUpdate("insert into USER(first_name, last_name, email, username, password, regdate) values ('" + firstName + "','" + lastName + "','" + email + "','" + userName + "','" + password + "', CURDATE())");
	if (i > 0) { 
				response.sendRedirect("welcome.jsp"); 
			} 
	else { 
		response.sendRedirect("index.jsp"); 
		} 
%>
