<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="other.*"%>

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
/*	//自分のdata取得
	pm = PMF.get().getPersistenceManager();
	query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
*/
	//periodが有る場合（デフォルトは無し→lastDay前日実績）
	String period = Period.LASTDAY;
	if(request.getParameter("period") != null) {
		period = request.getParameter("period");
	}
	//resultPeriodFormat設定
	SimpleDateFormat resultPeriodFormat = new SimpleDateFormat("yyyy'年'MM'月'dd'日('E')'", Locale.JAPAN);
	//resultPeriod（startDate, endDate, dateString）を取得
	ResultPeriod resultPeriod = new ResultPeriod(period, resultPeriodFormat);
	//resultDataString取得
	String resultDataString = resultDataString(studentDataList, resultPeriod);
	
%>	

<%!
	String resultDataString(List<StudentData> studentDataList, ResultPeriod resultPeriod) {
		////各生徒ごとの学年、名前、合計分数、平均分数を格納するRankingDataをvalueとするTreeMap作成
		TreeMap<Long, RankingData> rankingMap = new TreeMap<Long, RankingData>();
		//グラフ用にtotalの最大値を求めるtotalListの作成
		ArrayList<Integer> totalList = new ArrayList<Integer>();
		//全生徒データをチェック
		StudentData eachData;
		for(int i = 0; i < studentDataList.size(); i++) {
			eachData = studentDataList.get(i);
			int total = 0;
			//レポートが有る場合
			if(eachData.getReportNameList() != null) {
				//全レポートをチェック
				for(int j = 0; j < eachData.getReportNameList().size(); j++) {
					//該当有り
					if(resultPeriod.getStartDate().before(eachData.getReportFinishTimeList().get(j)) && eachData.getReportFinishTimeList().get(j).before(resultPeriod.getEndDate())) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
			}
			totalList.add(total);
			//RankingDataを作成して格納
			RankingData rankingData = new RankingData(eachData.getGrade(), eachData.getUserName(), total, total / (total != 0 ? resultPeriod.getNumberOfDate() : -1));
			//ランキング表示用TreeMapのkey取得
			Long key = (long) total * 100000 * 100000 + eachData.getId();
			//put
			rankingMap.put(key, rankingData);
		}
		
		//合計分数の最大値を100としたグラフ係数を取得
		double graphParameter;
		if(Collections.max(totalList) != 0) {
			graphParameter = 100.0 / Collections.max(totalList);
		} else {
			graphParameter = 0;
		}
		
		//各生徒ごとに表示内容を格納
		String resultDataString = "";
		DecimalFormat df = new DecimalFormat();
		df.setMaximumFractionDigits(1);
	    df.setMinimumFractionDigits(1);
		while(!rankingMap.isEmpty()) {
			Long key = rankingMap.lastKey();
			RankingData rankingData = rankingMap.remove(key);
			resultDataString 	+=	"<tr>"
								+		"<td>"
								+			rankingData.getGrade()
								+		"</td>"
								+		"<td>"
								+			rankingData.getUserName()
								+		"</td>"
								+		"<td>"
								+			"<img src=\"graph.gif\" alt=\"graph\" width=\"" + graphParameter * rankingData.getTotal() + "%\" height=\"100%\">"
								+		"</td>"
								+		"<td>"
								+			rankingData.getTotal()
								+		"</td>"
								+		"<td>"
								+			df.format(rankingData.getAverage())
								+		"</td>"
								+	"</tr>"
								;
		}
		return resultDataString;
	}
%>

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=Shift_JIS">
    <title>実績</title>
  </head>

  <body>
	<div align="center">
		期間：<%=resultPeriod.getDateString() %>
	</div>
	<p></p>
	<div align="center">
		<form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="前日実績">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="<%=Period.LASTWEEK %>">
            <input type="submit" value="前週実績">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="<%=Period.LASTMONTH %>">
            <input type="submit" value="前月実績">
        </form>
        <form method="post" action="/report.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="戻る">
        </form>
	</div>
	<p></p>
  	<table border="1" align="center">
  		<tr>
  			<td>学年</td>
  			<td>生徒名</td>
  			<td>グラフ</td>
  			<td>合計時間数(分)</td>
  			<td>1日平均</td>
  		</tr>
  		<%=resultDataString %>
  	</table>
  </body>
</html>