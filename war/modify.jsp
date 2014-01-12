<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>
<%@ page import="database.*"%>

<%
	//最初飛んできた情報から初期情報を取得
	if(request.getParameter("id") != null) {
		request.setAttribute("inputId", request.getParameter("id"));
		request.setAttribute("inputPass", request.getParameter("pass"));
		request.setAttribute("inputUserName", request.getParameter("userName"));
		request.setAttribute("inputGrade", request.getParameter("grade"));
		request.setAttribute("inputEmail", request.getParameter("email"));
	}
	
	//managerLoginがtrueだと、disableも変更可能
	String disabled = "disabled";
	if(request.getParameter("managerLogin").equals("true")) disabled = "";
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>生徒データの修正</title>
    </head>
    <body>
        <h1>生徒データの修正</h1>
        <table>
        <form method="post" action="/studentAdd">
            <tr><th>生徒ID:</th><td><input type="text" name="id" <%=disabled %> value="<%=request.getAttribute("inputId") != null ? request.getAttribute("inputId") : "" %>" ></td></tr>
            <tr><th>パスワード:</th><td><input type="password" name="pass" value="<%=request.getAttribute("inputPass") != null ? request.getAttribute("inputPass") : "" %>"></td></tr>
            <tr><th>生徒名:</th><td><input type="text" name="userName" <%=disabled %> value="<%=request.getAttribute("inputUserName") != null ? request.getAttribute("inputUserName") : "" %>" ></td></tr>
            <tr><th>学年:</th><td><input type="text" name="grade" <%=disabled %> value="<%=request.getAttribute("inputGrade") != null ? request.getAttribute("inputGrade") : "" %>" ></td></tr>
            <tr><th>Eメール:</th><td><input type="text" name="email" value="<%=request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : "" %>" ></td></tr>
            <tr><th></th><td><input type="submit" value="追加"></td></tr>
            <tr><th></th><td style="color:#FF0000; font-weight:bold; margin=:15px 0px;"><%if(request.getAttribute("info") != null) out.println(request.getAttribute("info"));%></td>
		</tr>	
        </form>
        </table>
    </body>
</html>