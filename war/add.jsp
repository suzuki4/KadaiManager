<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>���k�f�[�^�̒ǉ�</title>
    </head>
    <body>
        <h1>���k�f�[�^�̒ǉ�</h1>
        <table>
        <form method="post" action="/studentAdd">
            <tr><th>���kID:</th><td><input type="text" name="id"></td></tr>
            <tr><th>�p�X���[�h:</th><td><input type="password" name="pass"></td></tr>
            <tr><th>���k��:</th><td><input type="text" name="userName"></td></tr>
            <tr><th>�w�N:</th><td><input type="text" name="grade"></td></tr>
            <tr><th>E���[��:</th><td><input type="text" name="email"></td></tr>
            <tr><th></th><td><input type="submit" value="�ǉ�"></td></tr>
            <tr><th></th><td style="color:#FF0000; font-weight:bold; margin=:15px 0px;"><%if(request.getAttribute("info") != null) out.println(request.getAttribute("info"));%></td>
		</tr>	
        </form>
        </table>
    </body>
</html>