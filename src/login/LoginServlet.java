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

public class LoginServlet extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//index.jsp������ł���
		String id = request.getParameter("id");
		String pass = request.getParameter("pass");	
		
		//�f�[�^�X�g�A�A�N�Z�X����
		PersistenceManagerFactory factory = PMF.get();
        PersistenceManager manager = factory.getPersistenceManager();
        StudentData data = null;
        
        //Dispatch����
        RequestDispatcher dispatcher;
        
        //�f�[�^�X�g�A����ID����
        try {
        	data = (StudentData)manager.getObjectById(StudentData.class,Long.parseLong(id));        	
        	//�p�X�`�F�b�N
        	if(data.getPass().equals(pass)) {
        		/*
        		//�Z�b�V�����쐬
        		HttpSession session = request.getSession();
        		session.setAttribute("data", data);
        		manager.close();
        		//dispatcher = request.getRequestDispatcher("report.jsp");
           	 	//dispatcher.forward(request, response);
        		session.setAttribute("test", "testtest");
        		java.util.logging.Logger.getLogger(LoginServlet.class.getName()).warning(session.getId());
        		response.sendRedirect("/report.jsp");
        		*/
        		manager.close();
        		dispatcher = request.getRequestDispatcher("report.jsp");
        		request.setAttribute("id", Integer.parseInt(id));
           	 	dispatcher.forward(request, response);
            }
        } catch(Exception e) {
        	
        }       	
        manager.close();
   	 	dispatcher = request.getRequestDispatcher("index.jsp");
   	 	request.setAttribute("fail", "���O�C�����s");
   	 	dispatcher.forward(request, response);
	}
}
