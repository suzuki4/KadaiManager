package database;

import java.io.IOException;
import java.util.ArrayList;
import java.util.TreeMap;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        String userName = req.getParameter("userName");
        String pass = req.getParameter("pass");
        int grade  = Integer.parseInt(req.getParameter("grade"));
        String email = req.getParameter("email");
        StudentData data = new StudentData(id, userName, pass, grade, email);
        PersistenceManager pm = PMF.get().getPersistenceManager();
        try {
            pm.makePersistent(data);
        } finally {
            pm.close();
        }
        resp.sendRedirect("/add.html");
    }
}
