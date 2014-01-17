<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>

<%@ page language="java" contentType="text/html; charset=Shift_JIS" pageEncoding="Shift_JIS"%>

<%
	//id�擾
	Long id = -1L;
	if(request.getParameter("id") != null) {
		id = Long.parseLong(request.getParameter("id"));
	} else if(request.getAttribute("id") != null) {
		id = (Long) request.getAttribute("id");
	}
	//studentData�擾
	PersistenceManager pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery("select from " + StudentData.class.getName());
	List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
	pm.close();
	//������data�擾
	pm = PMF.get().getPersistenceManager();
	query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
	//period���L��ꍇ�i�f�t�H���g�͖�����lastDay�O�����сj
	String period = "lastDay";
	if(request.getParameter("period") != null) {
		period = request.getParameter("period");
	}
	//resultDateFormat�ݒ�
	SimpleDateFormat resultDateFormat = new SimpleDateFormat("yyyy'�N'MM'��'dd'��('E') 'HH':'mm", Locale.JAPAN);
	//���t�v�Z�p�t�H�[�}�b�g
	SimpleDateFormat resultDateCompareFormat = new SimpleDateFormat("yyyyMMdd");
	SimpleDateFormat resultMonthCompareFormat = new SimpleDateFormat("yyyyMM");
	//resultDate�擾
	Date resultDate = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
	//resultDate���r�pString��
	String resultDateCompareString = resultDateCompareFormat.format(resultDate.getTime() - 1000 * 60 * 60 * 24);
	//eachDataString
	String eachDataString = "";
	for(int i = 0; i < studentDataList.size(); i++) {
		StudentData eachData = studentDataList.get(i);
		//���v�����v�Z
		int total = 0;
		int average = 0;
			//���|�[�g���inumberOfReport�j�擾
			int numberOfReport = 0;
			if(eachData.getReportNameList() != null) numberOfReport = eachData.getReportNameList().size();		
			//
			//�v�Z���Ԃɂ���ĕ���
			Calendar calendar;
			int j;
			switch(period) {
			case "lastDay":
				for(j = 0; j < numberOfReport; j++) {
					//�Y������ꍇ
					if(resultDateCompareFormat.format(eachData.getReportFinishTimeList().get(j)).equals(resultDateCompareString)) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
				average = total;
				break;
			case "lastWeek":
				//�v�Z�T���͂���
				calendar = Calendar.getInstance(Locale.JAPAN);
				int adjust = 1 - Calendar.DAY_OF_WEEK - 7;
				calendar.set(Calendar.YEAR, Calendar.MONTH, Calendar.DATE + adjust);
				Date startDate = calendar.getTime();
				Date endDate = new Date(startDate.getTime() + 1000 * 60 * 60 * 24 * 7);
				for(j = 0; j < numberOfReport; j++) {
					//�Y������ꍇ
					if(eachData.getReportFinishTimeList().get(j).after(new Date(startDate.getTime() - 1)) && eachData.getReportFinishTimeList().get(j).before(endDate)) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
				average = total / 7;
				break;
			case "lastMonth":
				//�v�Z�����͂���
				calendar = Calendar.getInstance(Locale.JAPAN);
				calendar.add(Calendar.MONTH, -1);
				calendar.set(Calendar.YEAR, Calendar.MONTH, Calendar.DATE);
				String resultMonthCompareString = resultMonthCompareFormat.format(calendar.getTime());
				for(j = 0; j < numberOfReport; j++) {
					//�Y������ꍇ
					if(resultMonthCompareFormat.format(eachData.getReportFinishTimeList().get(j)).equals(resultMonthCompareString)) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
				average = total / calendar.getActualMaximum(Calendar.DATE);
				break;
			}		
		//�e���k���Ƃɕ\��
		eachDataString 	+=	"<tr>"
						+		"<td>"
						+			eachData.getGrade()
						+		"</td>"
						+		"<td>"
						+			eachData.getUserName()
						+		"</td>"
						+		"<td>"
						+			"�O���t"
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
    <title>����</title>
  </head>

  <body>
	<div align="center">
		���ԁF<%="resultPeriod" %>
	</div>
	<div align="center">
		<form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="�O������">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="lastWeek">
            <input type="submit" value="�O�T����">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="lastMonth">
            <input type="submit" value="�O������">
        </form>
        <form method="post" action="/report.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="�߂�">
        </form>
	</div>
  	<table border="1" align="center">
  		<tr>
  			<td>�w�N</td>
  			<td>���k��</td>
  			<td>�O���t</td>
  			<td>���v����</td>
  			<td>1������</td>
  		</tr>
  		<%=eachDataString %>
  	</table>
  </body>
</html>