package database;


import java.io.IOException;

import javax.jdo.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ManagerDataAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //ManagerData�쐬
    	ManagerData data = new ManagerData(1L, "", "");
    	
    	//PMF�Z�b�g
    	PersistenceManager pm = PMF.get().getPersistenceManager();
        pm.makePersistent(data);
        pm.close();
    }
}
