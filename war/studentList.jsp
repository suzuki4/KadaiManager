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

//StatusData
	//statusData取得
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(StatusData.class);
	query.setFilter("id == 1");
	StatusData statusData = ((List<StatusData>)pm.detachCopyAll((List<StatusData>)query.execute())).get(0);
	pm.close();
	//restIds取得
	ArrayList<Long> restIds = statusData.getRestIds();
//StatusData（更新時）
	//updateがpostで来ているとき
	if(request.getParameter("update") != null) {
		//restIdsが有る場合初期化
		if(restIds != null) restIds.clear();
		//restIds登録
		String status[] = request.getParameterValues("status");
		if(status != null) {
			for(int i = 0; i < status.length; i++) {
			restIds.add(Long.parseLong(status[i]));
			}
		}
		statusData.setRestIds(restIds);
		//restIds永久化
		pm = PMF.get().getPersistenceManager();
	    try {
	        pm.makePersistent(statusData);
	    } finally {
	        pm.close();
	    }
	}	
	
//StudentData
	//data取得
	pm = PMF.get().getPersistenceManager();
	query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();
	String eachData = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		StudentData data = studentDataList.get(i);
		//レポート数（numberOfReport）取得
		int numberOfReport = 0;
		if(data.getReportNameList() != null) numberOfReport = data.getReportNameList().size();
		eachData 	+=	"<tr>"	
					+		"<td>"
					+			"<input type=\"checkbox\" name=\"status\" value=\"" + data.getId() + "\" " + (statusCheck(restIds, data.getId()) ? "checked" : "") + ">"
					+		"</td>"
					+		"<td>"
					+			(statusCheck(restIds, data.getId()) ? "休止" : "")
					+		"</td>"
					+		"<td>"
					+			data.getId()
					+		"</td>"
					+		"<td>"
					+			data.getGrade()
					+		"</td>"
					+		"<td>"
					+			data.getUserName()
					+		"</td>"
					;
		//選択した日付のレポートを後入れ先出しで3つ表示
		int limit = 3;
		while(limit > 0 && numberOfReport > 0) {
			if(sdf.format(data.getReportFinishTimeList().get(numberOfReport - 1)).equals(studentListTimeString)) {
				eachData+=		"<td>"
						+			data.getReportNameList().get(numberOfReport - 1)
						+		"</td>"
						+		"<td>"
						+			data.getReportMinutesList().get(numberOfReport - 1)
						+		"</td>"
						;
				limit--;
			}
			numberOfReport--;
		}
		eachData 	+=	"</tr>"	
					;
	}	

%>
	
<%!
//method:statusCheck
	boolean statusCheck(ArrayList<Long> restIds, Long id) {
		//restIdsが存在し、idを含む場合
		if(restIds != null && restIds.contains(id)) {
			return true;
		}
		return false;
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
	  		<input type="hidden" name="id" value=<%=request.getAttribute("id") %>>
	  		<input type="hidden" name="pass" value=<%=request.getAttribute("pass") %>>
	  		<input type="text" name="studentListTimeYear" size="4" maxlength="4" value="<%=studentListTimeYear %>">年
	  		<input type="text" name="studentListTimeMonth" size="2" maxlength="2" value="<%=studentListTimeMonth %>">月
	  		<input type="text" name="studentListTimeDay" size="2" maxlength="2" value="<%=studentListTimeDay %>">日
	  		<input type="submit" value="チェック日付更新">
	  	</div>
  	</form>  
  	<form action="managerlogin"  method="post">
  	<input type="hidden" name="id" value=<%=request.getAttribute("id") %>>
	<input type="hidden" name="pass" value=<%=request.getAttribute("pass") %>>
	<input type="hidden" name="update" value=<%=request.getAttribute("update") %>>
	<div align="center">
		状態の既チェックを「休止」に設定、未チェックを「休止」から解除：<input type="submit" value="休止状態更新">
		　<form action="add.jsp"  method="post">
			<input type="hidden" name="managerLogin" value=<%=true %>>
			<input type="submit" value="生徒追加">
	</div>
	  	<table border="1" align="center">
	  		<tr>
	  			<td colspan="2">状態</td>
	  			<td>生徒ID</td>
	  			<td>学年</td>
	  			<td>生徒名</td>
	  			<td>１課題名</td>
	  			<td>１分数</td>
	  			<td>２課題名</td>
	  			<td>２分数</td>
	  			<td>３課題名</td>
	  			<td>３分数</td>
	  		</tr>
	  		<%=eachData %>
	  	</table>
	</form>
  </body>
</html>
