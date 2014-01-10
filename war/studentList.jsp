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

//StatusData
	//statusData�擾
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(StatusData.class);
	query.setFilter("id == 1");
	StatusData statusData = ((List<StatusData>)pm.detachCopyAll((List<StatusData>)query.execute())).get(0);
	pm.close();
	//restIds�擾
	ArrayList<Long> restIds = statusData.getRestIds();
//StatusData�i�X�V���j
	//update��post�ŗ��Ă���Ƃ�
	if(request.getParameter("update") != null) {
		//restIds���L��ꍇ������
		if(restIds != null) restIds.clear();
		//restIds�o�^
		String status[] = request.getParameterValues("status");
		if(status != null) {
			for(int i = 0; i < status.length; i++) {
			restIds.add(Long.parseLong(status[i]));
			}
		}
		statusData.setRestIds(restIds);
		//restIds�i�v��
		pm = PMF.get().getPersistenceManager();
	    try {
	        pm.makePersistent(statusData);
	    } finally {
	        pm.close();
	    }
	}	
	
//StudentData
	//data�擾
	pm = PMF.get().getPersistenceManager();
	query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();
	String eachData = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		StudentData data = studentDataList.get(i);
		//���|�[�g���inumberOfReport�j�擾
		int numberOfReport = 0;
		if(data.getReportNameList() != null) numberOfReport = data.getReportNameList().size();
		eachData 	+=	"<tr>"	
					+		"<td>"
					+			"<input type=\"checkbox\" name=\"status\" value=\"" + data.getId() + "\" " + (statusCheck(restIds, data.getId()) ? "checked" : "") + ">"
					+		"</td>"
					+		"<td>"
					+			(statusCheck(restIds, data.getId()) ? "�x�~" : "")
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
		//�I���������t�̃��|�[�g��������o����3�\��
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
		//restIds�����݂��Aid���܂ޏꍇ
		if(restIds != null && restIds.contains(id)) {
			return true;
		}
		return false;
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
	  		<input type="hidden" name="id" value=<%=request.getAttribute("id") %>>
	  		<input type="hidden" name="pass" value=<%=request.getAttribute("pass") %>>
	  		<input type="text" name="studentListTimeYear" size="4" maxlength="4" value="<%=studentListTimeYear %>">�N
	  		<input type="text" name="studentListTimeMonth" size="2" maxlength="2" value="<%=studentListTimeMonth %>">��
	  		<input type="text" name="studentListTimeDay" size="2" maxlength="2" value="<%=studentListTimeDay %>">��
	  		<input type="submit" value="�`�F�b�N���t�X�V">
	  	</div>
  	</form>  
  	<form action="managerlogin"  method="post">
  	<input type="hidden" name="id" value=<%=request.getAttribute("id") %>>
	<input type="hidden" name="pass" value=<%=request.getAttribute("pass") %>>
	<input type="hidden" name="update" value=<%=request.getAttribute("update") %>>
	<div align="center">
		��Ԃ̊��`�F�b�N���u�x�~�v�ɐݒ�A���`�F�b�N���u�x�~�v��������F<input type="submit" value="�x�~��ԍX�V">
		�@<form action="add.jsp"  method="post">
			<input type="hidden" name="managerLogin" value=<%=true %>>
			<input type="submit" value="���k�ǉ�">
	</div>
	  	<table border="1" align="center">
	  		<tr>
	  			<td colspan="2">���</td>
	  			<td>���kID</td>
	  			<td>�w�N</td>
	  			<td>���k��</td>
	  			<td>�P�ۑ薼</td>
	  			<td>�P����</td>
	  			<td>�Q�ۑ薼</td>
	  			<td>�Q����</td>
	  			<td>�R�ۑ薼</td>
	  			<td>�R����</td>
	  		</tr>
	  		<%=eachData %>
	  	</table>
	</form>
  </body>
</html>
