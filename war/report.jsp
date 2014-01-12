<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>


<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%

//�ŏ�
	//id�擾
	int id = -1;
	if(request.getAttribute("id") != null) {
		id = (int) request.getAttribute("id");
	} else if(request.getParameter("id") != null) {
		id = Integer.parseInt(request.getParameter("id"));
	}
	//data�擾
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
	
	//reportOpenTime�擾
	Date reportOpenTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
	String reportOpenTimeString = new SimpleDateFormat("yy'/'MM'/'dd'\n'HH':'mm").format(reportOpenTime);

//�ȉ�����������ꂽ�ꍇ
	if(request.getParameter("index") != null) {
		data.getReportNameList().remove(Integer.parseInt(request.getParameter("index")));
		data.getReportMinutesList().remove(Integer.parseInt(request.getParameter("index")));
		data.getReportFinishTimeList().remove(Integer.parseInt(request.getParameter("index")));
		//data�i�v��
		pm = PMF.get().getPersistenceManager();
        try {
            pm.makePersistent(data);
        } finally {
            pm.close();
        }
	}
	
//�ȉ��o�^��������ē��͏�񂪗��Ă���ꍇ
	//���͏��null�Ȃ牽�����Ȃ�
	String error = "";
	if(request.getParameter("reportName") == null && request.getParameter("reportMinutes") == null) {
	} else {
		//���͏�񂪂���Ȃ�G���[�`�F�b�N
		try {
			//���͏��""�Ȃ�G���[��
	    	if(request.getParameter("reportName").equals("") || request.getParameter("reportMinutes").equals("")) {
				throw new Exception();
			}
			//���������l�łȂ���΃G���[��
			Integer.parseInt(request.getParameter("reportMinutes"));
	    	//�G���[OK�Ȃ�
			String reportName = request.getParameter("reportName");
			int reportMinutes = Integer.parseInt(request.getParameter("reportMinutes"));
			Date reportFinishTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
			//data�ɓo�^
			data.getReportNameList().add(reportName);
			data.getReportMinutesList().add(reportMinutes);
			data.getReportFinishTimeList().add(reportFinishTime);			
			//data�i�v��
			pm = PMF.get().getPersistenceManager();
	        try {
	            pm.makePersistent(data);
	        } finally {
	            pm.close();
	        }
		//�G���[����			
	    } catch(Exception e) {
	    	//out.println(e.toString());
			error +=	"<tr>"
					+		"<td align=\"center\" colspan=\"4\" style=\"color:#FF0000; font-weight:bold;\" >"
					+			"���̓G���[�I"
					+		"</td>"
					+	"</tr>"
					;	
		}
	}
//�ȉ��{���o�^�����f�[�^������ꍇ
	String reportFinishTimeToday = "";
	String reportOpenTimeDate = new SimpleDateFormat("yyMMdd").format(reportOpenTime);	
	for(int i = 0; i < data.getReportFinishTimeList().size(); i++) {
		Date takeReportFinishTime = data.getReportFinishTimeList().get(i);		
		String takeReportFinishTimeDate = new SimpleDateFormat("yyMMdd").format(takeReportFinishTime);
		if(reportOpenTimeDate.equals(takeReportFinishTimeDate)) {
			reportFinishTimeToday +=	"<tr>"
											//����{�^��
									+		"<td align=\"center\">"
									+			"<form action=\"report.jsp\" method=\"post\">"
									+				"<input type=\"hidden\" name=\"id\" value=" + id + ">"
									+				"<input type=\"hidden\" name=\"index\" value=" + i + ">"
									+				"<input type=\"submit\" value=\"���\">"
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
  			<td colspan="4" >���kID�F<%=data.getId() %>�@/�@�w�N�F<%=data.getGrade() %>�@/�@���k���F<%=data.getUserName() %></td>
  		</tr>
  		<tr>
  			<td colspan="4"  style="border-bottom: solid 1px; margin:10px 0px;">
  				<form action="/modify.jsp" method="post">
  					<input type="hidden" name="data" value="<%=data %>">
  					<input type="hidden" name="managerLogin" value="<%=request.getAttribute("managerLogin") %>">
  					<input type="submit" value="�o�^���C��">
  				</form>
  			</td>
  		</tr>
  		<tr>
  			<td><input type="submit" value="����&#13;&#10;�ꗗ"></td>
  			<td>����</td>
  			<td>���g�񂾉ۑ�</td>
  			<td>����</td>
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
  			<td align="center" colspan="4" style="margin:15px 0px;"><input type="submit" value="���M�I" style="margin=: 10px 0px; padding: 5px 140px;"></td>
  		</tr>
  		</form>
  		<%=error %>
  		<%=reportFinishTimeToday %>

  	</table>
  </body>
</html>
