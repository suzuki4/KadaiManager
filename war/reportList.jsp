<%@page import="javax.persistence.MapKey"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>

<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%

//StudentData
	//studentData�擾
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();

//selectDataString�擾�iselect���ꂽ���k������ꍇ�j
	Long id = -1L;
	String selectDataString = "";
	if(request.getParameter("selectId") != null) {
		//selectData�擾
		id = Long.parseLong(request.getParameter("selectId"));
		pm = PMF.get().getPersistenceManager();
		query = pm.newQuery(StudentData.class);
		query.setFilter("id == " + id);
		StudentData selectData = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
		pm.close();
		//�ۑ�f�[�^������ꍇ
		if(selectData.getReportNameList() != null) {
			//selectDataMap�擾�iselectData��sort�̂���map�Ɏ��[�j
			TreeMap<Date, ArrayList> selectDataMap = new TreeMap<Date, ArrayList>();
			//map��key�ƂȂ�ArryaList<Date>�쐬���ă\�[�g
			ArrayList<Date> mapKey = selectData.getReportFinishTimeList();
			Collections.sort(mapKey);
			//map�Ɏ��[
			for(int i = 0; i < selectData.getReportNameList().size(); i++) {
				//map��value�Ɏ��[�p��ArrayList�쐬
				ArrayList mapValue = new ArrayList();
				mapValue.add(selectData.getReportNameList().get(i));
				mapValue.add(selectData.getReportMinutesList().get(i));
				//map�Ɏ��[
				selectDataMap.put(selectData.getReportFinishTimeList().get(i), mapValue);
			}
			//Date�̃t�H�[�}�b�g���쐬
			SimpleDateFormat dateStringFormat = new SimpleDateFormat("yyyy'�N'MM'��'dd'��('E') 'HH':'mm", Locale.JAPAN); 
			//selectDataMap����sort���ꂽ�f�[�^�����o��selectDataString�ɃZ�b�g
			for(int i = 0; i < selectDataMap.size(); i++) {
				Date keyDate = mapKey.get(i);
				selectDataString	+=	"<tr>"
									+		"<td>"
									+			"<form action=\"/reportModify.jsp\" method=\"post\" style=\"display: inline;\">"
									+				"<input type=\"hidden\" name=\"managerLogin\" value=\"true\">"
									+				"<input type=\"hidden\" name=\"id\" value=" + id + ">"
									+				"<input type=\"submit\" value=\"�C��\">"
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

//select�p�̐��k�ꗗ
	String selectUserNames = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		selectUserNames	+= "<option value=\""
						+	studentDataList.get(i).getId()
						+	"\" "
							//����selected�ݒ�
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
    <title>�ۑ�ꗗ</title>
  </head>

  <body>
  	<div align="center">
		<form action="/reportList.jsp" method="post">
			<input type="hidden" name="managerLogin" value=<%="true" %>>
			<select name="selectId" size="1">
				<option value="�����l">���k�I��</option>
				<%=selectUserNames %>
			</select>
			<input type="submit" value="���k�I��">
		</form>
	</div>
  	<table border="1" align="center">
  		<tr>
  			<td></td>
  			<td>���t</td>
  			<td>�ۑ薼</td>
  			<td>����</td>
  		</tr>
  		<%=selectDataString %>
  	</table>
  </body>
</html>