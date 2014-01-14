<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="java.text.*"%>
<%@ page import="database.*"%>
<%@ page import="java.util.*"%>

<%
	//最初飛んできた情報から初期情報を取得
	Long id = Long.parseLong(request.getParameter("id"));
	//data取得
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
	//生徒名取得
	String userName = data.getUserName();
	//課題番号取得
	int reportNumber = Integer.parseInt(request.getParameter("reportNumber"));
	//課題日時取得
	Date reportFinishTime = data.getReportFinishTimeList().get(reportNumber);
		//Dateのフォーマットを作成
		SimpleDateFormat dateStringFormat;
		//課題終了年月日取得
		dateStringFormat = new SimpleDateFormat("yyyy"); 
		String reportFinishTimeYear = dateStringFormat.format(reportFinishTime);
		dateStringFormat = new SimpleDateFormat("MM"); 
		String reportFinishTimeMonth = dateStringFormat.format(reportFinishTime);
		dateStringFormat = new SimpleDateFormat("dd"); 
		String reportFinishTimeDay = dateStringFormat.format(reportFinishTime);
		//課題終了時刻取得
		dateStringFormat = new SimpleDateFormat("HH"); 
		String reportFinishTimeHour = dateStringFormat.format(reportFinishTime);
		dateStringFormat = new SimpleDateFormat("mm"); 
		String reportFinishTimeMinute = dateStringFormat.format(reportFinishTime);
	//課題名取得
	String reportName = data.getReportNameList().get(reportNumber);
	//分数取得
	int reportMinutes = data.getReportMinutesList().get(reportNumber);
	
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>課題データの修正</title>
    </head>
    <body>
        <h1>課題データの修正</h1>
        <table>
        <form method="post" action="/reportModify" style="display: inline;">
            <input type="hidden" name="managerLogin" value="<%=request.getAttribute("managerLogin") != null ? request.getAttribute("managerLogin") : "" %>">
        	<input type="hidden" name="id" value="<%=id %>">
            <tr><th>生徒ID:</th><td><input type="text" name="id" disabled value="<%=id %>" ></td></tr>
            <tr><th>生徒名:</th><td><input type="text" name="userName" disabled value="<%=userName %>" ></td></tr>
            <tr><th>課題日時:</th>
            	<td>
            		<input type="text" name="reportFinishTimeYear" size="4" maxlength="4" value="<%=reportFinishTimeYear %>" >年
            		<input type="text" name="reportFinishTimeMonth" size="2" maxlength="2" value="<%=reportFinishTimeMonth %>" >月
            		<input type="text" name="reportFinishTimeDay" size="2" maxlength="2" value="<%=reportFinishTimeDay %>" >日　
            		<input type="text" name="reportFinishTimeHour" size="2" maxlength="2" value="<%=reportFinishTimeHour %>" >：
            		<input type="text" name="reportFinishTimeMinute" size="2" maxlength="2" value="<%=reportFinishTimeMinute %>" >
            	</td>
            </tr>
            <tr><th>課題名:</th><td><input type="text" name="reportName" value="<%=reportName %>" ></td></tr>
            <tr><th>分数:</th><td><input type="text" name="reportMinutes" value="<%=reportMinutes %>" ></td></tr>
            <tr><th></th>
            	<td nowrap>
            		<input type="submit" value="修正">
      	</form>
            		<form method="post" action="/reportDelete" style="display: inline;">
                        <input type="hidden" name="managerLogin" value="true">
            			<input type="hidden" name="id" value="<%=id %>">
            			<input type="hidden" name="reportNumber" value="<%=reportNumber %>">
            			<input type="submit" value="削除（注意！）">
            		</form>
            		<form method="post" action="/reportList.jsp" style="display: inline;">
                        <input type="hidden" name="managerLogin" value="true">
            			<input type="hidden" name="selectId" value="<%=id %>">
            			<input type="submit" value="戻る">
            		</form>
            	</td>
            </tr>
        </table>
    </body>
</html>