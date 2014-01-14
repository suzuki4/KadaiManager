package database;

import java.io.IOException;
import java.util.*;
import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ReportDataModifyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {    	
    	//id取得
    	Long id = Long.parseLong(request.getParameter("id"));
    	request.setAttribute("id", id);
    	//課題番号取得
    	int reportNumber = Integer.parseInt(request.getParameter("reportNumber"));
    	//入力をチェック
    	String message = "";
	    	//reportFinishTimeYear
			int reportFinishTimeYear = -1;
			if(request.getParameter("reportFinishTimeYear") == null) {
				message += "課題終了年を入力すること！";
			} else {
				try {
	    			reportFinishTimeYear = Integer.parseInt(request.getParameter("reportFinishTimeYear"));    				
					if(reportFinishTimeYear < 1900) {
						message += "課題終了年の数値を確認すること！";
					}
				} catch(NumberFormatException e) {
	    			message += "課題終了年を数値で入力すること！";    				
				}
			}
			//reportFinishTimeMonth
			int reportFinishTimeMonth = -1;
			if(request.getParameter("reportFinishTimeMonth") == null) {
				message += "課題終了月を入力すること！";
			} else {
				try {
	    			reportFinishTimeMonth = Integer.parseInt(request.getParameter("reportFinishTimeMonth"));    				
					if(reportFinishTimeMonth < 1 || 12 < reportFinishTimeMonth) {
						message += "課題終了月の数値を確認すること！";
					}
				} catch(NumberFormatException e) {
	    			message += "課題終了月を数値で入力すること！";    				
				}
			}
			//reportFinishTimeDay
			int reportFinishTimeDay = -1;
			if(request.getParameter("reportFinishTimeDay") == null) {
				message += "課題終了日を入力すること！";
			} else {
				try {
	    			reportFinishTimeDay = Integer.parseInt(request.getParameter("reportFinishTimeDay"));    				
					//31日以外の月やうるう年は無視
	    			if(reportFinishTimeDay < 1 || 31 < reportFinishTimeDay) {
						message += "課題終了日の数値を確認すること！";
					}
				} catch(NumberFormatException e) {
	    			message += "課題終了日を数値で入力すること！";    				
				}
			}
			//reportFinishTimeHour
			int reportFinishTimeHour = -1;
			if(request.getParameter("reportFinishTimeHour") == null) {
				message += "課題終了時間を入力すること！";
			} else {
				try {
	    			reportFinishTimeHour = Integer.parseInt(request.getParameter("reportFinishTimeHour"));    				
					if(reportFinishTimeHour < 0 || 24 <= reportFinishTimeHour) {
						message += "課題終了時間の数値を確認すること！";
					}
				} catch(NumberFormatException e) {
	    			message += "課題終了時間を数値で入力すること！";    				
				}
			}
			//reportFinishTimeMinute
			int reportFinishTimeMinute = -1;
			if(request.getParameter("reportFinishTimeMinute") == null) {
				message += "課題終了分を入力すること！";
			} else {
				try {
	    			reportFinishTimeMinute = Integer.parseInt(request.getParameter("reportFinishTimeMinute"));    				
					if(reportFinishTimeMinute < 0 || 60 <= reportFinishTimeMinute) {
						message += "課題終了分の数値を確認すること！";
					}
				} catch(NumberFormatException e) {
	    			message += "課題終了分を数値で入力すること！";    				
				}
			}
			//reportName
			String reportName = "";
			if(request.getParameter("reportName") == null || request.getParameter("reportName").equals("")) {
				message += "課題名を入力すること！";
			} else {
	    		reportName = request.getParameter("reportName");
			}
			//reportMinutes
			int reportMinutes = -1;
			if(request.getParameter("reportMinutes") == null) {
				message += "分数を入力すること！";
			} else {
				try {
	    			reportMinutes = Integer.parseInt(request.getParameter("reportMinutes"));    				
					if(reportMinutes < 0 && 999 < reportMinutes) {
						message += "分数の数値を確認すること！";
					}
				} catch(NumberFormatException e) {
	    			message += "分数を数値で入力すること！";    				
				}
			}			
		//入力ミスがある場合
	    if(!message.equals("")) {
	    	request.setAttribute("reportFinishTimeYear", request.getAttribute("reportFinishTimeYear"));
	    	request.setAttribute("reportFinishTimeMonth", request.getAttribute("reportFinishTimeMonth"));
	    	request.setAttribute("reportFinishTimeDay", request.getAttribute("reportFinishTimeDay"));
	    	request.setAttribute("reportFinishTimeHour", request.getAttribute("reportFinishTimeHour"));
	    	request.setAttribute("reportFinishTimeMinute", request.getAttribute("reportFinishTimeMinute"));
	    	request.setAttribute("reportName", request.getAttribute("reportName"));
	    	request.setAttribute("reportMinutes", request.getAttribute("reportMinutes"));
	    	dispatch(request, response, message);
	    //入力ミスがない場合
	    } else {
    	//data取得
    	PersistenceManager pm = PMF.get().getPersistenceManager();
    	StudentData data = (StudentData)pm.getObjectById(StudentData.class, id);
	    	//reportFinishTimeList更新
			ArrayList<Date> reportFinishTimeList = data.getReportFinishTimeList();
	    		//reportFinishTime取得
				Calendar reportFinishTimeCalendar = Calendar.getInstance();
				reportFinishTimeCalendar.set(reportFinishTimeYear, reportFinishTimeMonth - 1, reportFinishTimeDay, reportFinishTimeHour, reportFinishTimeMinute);
				Date reportFinishTime = reportFinishTimeCalendar.getTime();
			reportFinishTimeList.set(reportNumber, reportFinishTime);
	    	data.setReportFinishTimeList(reportFinishTimeList);
	    	//reportNameList更新
			ArrayList<String> reportNameList = data.getReportNameList();
	    	reportNameList.set(reportNumber, reportName);
	    	data.setReportNameList(reportNameList);
	    	//reportMinutesList更新
			ArrayList<Integer> reportMinutesList = data.getReportMinutesList();
	    	reportMinutesList.set(reportNumber, reportMinutes);
	    	data.setReportMinutesList(reportMinutesList);
	    pm.close();
    	//成功の旨を返す
	    dispatch(request, response, "課題データ修正成功！");
	    }
    }
    
    
    //dispatcherメソッド
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("reportModify.jsp");
        request.setAttribute("managerLogin", true);
    	request.setAttribute("info", message);
    	dispatcher.forward(request, response);
    } 
}
