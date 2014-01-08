<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>


<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%

//最初
	
	//データベースから引っ張る日付取得
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");	
	String studentListTimeYear;
	String studentListTimeMonth;
	String studentListTimeDay;
	String studentListTimeString;
	//日付指定有り
	if(request.getParameter("studentListTimeYear") != null) {
		studentListTimeYear = request.getParameter("studentListTimeYear");
		studentListTimeMonth = request.getParameter("studentListTimeMonth");
		studentListTimeDay = request.getParameter("studentListTimeDay");
		studentListTimeString = studentListTimeYear + studentListTimeMonth + studentListTimeDay;
	//日付指定無し
	} else {
		Date studentListTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
		studentListTimeYear = new SimpleDateFormat("yyyy").format(studentListTime);
		studentListTimeMonth = new SimpleDateFormat("MM").format(studentListTime);
		studentListTimeDay = new SimpleDateFormat("dd").format(studentListTime);
		studentListTimeString = sdf.format(studentListTime);
	}
	
	//data取得
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();
	String eachData = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		StudentData data = studentDataList.get(i);
		int numberOfReport = data.getReportNameList().size();
		eachData 	+=	"<tr>"	
					+		"<td>"
					+			data.getId()
					+		"</td>"
					+		"<td>"
					+			data.getGrade()
					+		"</td>"
					+		"<td>"
					+			data.getUserName()
					+		"</td>"
					+		"<td>"
					+			data.getUserName()
					+		"</td>"
					;
		if(numberOfReport >= 1 && sdf.format(data.getReportFinishTimeList().get(numberOfReport - 1)).equals(studentListTimeString)) {
			eachData+=		"<td>"
					+			data.getReportNameList().get(numberOfReport - 1)
					+		"</td>"
					+		"<td>"
					+			data.getReportMinutesList().get(numberOfReport - 1)
					+		"</td>"
					;
		}
		if(numberOfReport >= 2 && sdf.format(data.getReportFinishTimeList().get(numberOfReport - 2)).equals(studentListTimeString)) {
			eachData+=		"<td>"
					+			data.getReportNameList().get(numberOfReport - 2)
					+		"</td>"
					+		"<td>"
					+			data.getReportMinutesList().get(numberOfReport - 2)
					+		"</td>"
					;
		}
		if(numberOfReport >= 3 && sdf.format(data.getReportFinishTimeList().get(numberOfReport - 3)).equals(studentListTimeString)) {	
			eachData+=		"<td>"
					+			data.getReportNameList().get(numberOfReport - 3)
					+		"</td>"
					+		"<td>"
					+			data.getReportMinutesList().get(numberOfReport - 3)
					+		"</td>"
					;
		}
		eachData 	+=	"</tr>"	
					;
	}	

		
%>

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=Shift_JIS">
    <title>生徒一覧</title>
  </head>

  <body>
  	<form action="managerlogin"  method="post">
		<div align="center">
	  		<input type="text" name="studentListTimeYear" size="4" maxlength="4" value="<%=studentListTimeYear %>">年
	  		<input type="text" name="studentListTimeMonth" size="2" maxlength="2" value="<%=studentListTimeMonth %>">月
	  		<input type="text" name="studentListTimeDay" size="2" maxlength="2" value="<%=studentListTimeDay %>">日
	  		<input type="hidden" name="id" value=<%=request.getAttribute("id") %>>
	  		<input type="hidden" name="pass" value=<%=request.getAttribute("pass") %>>
	  		<input type="submit" value="チェック日付更新">
	  	</div>
  	</form>  	
  	<table border="1" align="center">
  		<tr>
  			<td>生徒ID</td>
  			<td>学年</td>
  			<td>生徒名</td>
  			<td>休止</td>
  			<td>１課題名</td>
  			<td>１分数</td>
  			<td>２課題名</td>
  			<td>２分数</td>
  			<td>３課題名</td>
  			<td>３分数</td>
  		</tr>
  		<%=eachData %>
  	</table>
  </body>
</html>
