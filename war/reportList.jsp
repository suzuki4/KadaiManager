<%@page import="javax.persistence.MapKey"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>

<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%

//StudentData
	//studentData取得
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();

//selectDataString取得（selectされた生徒がいる場合）
	Long id = -1L;
	String selectDataString = "";
	if(request.getParameter("selectId") != null) {
		//selectData取得
		id = Long.parseLong(request.getParameter("selectId"));
		pm = PMF.get().getPersistenceManager();
		query = pm.newQuery(StudentData.class);
		query.setFilter("id == " + id);
		StudentData selectData = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
		pm.close();
		//課題データがある場合
		if(selectData.getReportNameList() != null) {
			//selectDataMap取得（selectDataをsortのためmapに収納）
			TreeMap<Date, ArrayList> selectDataMap = new TreeMap<Date, ArrayList>();
			//mapのkeyとなるArryaList<Date>作成してソート
			ArrayList<Date> mapKey = selectData.getReportFinishTimeList();
			Collections.sort(mapKey);
			//mapに収納
			for(int i = 0; i < selectData.getReportNameList().size(); i++) {
				//mapのvalueに収納用のArrayList作成
				ArrayList mapValue = new ArrayList();
				mapValue.add(selectData.getReportNameList().get(i));
				mapValue.add(selectData.getReportMinutesList().get(i));
				//mapに収納
				selectDataMap.put(selectData.getReportFinishTimeList().get(i), mapValue);
			}
			//Dateのフォーマットを作成
			SimpleDateFormat dateStringFormat = new SimpleDateFormat("yyyy'年'MM'月'dd'日('E') 'HH':'mm", Locale.JAPAN); 
			//selectDataMapからsortされたデータを取り出しselectDataStringにセット
			for(int i = 0; i < selectDataMap.size(); i++) {
				Date keyDate = mapKey.get(i);
				selectDataString	+=	"<tr>"
									+		"<td>"
									+			"<form action=\"/reportModify.jsp\" method=\"post\" style=\"display: inline;\">"
									+				"<input type=\"hidden\" name=\"managerLogin\" value=\"true\">"
									+				"<input type=\"hidden\" name=\"id\" value=" + id + ">"
									+				"<input type=\"submit\" value=\"修正\">"
									+			"</form>"
									+		"</td>"
									+		"<td>"
									+			dateStringFormat.format(keyDate)
									+		"</td>"
									+		"<td>"
									+			selectDataMap.get(keyDate).get(0)
									+		"</td>"
									+		"<td>"
									+			selectDataMap.get(keyDate).get(1)
									+		"</td>"
									+	"</tr>"
									;
			}
		}
	}

//select用の生徒一覧
	String selectUserNames = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		selectUserNames	+= "<option value=\""
						+	studentDataList.get(i).getId()
						+	"\" "
							//初期selected設定
						+	(id == studentDataList.get(i).getId() ? "selected" : "")
						+	">"
						+	studentDataList.get(i).getUserName()
						+	"</option>"
						;
	}



%>

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=Shift_JIS">
    <title>課題一覧</title>
  </head>

  <body>
  	<div align="center">
		<form action="/reportList.jsp" method="post">
			<input type="hidden" name="managerLogin" value=<%="true" %>>
			<select name="selectId" size="1">
				<option value="初期値">生徒選択</option>
				<%=selectUserNames %>
			</select>
			<input type="submit" value="生徒選択">
		</form>
	</div>
  	<table border="1" align="center">
  		<tr>
  			<td></td>
  			<td>日付</td>
  			<td>課題名</td>
  			<td>分数</td>
  		</tr>
  		<%=selectDataString %>
  	</table>
  </body>
</html>