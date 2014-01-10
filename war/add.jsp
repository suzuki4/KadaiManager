<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>生徒データの追加</title>
    </head>
    <body>
        <h1>生徒データの追加</h1>
        <table>
        <form method="post" action="/studentAdd">
            <tr><th>生徒ID:</th><td><input type="text" name="id"></td></tr>
            <tr><th>パスワード:</th><td><input type="password" name="pass"></td></tr>
            <tr><th>生徒名:</th><td><input type="text" name="userName"></td></tr>
            <tr><th>学年:</th><td><input type="text" name="grade"></td></tr>
            <tr><th>Eメール:</th><td><input type="text" name="email"></td></tr>
            <tr><th></th><td><input type="submit" value="追加"></td></tr>
            <tr><th></th><td style="color:#FF0000; font-weight:bold; margin=:15px 0px;"><%if(request.getAttribute("info") != null) out.println(request.getAttribute("info"));%></td>
		</tr>	
        </form>
        </table>
    </body>
</html>