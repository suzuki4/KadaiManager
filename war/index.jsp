<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=Shift_JIS">
    <title>ログイン画面</title>
  </head>

  <body>
    <table align="center" style="border: solid 1px;" width="320px">
		<tr>
			<td colspan="3" align="center"><img src="kiwi.png"></td>        
		</tr>
	<form action="login" method="post">
		<tr>
			<td colspan="2">ユーザーID：</td><td><input type="text" name="id" size="18" maxlength="12"></td>
		</tr>
		<tr>
			<td colspan="2">パスワード：</td><td><input type="password" name="pass" size="18" maxlength="12"></td>
		</tr>
		<tr>
			<td align="center" colspan="3"><input type="submit" value="ログイン" style="margin=: 10px 0px; padding: 10px 100px;"></td>
		</tr>
		<tr>
			<td align="center" colspan="3" style="color:#FF0000; font-weight:bold; margin=:15px 0px;"><%if(request.getAttribute("fail") != null) out.println(request.getAttribute("fail"));%></td>
		</tr>		
	</form>
 	</table>
  </body>
</html>
