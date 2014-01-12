<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>


<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%

//最初
	//id取得
	int id = -1;
	if(request.getAttribute("id") != null) {
		id = (int) request.getAttribute("id");
	} else if(request.getParameter("id") != null) {
		id = Integer.parseInt(request.getParameter("id"));
	}
	//data取得
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
	
	//reportOpenTime取得
	Date reportOpenTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
	String reportOpenTimeString = new SimpleDateFormat("yy'/'MM'/'dd'\n'HH':'mm").format(reportOpenTime);

//以下取消が押された場合
	if(request.getParameter("index") != null) {
		data.getReportNameList().remove(Integer.parseInt(request.getParameter("index")));
		data.getReportMinutesList().remove(Integer.parseInt(request.getParameter("index")));
		data.getReportFinishTimeList().remove(Integer.parseInt(request.getParameter("index")));
		//data永久化
		pm = PMF.get().getPersistenceManager();
        try {
            pm.makePersistent(data);
        } finally {
            pm.close();
        }
	}
	
//以下登録が押されて入力情報が来ている場合
	//入力情報がnullなら何もしない
	String error = "";
	if(request.getParameter("reportName") == null && request.getParameter("reportMinutes") == null) {
	} else {
		//入力情報があるならエラーチェック
		try {
			//入力情報が""ならエラーへ
	    	if(request.getParameter("reportName").equals("") || request.getParameter("reportMinutes").equals("")) {
				throw new Exception();
			}
			//分数が数値でなければエラーへ
			Integer.parseInt(request.getParameter("reportMinutes"));
	    	//エラーOKなら
			String reportName = request.getParameter("reportName");
			int reportMinutes = Integer.parseInt(request.getParameter("reportMinutes"));
			Date reportFinishTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
			//dataに登録
			data.getReportNameList().add(reportName);
			data.getReportMinutesList().add(reportMinutes);
			data.getReportFinishTimeList().add(reportFinishTime);			
			//data永久化
			pm = PMF.get().getPersistenceManager();
	        try {
	            pm.makePersistent(data);
	        } finally {
	            pm.close();
	        }
		//エラー発生			
	    } catch(Exception e) {
	    	//out.println(e.toString());
			error +=	"<tr>"
					+		"<td align=\"center\" colspan=\"4\" style=\"color:#FF0000; font-weight:bold;\" >"
					+			"入力エラー！"
					+		"</td>"
					+	"</tr>"
					;	
		}
	}
//以下本日登録したデータがある場合
	String reportFinishTimeToday = "";
	String reportOpenTimeDate = new SimpleDateFormat("yyMMdd").format(reportOpenTime);	
	for(int i = 0; i < data.getReportFinishTimeList().size(); i++) {
		Date takeReportFinishTime = data.getReportFinishTimeList().get(i);		
		String takeReportFinishTimeDate = new SimpleDateFormat("yyMMdd").format(takeReportFinishTime);
		if(reportOpenTimeDate.equals(takeReportFinishTimeDate)) {
			reportFinishTimeToday +=	"<tr>"
											//取消ボタン
									+		"<td align=\"center\">"
									+			"<form action=\"report.jsp\" method=\"post\">"
									+				"<input type=\"hidden\" name=\"id\" value=" + id + ">"
									+				"<input type=\"hidden\" name=\"index\" value=" + i + ">"
									+				"<input type=\"submit\" value=\"取消\">"
									+			"</form>"
									+		"</td>"
									+		"<td>"
									+			new SimpleDateFormat("yy'/'MM'/'dd'\n'HH':'mm").format(takeReportFinishTime)
									+		"</td>"
									+		"<td>"
									+			data.getReportNameList().get(i)
									+		"</td>"
									+		"<td>"
									+			data.getReportMinutesList().get(i)
									+		"</td>"
									+	"</tr>"
									;
		}
	}
%>
		
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=Shift_JIS">
    <title>Report</title>
  </head>

  <body>
  	<table align="center" style="border: solid 1px;">
  		<tr>
  			<td colspan="4" >生徒ID：<%=data.getId() %>　/　学年：<%=data.getGrade() %>　/　生徒名：<%=data.getUserName() %></td>
  		</tr>
  		<tr>
  			<td colspan="4"  style="border-bottom: solid 1px; margin:10px 0px;">
  				<form action="/modify.jsp" method="post">
  					<input type="hidden" name="data" value="<%=data %>">
  					<input type="hidden" name="managerLogin" value="<%=request.getAttribute("managerLogin") %>">
  					<input type="submit" value="登録情報修正">
  				</form>
  			</td>
  		</tr>
  		<tr>
  			<td><input type="submit" value="実績&#13;&#10;一覧"></td>
  			<td>日時</td>
  			<td>取り組んだ課題</td>
  			<td>分数</td>
  		</tr>
  		<form action="report.jsp"  method="post">
  		<input type="hidden" name="id" value="<%=id %>">
  		<tr>
  			<td></td>
  			<td style="height:width: 80px;"><%=reportOpenTimeString %></td>
  			<td><textarea name="reportName" rows="3" maxlength="100"></textarea></td>
  			<td><input type="text" name="reportMinutes" size="3" maxlength="3" style="text-align:right;"></td>
  		</tr>
  		<tr>
  			<td align="center" colspan="4" style="margin:15px 0px;"><input type="submit" value="送信！" style="margin=: 10px 0px; padding: 5px 140px;"></td>
  		</tr>
  		</form>
  		<%=error %>
  		<%=reportFinishTimeToday %>

  	</table>
  </body>
</html>
