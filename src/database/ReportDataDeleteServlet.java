package database;

import other.InputCheck;

import java.io.IOException;
import java.util.*;

import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ReportDataDeleteServlet extends HttpServlet {
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
    	//data取得
    	PersistenceManager pm = PMF.get().getPersistenceManager();
    	StudentData data = (StudentData)pm.getObjectById(StudentData.class, id);
	    	//reportFinishTimeList削除
			ArrayList<Date> reportFinishTimeList = data.getReportFinishTimeList();
			reportFinishTimeList.remove(reportNumber);
	    	data.setReportFinishTimeList(reportFinishTimeList);
	    	//reportNameList削除
			ArrayList<String> reportNameList = data.getReportNameList();
	    	reportNameList.remove(reportNumber);
	    	data.setReportNameList(reportNameList);
	    	//reportMinutesList削除
			ArrayList<Integer> reportMinutesList = data.getReportMinutesList();
	    	reportMinutesList.remove(reportNumber);
	    	data.setReportMinutesList(reportMinutesList);
	    pm.close();
    	//成功の旨を返す
	    dispatch(request, response, "課題データ削除成功！");
    }

	//dispatcherメソッド
	void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
		RequestDispatcher dispatcher;
	    dispatcher = request.getRequestDispatcher("reportList.jsp");
	    request.setAttribute("managerLogin", true);
		request.setAttribute("info", message);
		dispatcher.forward(request, response);
	}
}
