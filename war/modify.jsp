<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>
<%@ page import="database.*"%>

<%
	//�ŏ����ł�����񂩂珉�������擾
	if(request.getParameter("id") != null) {
		request.setAttribute("inputId", request.getParameter("id"));
		request.setAttribute("inputPass", request.getParameter("pass"));
		request.setAttribute("inputUserName", request.getParameter("userName"));
		request.setAttribute("inputGrade", request.getParameter("grade"));
		request.setAttribute("inputEmail", request.getParameter("email"));
	}
/*	//�C������Ė߂��Ă�����id��setAttribute
	if(request.getAttribute("inputId") != null) {
		request.setAttribute("inputId", request.getAttribute("inputId"));
	}
	*/
	//managerLogin��true���ƁAdisable���ύX�\
	String disabled = "disabled";
	if(request.getParameter("managerLogin") != null && request.getParameter("managerLogin").equals("true")) {
		disabled = "";
		request.setAttribute("managerLogin", "true");
	}
	if(request.getAttribute("managerLogin") != null && request.getAttribute("managerLogin").equals("true")) {
		disabled = "";
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
        <form method="post" action="/studentModify">
        	<input type="hidden" name="oldId" value="<%=request.getAttribute("inputId") != null ? request.getAttribute("inputId") : "" %>">
            <input type="hidden" name="managerLogin" value="<%=request.getAttribute("managerLogin") != null ? request.getAttribute("managerLogin") : "" %>">
            <tr><th>���kID:</th><td><input type="text" name="id" <%=disabled %> value="<%=request.getAttribute("inputId") != null ? request.getAttribute("inputId") : "" %>" ></td></tr>
            <tr><th>�p�X���[�h:</th><td><input type="password" name="pass" value="<%=request.getAttribute("inputPass") != null ? request.getAttribute("inputPass") : "" %>"></td></tr>
            <tr><th>���k��:</th><td><input type="text" name="userName" <%=disabled %> value="<%=request.getAttribute("inputUserName") != null ? request.getAttribute("inputUserName") : "" %>" ></td></tr>
            <tr><th>�w�N:</th><td><input type="text" name="grade" <%=disabled %> value="<%=request.getAttribute("inputGrade") != null ? request.getAttribute("inputGrade") : "" %>" ></td></tr>
            <tr><th>E���[��:</th><td><input type="text" name="email" value="<%=request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : "" %>" ></td></tr>
            <tr><th></th>
            	<td nowrap>
            		<input type="submit" value="�C��">
      	</form>
            		<form method="post" action="/report.jsp">
            			<input type="hidden" name="id" value="<%=(String) request.getAttribute("inputId") %>">
            			<input type="submit" value="�߂�">
            		</form>
            	</td>
            </tr>
            <tr><th></th><td style="color:#FF0000; font-weight:bold; margin=:15px 0px;"><%if(request.getAttribute("info") != null) out.println(request.getAttribute("info"));%></td>
			</tr>
        </table>
    </body>
</html>