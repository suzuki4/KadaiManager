<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%
//managerLogin�擾
	boolean managerLogin = false;
	if(request.getAttribute("managerLogin") != null ) {
		managerLogin = (boolean) request.getAttribute("managerLogin");
	//�擾�ł��Ȃ��ꍇ�A�G���[
	} else {
		RequestDispatcher dispatcher;
		dispatcher = request.getRequestDispatcher("manager.jsp");
 	 	request.setAttribute("fail", "���O�C�����s");
 	 	dispatcher.forward(request, response);		
	}

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>���k�f�[�^�̒ǉ�</title>
    </head>
    <body>
        <h1>���k�f�[�^�̒ǉ�</h1>
        <table>
        <form method="post" action="/student">
            <tr><th>���kID:</th><td><input type="text" name="id"></td></tr>
            <tr><th>�p�X���[�h:</th><td><input type="password" name="pass"></td></tr>
            <tr><th>���k��:</th><td><input type="text" name="userName"></td></tr>
            <tr><th>�w�N:</th><td><input type="text" name="grade"></td></tr>
            <tr><th>E���[��:</th><td><input type="text" name="email"></td></tr>
            <tr><th></th><td><input type="submit" value="�ǉ�"></td></tr>
        </form>
        </table>
    </body>
</html>