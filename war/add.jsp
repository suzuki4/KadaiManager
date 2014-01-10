<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%
//managerLogin取得
	boolean managerLogin = false;
	if(request.getAttribute("managerLogin") != null ) {
		managerLogin = (boolean) request.getAttribute("managerLogin");
	//取得できない場合、エラー
	} else {
		RequestDispatcher dispatcher;
		dispatcher = request.getRequestDispatcher("manager.jsp");
 	 	request.setAttribute("fail", "ログイン失敗");
 	 	dispatcher.forward(request, response);		
	}

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>生徒データの追加</title>
    </head>
    <body>
        <h1>生徒データの追加</h1>
        <table>
        <form method="post" action="/student">
            <tr><th>生徒ID:</th><td><input type="text" name="id"></td></tr>
            <tr><th>パスワード:</th><td><input type="password" name="pass"></td></tr>
            <tr><th>生徒名:</th><td><input type="text" name="userName"></td></tr>
            <tr><th>学年:</th><td><input type="text" name="grade"></td></tr>
            <tr><th>Eメール:</th><td><input type="text" name="email"></td></tr>
            <tr><th></th><td><input type="submit" value="追加"></td></tr>
        </form>
        </table>
    </body>
</html>