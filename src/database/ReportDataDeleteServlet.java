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
    	//id�擾
    	Long id = Long.parseLong(request.getParameter("id"));
    	request.setAttribute("id", id);
    	//�ۑ�ԍ��擾
    	int reportNumber = Integer.parseInt(request.getParameter("reportNumber"));
    	//data�擾
    	PersistenceManager pm = PMF.get().getPersistenceManager();
    	StudentData data = (StudentData)pm.getObjectById(StudentData.class, id);
	    	//reportFinishTimeList�폜
			ArrayList<Date> reportFinishTimeList = data.getReportFinishTimeList();
			reportFinishTimeList.remove(reportNumber);
	    	data.setReportFinishTimeList(reportFinishTimeList);
	    	//reportNameList�폜
			ArrayList<String> reportNameList = data.getReportNameList();
	    	reportNameList.remove(reportNumber);
	    	data.setReportNameList(reportNameList);
	    	//reportMinutesList�폜
			ArrayList<Integer> reportMinutesList = data.getReportMinutesList();
	    	reportMinutesList.remove(reportNumber);
	    	data.setReportMinutesList(reportMinutesList);
	    pm.close();
    	//�����̎|��Ԃ�
	    dispatch(request, response, "�ۑ�f�[�^�폜�����I");
    }

	//dispatcher���\�b�h
	void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
		RequestDispatcher dispatcher;
	    dispatcher = request.getRequestDispatcher("reportList.jsp");
	    request.setAttribute("managerLogin", true);
		request.setAttribute("info", message);
		dispatcher.forward(request, response);
	}
}
