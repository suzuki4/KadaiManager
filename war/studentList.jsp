<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>


<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%

//�ŏ�
	
	//�f�[�^�x�[�X�������������t�擾
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");	
	String studentListTimeYear;
	String studentListTimeMonth;
	String studentListTimeDay;
	String studentListTimeString;
	//���t�w��L��
	if(request.getParameter("studentListTimeYear") != null) {
		studentListTimeYear = request.getParameter("studentListTimeYear");
		studentListTimeMonth = request.getParameter("studentListTimeMonth");
		studentListTimeDay = request.getParameter("studentListTimeDay");
		studentListTimeString = studentListTimeYear + studentListTimeMonth + studentListTimeDay;
	//���t�w�薳��
	} else {
		Date studentListTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
		studentListTimeYear = new SimpleDateFormat("yyyy").format(studentListTime);
		studentListTimeMonth = new SimpleDateFormat("MM").format(studentListTime);
		studentListTimeDay = new SimpleDateFormat("dd").format(studentListTime);
		studentListTimeString = sdf.format(studentListTime);
	}
	
	//data�擾
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
    <title>���k�ꗗ</title>
  </head>

  <body>
  	<form action="managerlogin"  method="post">
		<div align="center">
	  		<input type="text" name="studentListTimeYear" size="4" maxlength="4" value="<%=studentListTimeYear %>">�N
	  		<input type="text" name="studentListTimeMonth" size="2" maxlength="2" value="<%=studentListTimeMonth %>">��
	  		<input type="text" name="studentListTimeDay" size="2" maxlength="2" value="<%=studentListTimeDay %>">��
	  		<input type="hidden" name="id" value=<%=request.getAttribute("id") %>>
	  		<input type="hidden" name="pass" value=<%=request.getAttribute("pass") %>>
	  		<input type="submit" value="�`�F�b�N���t�X�V">
	  	</div>
  	</form>  	
  	<table border="1" align="center">
  		<tr>
  			<td>���kID</td>
  			<td>�w�N</td>
  			<td>���k��</td>
  			<td>�x�~</td>
  			<td>�P�ۑ薼</td>
  			<td>�P����</td>
  			<td>�Q�ۑ薼</td>
  			<td>�Q����</td>
  			<td>�R�ۑ薼</td>
  			<td>�R����</td>
  		</tr>
  		<%=eachData %>
  	</table>
  </body>
</html>
