<%@ page import="java.sql.*"%>

<%
 String userName = request.getParameter("userName"); 
 
 String password = request.getParameter("password"); 
 
Class.forName ("com.mysql.jdbc.Driver"); 
Connection con = DriverManager.getConnection("String url ="jdbc:mysql://arjunmyql.mysql.database.azure.com:3306/demo?useSSL=true&requireSSL=false"; myDbConn = DriverManager.getConnection(url, "arjundb@arjunmyql", "Qwerty@12345");"); 
 
 Statement st = con.createStatement(); 
 ResultSet rs; 
 rs = st.executeQuery("select * from USER where username='" + userName + "' and password='" + password + "'");
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
