package database;

import other.InputCheck;

import java.io.IOException;
import java.util.*;

import javax.jdo.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class StudentDataAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;   
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("no url...");
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //PMF�Z�b�g���Ă���
    	PersistenceManager pm;
    	
    	//���͂��`�F�b�N
        String message = "";
        //id���`�F�b�N
        String idString = request.getParameter("id");
        Long id = -1L;
        if(InputCheck.isId(idString)) {
        	id = Long.parseLong(idString);
        	//data��ID�����邩�`�F�b�N
        	pm = PMF.get().getPersistenceManager();
        	Query query = pm.newQuery(StudentData.class);
        	query.setFilter("id == " + id);
        	if(!((List<StudentData>) query.execute()).isEmpty()) {
            	message += "�g�p�ς�ID�Ȃ̂ŕ�ID����͂��邱�ƁI\n";        		
        	}
        	pm.close();
        } else {
        	message += "���kID�͔��p���l�ɂ��邱�ƁI\n";
    	}
        //userName���`�F�b�N
        String userName = request.getParameter("userName");
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
        String gradeString = request.getParameter("grade");
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
        //���̓~�X������ꍇ
        if(!message.equals("")) {
        	//�t�H�[���̃o�����[���������邽�߂Ƀ��N�G�X�g�ɕԂ��Ă�����
        	request.setAttribute("inputId", idString);
        	request.setAttribute("inputUserName", userName);
        	request.setAttribute("inputGrade", gradeString);
        	request.setAttribute("inputEmail", email);
            dispatch(request, response, message);
        //���͂��������ꍇ
        } else {
	        StudentData data = new StudentData(id, userName, pass, grade, email);
	        data.setReportNameList(new ArrayList<String>());
	        data.setReportMinutesList(new ArrayList<Integer>());
	        data.setReportFinishTimeList(new ArrayList<Date>());
	        pm = PMF.get().getPersistenceManager();
	        pm.makePersistent(data);
	        pm.close();
	        //�o�^���[�����M
	        String contents = userName + " �l\n"
	        				+ "\n"
	        				+ "�ѐ�ł��B�ۑ�Ǘ��V�X�e���ւ悤�����I\n"
							+ "���[���A�h���X��V�����o�^���܂����B\n"
	        				+ "���Ȃ��̃��O�C��ID�́u" + id + "�v�ł��B\n"
	        				+ "�����p�X���[�h�͔ѐ�܂ł��q�˂��������B\n"
							+ "�g�Ɋo�����Ȃ��l�͈ȉ��̃A�h���X�܂ł��A�����������B\n"
							+ "\n"
							+ "fukasawa@reorjuku.jp"
							;
	        new other.registerMail(email, "Registration", contents).sendMail();
	        dispatch(request, response, "���k�f�[�^�̒ǉ�����");
        }
    }
    
    //dispatcher���\�b�h
    void dispatch(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
    	RequestDispatcher dispatcher;
        dispatcher = request.getRequestDispatcher("add.jsp");
    	request.setAttribute("info", message);
    	dispatcher.forward(request, response);
    } 
}
