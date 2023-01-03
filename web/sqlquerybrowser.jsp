<%
    if(session.isNew())
    response.sendRedirect("front.jsp");
%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>SQLQueryBrowser</title>
        <style>
  body{
  width: 100%;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-size: 300% 300%;
  background-image: linear-gradient(
        -45deg, 
        rgba(59,173,227,1) 0%, 
        rgba(87,111,230,1) 25%, 
        rgba(152,68,183,1) 51%, 
        rgba(255,53,127,1) 100%
  );  
  animation: AnimateBG 2s ease infinite;
}

@keyframes AnimateBG { 
  0%{background-position:0% 50%}
  50%{background-position:100% 50%}
  100%{background-position:0% 50%}
 }
  
    </style>
    </head>
    
    <body>
    <center>
         <h1>SQL Query Browser </h1>
         <form method="post" action="sqlquerybrowser.jsp">
             <table>
                 <textarea rows="8"cols="50" name="qry" placeholder="PLEASE ENTER QUERY"></textarea>
                 <br><br><input style=" cursor: pointer; font-size: 20px; padding: 5px 10px;" type="submit" value="Execute"></h1>

             </table>
             <br><br><br><br>
         </form>
         <%
             String qry=null,dbname=null;
              try
            {
            String id=null, pass=null,port=null,ipadd=null;
            id=session.getAttribute("uid").toString();
            pass=session.getAttribute("upass").toString();
            dbname=session.getAttribute("db").toString();
            port=session.getAttribute("port").toString();
            ipadd=session.getAttribute("ipadd").toString();
            
            PreparedStatement ps=null;
            ResultSet rs=null;
            ResultSetMetaData rsmd=null;
           
           if(dbname!=null&&id!=null&&pass!=null&&ipadd!=null&&port!=null)
           {   
             qry=request.getParameter("qry"); 
             if(qry.startsWith("USE")||qry.startsWith("use")||qry.startsWith("Use"))
             {
                 dbname=qry.substring(4);
                 session.setAttribute("db",dbname);
             }
             Class.forName("com.mysql.cj.jdbc.Driver");
             Connection con=null;
           //  con=DriverManager.getConnection("jdbc:mysql://localhost:3306/"+dbname,id,pass);
             con=DriverManager.getConnection("jdbc:mysql://"+ipadd+":"+port+"/"+dbname+"",id,pass);
             ps=con.prepareStatement(qry);
             qry=qry.toUpperCase();
           
             if(qry.startsWith("SELECT")||qry.startsWith("SHOW")||qry.startsWith("DESC"))
             {
               rs=ps.executeQuery();
               rsmd=rs.getMetaData();
               out.println("<table border=1>");
               out.println("<tr>");
               int i;
               for(i=1;i<=rsmd.getColumnCount();i++)
               {   
               out.println("<th>"+rsmd.getColumnName(i)+"</th>");
               }
               out.println("</tr>");
               while(rs.next())
               {
               out.println("<tr>");
               for(i=1;i<=rsmd.getColumnCount();i++) 
               {
                   out.println("<td>"+rs.getString(i)+"</td>");  
                
                //  out.println("<td><input type=txt name="+""+"</td>");  
               }  
               out.println("</tr>");
               }
               out.println("</table>");                                   //yaha form laga kr programming.
               }
               else
               {
               out.println("query ok"+ps.executeUpdate()+"record inserted");
               }
             }
            }
                catch(Exception e)
               {
                   if(qry==null)
                    out.println("<h1>PLZ ENTER QUERY<h1>"); 
                   else {
                       out.println("<h1>"+e+"<h1>"); 
                   out.println("ENTER CORRECT QUERY"); 
                   }
               }
        %> 
        
    </center>
    </body>
</html>