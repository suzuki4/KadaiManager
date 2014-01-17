<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>

<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%
	//id取得
	Long id = -1L;
	if(request.getParameter("id") != null) {
		id = Long.parseLong(request.getParameter("id"));
	} else if(request.getAttribute("id") != null) {
		id = (Long) request.getAttribute("id");
	}
	//studentData取得
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();
	//自分のdata取得
	pm = PMF.get().getPersistenceManager();
	query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
	//periodが有る場合（デフォルトは無し→lastDay前日実績）
	String period = "lastDay";
	if(request.getParameter("period") != null) {
		period = request.getParameter("period");
	}
	//resultDateFormat設定
	SimpleDateFormat resultDateFormat = new SimpleDateFormat("yyyy'年'MM'月'dd'日('E') 'HH':'mm", Locale.JAPAN);
	//日付計算用フォーマット
	SimpleDateFormat resultDateCompareFormat = new SimpleDateFormat("yyyyMMdd");
	SimpleDateFormat resultMonthCompareFormat = new SimpleDateFormat("yyyyMM");
	//resultDate取得
	Date resultDate = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
	//resultDateを比較用Stringに
	String resultDateCompareString = resultDateCompareFormat.format(resultDate.getTime() - 1000 * 60 * 60 * 24);
	//eachDataString
	String eachDataString = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		StudentData eachData = studentDataList.get(i);
		//合計分数計算
		int total = 0;
		int average = 0;
			//レポート数（numberOfReport）取得
			int numberOfReport = 0;
			if(eachData.getReportNameList() != null) numberOfReport = eachData.getReportNameList().size();		
			//
			//計算期間によって分類
			Calendar calendar;
			int j;
			switch(period) {
			case "lastDay":
				for(j = 0; j < numberOfReport; j++) {
					//該当する場合
					if(resultDateCompareFormat.format(eachData.getReportFinishTimeList().get(j)).equals(resultDateCompareString)) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
				average = total;
				break;
			case "lastWeek":
				//計算週をはじく
				calendar = Calendar.getInstance(Locale.JAPAN);
				int adjust = 1 - Calendar.DAY_OF_WEEK - 7;
				calendar.set(Calendar.YEAR, Calendar.MONTH, Calendar.DATE + adjust);
				Date startDate = calendar.getTime();
				Date endDate = new Date(startDate.getTime() + 1000 * 60 * 60 * 24 * 7);
				for(j = 0; j < numberOfReport; j++) {
					//該当する場合
					if(eachData.getReportFinishTimeList().get(j).after(new Date(startDate.getTime() - 1)) && eachData.getReportFinishTimeList().get(j).before(endDate)) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
				average = total / 7;
				break;
			case "lastMonth":
				//計算月をはじく
				calendar = Calendar.getInstance(Locale.JAPAN);
				calendar.add(Calendar.MONTH, -1);
				calendar.set(Calendar.YEAR, Calendar.MONTH, Calendar.DATE);
				String resultMonthCompareString = resultMonthCompareFormat.format(calendar.getTime());
				for(j = 0; j < numberOfReport; j++) {
					//該当する場合
					if(resultMonthCompareFormat.format(eachData.getReportFinishTimeList().get(j)).equals(resultMonthCompareString)) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
				average = total / calendar.getActualMaximum(Calendar.DATE);
				break;
			}		
		//各生徒ごとに表示
		eachDataString 	+=	"<tr>"
						+		"<td>"
						+			eachData.getGrade()
						+		"</td>"
						+		"<td>"
						+			eachData.getUserName()
						+		"</td>"
						+		"<td>"
						+			"グラフ"
						+		"</td>"
						+		"<td>"
						+			total
						+		"</td>"
						+		"<td>"
						+			average
						+		"</td>"
						+	"</tr>"
						;
	}
%>	

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=Shift_JIS">
    <title>実績</title>
  </head>

  <body>
	<div align="center">
		期間：<%="resultPeriod" %>
	</div>
	<div align="center">
		<form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="前日実績">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="lastWeek">
            <input type="submit" value="前週実績">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="lastMonth">
            <input type="submit" value="前月実績">
        </form>
        <form method="post" action="/report.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="戻る">
        </form>
	</div>
  	<table border="1" align="center">
  		<tr>
  			<td>学年</td>
  			<td>生徒名</td>
  			<td>グラフ</td>
  			<td>合計分数</td>
  			<td>1日平均</td>
  		</tr>
  		<%=eachDataString %>
  	</table>
  </body>
</html>