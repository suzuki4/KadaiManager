package database;

import java.io.IOException;
import java.util.ArrayList;
import java.util.TreeMap;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class StudentDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String userName = request.getParameter("userName");
        String pass = request.getParameter("pass");
        int grade  = Integer.parseInt(request.getParameter("grade"));
        String email = request.getParameter("email");
        StudentData data = new StudentData(id, userName, pass, grade, email);
        PersistenceManager pm = PMF.get().getPersistenceManager();
        try {
            pm.makePersistent(data);
        } finally {
            pm.close();
        }
        dispatch(request, response, "í«â¡ê¨å˜");
    }
    
    //dispatcherÉÅÉ\ÉbÉh
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("add.jsp");
    	request.setAttribute("fail", message);
    	dispatcher.forward(request, response);
    } 
}
