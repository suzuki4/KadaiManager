package login;

import java.io.IOException;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import database.*;

public class ManagerLoginServlet extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//index.jsp������ł���
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");	
		
		//�`�F�b�N���Ĕ�΂�
		String error = "";
		RequestDispatcher dispatcher;
		try {
			if(id.equals("iikawa") && pass.equals("kiwi")) {
				dispatcher = request.getRequestDispatcher("studentList.jsp");
	        	request.setAttribute("id", id);
	        	request.setAttribute("pass", pass);
	           	dispatcher.forward(request, response);
	        }
        } catch(Exception e) {
        	error += e.toString();
        }   
		dispatcher = request.getRequestDispatcher("manager.jsp");
   	 	request.setAttribute("fail", "���O�C�����s\n" + error);
   	 	dispatcher.forward(request, response); 
	}
}
