<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%
	//
	if(request.getParameter("managerLogin").equals("true")) {
		out.println("true");
	}
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>���k�f�[�^�̏C��</title>
    </head>
    <body>
        <h1>���k�f�[�^�̏C��</h1>
        <table>
        <form method="post" action="/studentAdd">
            <tr><th>���kID:</th><td><input type="text" name="id" <%="disable" %> value="<%=request.getAttribute("inputId") != null ? request.getAttribute("inputId") : "" %>" ></td></tr>
            <tr><th>�p�X���[�h:</th><td><input type="password" name="pass"></td></tr>
            <tr><th>���k��:</th><td><input type="text" name="userName" disabled="disabled" value="<%=request.getAttribute("inputUserName") != null ? request.getAttribute("inputUserName") : "" %>" ></td></tr>
            <tr><th>�w�N:</th><td><input type="text" name="grade" disabled="disabled" value="<%=request.getAttribute("inputGrade") != null ? request.getAttribute("inputGrade") : "" %>" ></td></tr>
            <tr><th>E���[��:</th><td><input type="text" name="email" value="<%=request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : "" %>" ></td></tr>
            <tr><th></th><td><input type="submit" value="�ǉ�"></td></tr>
            <tr><th></th><td style="color:#FF0000; font-weight:bold; margin=:15px 0px;"><%if(request.getAttribute("info") != null) out.println(request.getAttribute("info"));%></td>
		</tr>	
        </form>
        </table>
    </body>
</html>