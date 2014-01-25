package login;

import java.io.IOException;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import database.ManagerData;
import database.PMF;

public class ManagerLoginServlet extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//manager.jspから飛んできた
		String userName = request.getParameter("userName");
		String pass = request.getParameter("pass");	
		
		//チェックして飛ばす
		String error = "";
		RequestDispatcher dispatcher;
		try {
			PersistenceManager pm = PMF.get().getPersistenceManager();
			Query query = pm.newQuery(ManagerData.class);
			query.setFilter("id == 1");
			ManagerData data = ((List<ManagerData>)pm.detachCopyAll((List<ManagerData>)query.execute())).get(0);
			pm.close();
			if(userName.equals(data.getUserName()) && pass.equals(data.getPass())) {
				dispatcher = request.getRequestDispatcher("studentList.jsp");
	        	request.setAttribute("userName", userName);
	        	request.setAttribute("pass", pass);
	           	dispatcher.forward(request, response);
	        }
        } catch(Exception e) {
        	error += e.toString();
        }   
		dispatcher = request.getRequestDispatcher("manager.jsp");
   	 	request.setAttribute("fail", "ログイン失敗\n" + error);
   	 	dispatcher.forward(request, response); 
	}
}
