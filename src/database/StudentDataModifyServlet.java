package database;

import other.InputCheck;

import java.io.IOException;
import java.util.*;

import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class StudentDataModifyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {    	
    	//�L��Ȃ�managerLogin���󂯎����setAttribute
    	if(request.getParameter("managerLogin") != null) {
    		request.setAttribute("managerLogin", request.getParameter("managerLogin"));
    	}
    	//PMF�Z�b�g���Ă���
    	PersistenceManager pm;
    	Query query;
    	//studentData���Z�b�g���Ă���
    	StudentData data = null;
    	
    //���͂��`�F�b�N
        String message = "";
       //id���`�F�b�N
        String idString = "";
        Long id = -1L;
        //id�ύX����ꍇ�iid���ł��āA����oldId�łȂ��ꍇ�j
        if(request.getParameter("id") != null && !request.getParameter("id").equals(request.getParameter("oldId"))) {
	        idString = request.getParameter("id");
	        if(InputCheck.isId(idString)) {
	        	id = Long.parseLong(idString);
	        	//data��ID�����邩�`�F�b�N
	        	pm = PMF.get().getPersistenceManager();
	        	query = pm.newQuery(StudentData.class);
	        	query.setFilter("id == " + id);
	        	if(!((List<StudentData>) query.execute()).isEmpty()) {
	            	message += "�g�p�ς�ID�Ȃ̂ŕ�ID����͂��邱�ƁI\n";        		
	        	}
	        	pm.close();
	        } else {
	        	message += "���kID�͔��p���l�ɂ��邱�ƁI\n";
	    	}
	    //id�ύX�Ȃ��ꍇ
        } else {
	        idString = request.getParameter("oldId");        	
	        id = Long.parseLong(idString);
	        //data�擾
	    	pm = PMF.get().getPersistenceManager();
	    	query = pm.newQuery(StudentData.class);
	    	query.setFilter("id == " + id);
	    	data = ((List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute())).get(0);
	    	pm.close();
        }
        //userName���`�F�b�N
        String userName = request.getParameter("userName") != null ? request.getParameter("userName") : data.getUserName();
        if(!InputCheck.isUserName(userName)) {
        	message += "���k�������邱�ƁI\n";
        }
        //pass���`�F�b�N
        String pass = request.getParameter("pass");
        if(!InputCheck.isPassWord(pass)) {
        	message += "�p�X���[�h�͔��p�p���E�����݂̂��g�����ƁI\n";
        } else if(pass.length() < 4) {
        	message += "�p�X���[�h��4�����ȏ�ɂ��邱�ƁI\n";
        }
        //grade���`�F�b�N
        String gradeString = request.getParameter("grade") != null ? request.getParameter("grade") : String.valueOf(data.getGrade());
        int grade = -1;
        if(InputCheck.isGrade(gradeString)) {
        	grade  = Integer.parseInt(gradeString);
        } else {
        	message += "�w�N��4���̔��p���l�ɂ��邱�ƁI\n";
    	}
        //email���`�F�b�N
        String email = request.getParameter("email");
        if(!InputCheck.isEmail(email)) {
        	message += "E���[�������������ƁI\n";
        }
    	//�t�H�[���̃o�����[���������邽�߂Ƀ��N�G�X�g�ɕԂ��Ă�����
    	request.setAttribute("inputId", idString);
    	request.setAttribute("inputPass", pass);
    	request.setAttribute("inputUserName", userName);
    	request.setAttribute("inputGrade", gradeString);
    	request.setAttribute("inputEmail", email);
        //���̓~�X������ꍇ
        if(!message.equals("")) {
            dispatch(request, response, message);
        //���͂��������ꍇ
        } else {
        	pm = PMF.get().getPersistenceManager();
        	data = (StudentData)pm.getObjectById(StudentData.class, id);
	        data.setPass(pass);
	        data.setUserName(userName);
	        data.setGrade(grade);
	        data.setEmail(email);
	       	//id�X�V���͌Â��f�[�^���폜
	    	if(request.getParameter("id") != null && !request.getParameter("id").equals(request.getParameter("oldId"))) {
		    	data = (StudentData)pm.getObjectById(StudentData.class, Long.parseLong(request.getParameter("oldId")));
		    	pm.deletePersistent(data);
	    	}
	        pm.close();
	        dispatch(request, response, "���k�f�[�^�̏C������");
        }
    }
    
    //dispatcher���\�b�h
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("modify.jsp");
    	request.setAttribute("info", message);
    	dispatcher.forward(request, response);
    } 
}
