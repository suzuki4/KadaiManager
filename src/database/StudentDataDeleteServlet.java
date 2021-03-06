package database;

import other.InputCheck;

import java.io.IOException;
import java.util.*;

import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class StudentDataDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {    	
    	//idæ¾
    	Long id = Long.parseLong(request.getParameter("selectId"));
    	//í
    	PersistenceManager pm = PMF.get().getPersistenceManager();
    	StudentData data = (StudentData)pm.getObjectById(StudentData.class, id);
    	pm.deletePersistent(data);
    	pm.close();
    	
    	//ßé
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("studentList.jsp");
    	request.setAttribute("managerLogin", "true");
    	dispatcher.forward(request, response);
    } 
}
