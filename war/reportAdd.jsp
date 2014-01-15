<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="java.text.*"%>
<%@ page import="database.*"%>
<%@ page import="java.util.*"%>

<%
	//id�擾
	Long id = -1L;
	if(request.getParameter("id") != null) {
		id = Long.parseLong(request.getParameter("id"));
	} else if(request.getAttribute("id") != null) {
		id = (Long) request.getAttribute("id");
	}
	//data�擾
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
	//���k���擾
	String userName = data.getUserName();
	//�ۑ���������l�Ȃ�
	String reportFinishTimeYear = "";
	String reportFinishTimeMonth = "";
	String reportFinishTimeDay = "";
	String reportFinishTimeHour = "";
	String reportFinishTimeMinute = "";
	//�ۑ薼�����l�Ȃ�
	String reportName = "";
	//���������l����
	String reportMinutes = "";
	//���̓~�X�Ŗ߂��Ă����ꍇ
	if(request.getAttribute("reportName") != null) {
		reportFinishTimeYear = (String) request.getAttribute("reportFinishTimeYear");
		reportFinishTimeMonth = (String) request.getAttribute("reportFinishTimeMonth");
		reportFinishTimeDay = (String) request.getAttribute("reportFinishTimeDay");
		reportFinishTimeHour = (String) request.getAttribute("reportFinishTimeHour");
		reportFinishTimeMinute = (String) request.getAttribute("reportFinishTimeMinute");
		reportName = (String) request.getAttribute("reportName");
		reportMinutes = (String) request.getAttribute("reportMinutes");
	}
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
        <title>�ۑ�f�[�^�̒ǉ�</title>
    </head>
    <body>
        <h1>�ۑ�f�[�^�̒ǉ�</h1>
        <table>
        <form method="post" action="/reportAdd" style="display: inline;">
            <input type="hidden" name="managerLogin" value="true">
        	<input type="hidden" name="id" value="<%=id %>">
            <tr><th>���kID:</th><td><input type="text" name="id" disabled value="<%=id %>" ></td></tr>
            <tr><th>���k��:</th><td><input type="text" name="userName" disabled value="<%=userName %>" ></td></tr>
            <tr><th>�ۑ����:</th>
            	<td>
            		<input type="text" name="reportFinishTimeYear" size="4" maxlength="4" value="<%=reportFinishTimeYear %>" >�N
            		<input type="text" name="reportFinishTimeMonth" size="2" maxlength="2" value="<%=reportFinishTimeMonth %>" >��
            		<input type="text" name="reportFinishTimeDay" size="2" maxlength="2" value="<%=reportFinishTimeDay %>" >���@
            		<input type="text" name="reportFinishTimeHour" size="2" maxlength="2" value="<%=reportFinishTimeHour %>" >�F
            		<input type="text" name="reportFinishTimeMinute" size="2" maxlength="2" value="<%=reportFinishTimeMinute %>" >
            	</td>
            </tr>
            <tr><th>�ۑ薼:</th><td><input type="text" name="reportName" value="<%=reportName %>" ></td></tr>
            <tr><th>����:</th><td><input type="text" name="reportMinutes" value="<%=reportMinutes %>" ></td></tr>
            <tr><th></th>
            	<td nowrap>
            		<input type="submit" value="�ǉ�">
      	</form>
            		<form method="post" action="/reportList.jsp" style="display: inline;">
                        <input type="hidden" name="managerLogin" value="true">
            			<input type="hidden" name="selectId" value="<%=id %>">
            			<input type="submit" value="�߂�">
            		</form>
            	</td>
            </tr>
            <tr style="color:#FF0000; font-weight:bold; margin=:15px 0px;">
            	<th>
            	</th>
            	<td>
	  				<%=request.getAttribute("info") != null ? request.getAttribute("info"): "" %>
				</td>
			</tr>
        </table>
    </body>
</html>