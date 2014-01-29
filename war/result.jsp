<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.io.*"%>
<%@ page import="database.*"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="other.*"%>

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
/*	//������data�擾
	pm = PMF.get().getPersistenceManager();
	query = pm.newQuery(StudentData.class);
	query.setFilter("id == " + id);
	StudentData data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	pm.close();
*/
	//period���L��ꍇ�i�f�t�H���g�͖�����lastDay�O�����сj
	String period = Period.LASTDAY;
	if(request.getParameter("period") != null) {
		period = request.getParameter("period");
	}
	//resultPeriodFormat�ݒ�
	SimpleDateFormat resultPeriodFormat = new SimpleDateFormat("yyyy'�N'MM'��'dd'��('E')'", Locale.JAPAN);
	//resultPeriod�istartDate, endDate, dateString�j���擾
	ResultPeriod resultPeriod = new ResultPeriod(period, resultPeriodFormat);
	//resultDataString�擾
	String resultDataString = resultDataString(studentDataList, resultPeriod);
	
%>	

<%!
	String resultDataString(List<StudentData> studentDataList, ResultPeriod resultPeriod) {
		////�e���k���Ƃ̊w�N�A���O�A���v�����A���ϕ������i�[����RankingData��value�Ƃ���TreeMap�쐬
		TreeMap<Long, RankingData> rankingMap = new TreeMap<Long, RankingData>();
		//�O���t�p��total�̍ő�l�����߂�totalList�̍쐬
		ArrayList<Integer> totalList = new ArrayList<Integer>();
		//�S���k�f�[�^���`�F�b�N
		StudentData eachData;
		for(int i = 0; i < studentDataList.size(); i++) {
			eachData = studentDataList.get(i);
			int total = 0;
			//���|�[�g���L��ꍇ
			if(eachData.getReportNameList() != null) {
				//�S���|�[�g���`�F�b�N
				for(int j = 0; j < eachData.getReportNameList().size(); j++) {
					//�Y���L��
					if(resultPeriod.getStartDate().before(eachData.getReportFinishTimeList().get(j)) && eachData.getReportFinishTimeList().get(j).before(resultPeriod.getEndDate())) {
						total += eachData.getReportMinutesList().get(j);
					}
				}
			}
			totalList.add(total);
			//RankingData���쐬���Ċi�[
			RankingData rankingData = new RankingData(eachData.getGrade(), eachData.getUserName(), total, total / (total != 0 ? resultPeriod.getNumberOfDate() : -1));
			//�����L���O�\���pTreeMap��key�擾
			Long key = (long) total * 100000 * 100000 + eachData.getId();
			//put
			rankingMap.put(key, rankingData);
		}
		
		//���v�����̍ő�l��100�Ƃ����O���t�W�����擾
		double graphParameter;
		if(Collections.max(totalList) != 0) {
			graphParameter = 100.0 / Collections.max(totalList);
		} else {
			graphParameter = 0;
		}
		
		//�e���k���Ƃɕ\�����e���i�[
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
    <title>����</title>
  </head>

  <body>
	<div align="center">
		���ԁF<%=resultPeriod.getDateString() %>
	</div>
	<p></p>
	<div align="center">
		<form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="�O������">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="<%=Period.LASTWEEK %>">
            <input type="submit" value="�O�T����">
        </form>
        <form method="post" action="/result.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="hidden" name="period" value="<%=Period.LASTMONTH %>">
            <input type="submit" value="�O������">
        </form>
        <form method="post" action="/report.jsp" style="display: inline;">
            <input type="hidden" name="id" value="<%=id %>">
            <input type="submit" value="�߂�">
        </form>
	</div>
	<p></p>
  	<table border="1" align="center">
  		<tr>
  			<td>�w�N</td>
  			<td>���k��</td>
  			<td>�O���t</td>
  			<td>���v���Ԑ�(��)</td>
  			<td>1������</td>
  		</tr>
  		<%=resultDataString %>
  	</table>
  </body>
</html>