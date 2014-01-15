package database;

import java.io.IOException;
import java.util.*;
import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ReportDataAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {    	
    	//id�擾
    	Long id = Long.parseLong(request.getParameter("id"));
    	request.setAttribute("id", id);
    	//���͂��`�F�b�N
    	String message = "";
	    	//reportFinishTimeYear
			int reportFinishTimeYear = -1;
			if(request.getParameter("reportFinishTimeYear") == null) {
				message += "�ۑ�I���N����͂��邱�ƁI";
			} else {
				try {
	    			reportFinishTimeYear = Integer.parseInt(request.getParameter("reportFinishTimeYear"));    				
					if(reportFinishTimeYear < 1900) {
						message += "�ۑ�I���N�̐��l���m�F���邱�ƁI";
					}
				} catch(NumberFormatException e) {
	    			message += "�ۑ�I���N�𐔒l�œ��͂��邱�ƁI";    				
				}
			}
			//reportFinishTimeMonth
			int reportFinishTimeMonth = -1;
			if(request.getParameter("reportFinishTimeMonth") == null) {
				message += "�ۑ�I��������͂��邱�ƁI";
			} else {
				try {
	    			reportFinishTimeMonth = Integer.parseInt(request.getParameter("reportFinishTimeMonth"));    				
					if(reportFinishTimeMonth < 1 || 12 < reportFinishTimeMonth) {
						message += "�ۑ�I�����̐��l���m�F���邱�ƁI";
					}
				} catch(NumberFormatException e) {
	    			message += "�ۑ�I�����𐔒l�œ��͂��邱�ƁI";    				
				}
			}
			//reportFinishTimeDay
			int reportFinishTimeDay = -1;
			if(request.getParameter("reportFinishTimeDay") == null) {
				message += "�ۑ�I��������͂��邱�ƁI";
			} else {
				try {
	    			reportFinishTimeDay = Integer.parseInt(request.getParameter("reportFinishTimeDay"));    				
					//31���ȊO�̌��₤�邤�N�͖���
	    			if(reportFinishTimeDay < 1 || 31 < reportFinishTimeDay) {
						message += "�ۑ�I�����̐��l���m�F���邱�ƁI";
					}
				} catch(NumberFormatException e) {
	    			message += "�ۑ�I�����𐔒l�œ��͂��邱�ƁI";    				
				}
			}
			//reportFinishTimeHour
			int reportFinishTimeHour = -1;
			if(request.getParameter("reportFinishTimeHour") == null) {
				message += "�ۑ�I�����Ԃ���͂��邱�ƁI";
			} else {
				try {
	    			reportFinishTimeHour = Integer.parseInt(request.getParameter("reportFinishTimeHour"));    				
					if(reportFinishTimeHour < 0 || 24 <= reportFinishTimeHour) {
						message += "�ۑ�I�����Ԃ̐��l���m�F���邱�ƁI";
					}
				} catch(NumberFormatException e) {
	    			message += "�ۑ�I�����Ԃ𐔒l�œ��͂��邱�ƁI";    				
				}
			}
			//reportFinishTimeMinute
			int reportFinishTimeMinute = -1;
			if(request.getParameter("reportFinishTimeMinute") == null) {
				message += "�ۑ�I��������͂��邱�ƁI";
			} else {
				try {
	    			reportFinishTimeMinute = Integer.parseInt(request.getParameter("reportFinishTimeMinute"));    				
					if(reportFinishTimeMinute < 0 || 60 <= reportFinishTimeMinute) {
						message += "�ۑ�I�����̐��l���m�F���邱�ƁI";
					}
				} catch(NumberFormatException e) {
	    			message += "�ۑ�I�����𐔒l�œ��͂��邱�ƁI";    				
				}
			}
			//reportName
			String reportName = "";
			if(request.getParameter("reportName") == null || request.getParameter("reportName").equals("")) {
				message += "�ۑ薼����͂��邱�ƁI";
			} else {
	    		reportName = request.getParameter("reportName");
			}
			//reportMinutes
			int reportMinutes = -1;
			if(request.getParameter("reportMinutes") == null) {
				message += "��������͂��邱�ƁI";
			} else {
				try {
	    			reportMinutes = Integer.parseInt(request.getParameter("reportMinutes"));    				
					if(reportMinutes < 0 && 999 < reportMinutes) {
						message += "�����̐��l���m�F���邱�ƁI";
					}
				} catch(NumberFormatException e) {
	    			message += "�����𐔒l�œ��͂��邱�ƁI";    				
				}
			}			
		//���̓~�X������ꍇ
	    if(!message.equals("")) {
	    	request.setAttribute("reportFinishTimeYear", request.getParameter("reportFinishTimeYear"));
	    	request.setAttribute("reportFinishTimeMonth", request.getParameter("reportFinishTimeMonth"));
	    	request.setAttribute("reportFinishTimeDay", request.getParameter("reportFinishTimeDay"));
	    	request.setAttribute("reportFinishTimeHour", request.getParameter("reportFinishTimeHour"));
	    	request.setAttribute("reportFinishTimeMinute", request.getParameter("reportFinishTimeMinute"));
	    	request.setAttribute("reportName", request.getParameter("reportName"));
	    	request.setAttribute("reportMinutes", request.getParameter("reportMinutes"));
	    	dispatch(request, response, message, "/reportAdd.jsp");
	    //���̓~�X���Ȃ��ꍇ
	    } else {
    	//data�擾
    	PersistenceManager pm = PMF.get().getPersistenceManager();
    	StudentData data = (StudentData)pm.getObjectById(StudentData.class, id);
	    	//reportFinishTimeList�ǉ�
			ArrayList<Date> reportFinishTimeList = data.getReportFinishTimeList();
	    		//reportFinishTime�擾
				Calendar reportFinishTimeCalendar = Calendar.getInstance();
				reportFinishTimeCalendar.set(reportFinishTimeYear, reportFinishTimeMonth - 1, reportFinishTimeDay, reportFinishTimeHour, reportFinishTimeMinute);
				Date reportFinishTime = reportFinishTimeCalendar.getTime();
			reportFinishTimeList.add(reportFinishTime);
	    	data.setReportFinishTimeList(reportFinishTimeList);
	    	//reportNameList�ǉ�
			ArrayList<String> reportNameList = data.getReportNameList();
	    	reportNameList.add(reportName);
	    	data.setReportNameList(reportNameList);
	    	//reportMinutesList�ǉ�
			ArrayList<Integer> reportMinutesList = data.getReportMinutesList();
	    	reportMinutesList.add(reportMinutes);
	    	data.setReportMinutesList(reportMinutesList);
	    pm.close();
    	//�����̎|��Ԃ�
	    dispatch(request, response, "�ۑ�f�[�^�ǉ������I", "/reportList.jsp");
	    }
    }
    
    
    //dispatcher���\�b�h
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message, String link) throws ServletException, IOException {
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher(link);
        request.setAttribute("managerLogin", true);
    	request.setAttribute("info", message);
    	dispatcher.forward(request, response);
    } 
}
