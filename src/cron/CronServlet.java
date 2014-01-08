package cron;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.jdo.Query;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import database.*;

public class CronServlet extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//StudentDataList�擾
		PersistenceManager pm = PMF.get().getPersistenceManager();
		Query query = pm.newQuery("select from " + StudentData.class.getName());
		List<StudentData> studentDataList = (List<StudentData>)pm.detachCopyAll((List<StudentData>)query.execute());
		//status�擾
		query = pm.newQuery(StatusData.class);
		query.setFilter("id == 1");
		StatusData statusData = ((List<StatusData>)pm.detachCopyAll((List<StatusData>)query.execute())).get(0);
		pm.close();
		//restIds�擾
		ArrayList<Long> restIds = null;
		if(statusData != null) restIds = statusData.getRestIds();
		//cronRunTime�擾
		Date cronRunTime = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 9);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");	
		String cronRunTimeString = sdf.format(cronRunTime);
		
		//�����E�{���Z�b�g
		String subject = "�G���[";
		String contents = "�G���[";
		switch(request.getPathInfo()) {
		case "/2200":
			subject = "�������撣�낤";
			contents = "�������񍐎��s�E�񍐂��肢���܂��B�撣�낤�I�I";
			break;
		case "/2230":
			subject = "����";
			contents = "����Ă�����񍐂����܂��傤�B";
			break;
		case "/2300":
			subject = "���ǂ���";
			contents = "�܂��񍐂����Ă��܂���B���܂��傤�B";
			break;
		case "/2330":
			subject = "�R���I";
			contents = "����Ă��������I����Ă��������I����Ă��������I����Ă��������I����Ă��������I";
		}
		//���[�����M
		Properties props = new Properties();
        Session session = Session.getDefaultInstance(props, null);
 
        try {
            Message msg = new MimeMessage(session);
 
            //���M�����F���[���A�h���X�A���O
            msg.setFrom(new InternetAddress("hiroaki.4.suzuki@gmail.com", "iikawa"));
 
            //���M����
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress("hiroaki.4.suzuki@gmail.com", ""));
            
            //BCC
            StudentData data;
            int numberOfReport;
            for(int i = 0; i < studentDataList.size(); i++) {
            	data = studentDataList.get(i);
            	//report���Ȃ��Ȃ�0�A����Ȃ�size()
            	numberOfReport = 0;
            	if(data.getReportNameList() != null) numberOfReport = data.getReportNameList().size();
            	//report������AcronRunTime�̓��t�ƍŐV��reportFinishTime�̓��t����v����Ȃ烁�[�����Ȃ��icontinue�j
            	if(numberOfReport > 0 && sdf.format(data.getReportFinishTimeList().get(numberOfReport - 1)).equals(cronRunTimeString)) continue;
            	msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(studentDataList.get(i).getEmail(), "ID:" + studentDataList.get(i).getId()));
            }
            
            //�^�C�g���Ɩ{��
            ((MimeMessage) msg).setSubject(subject, "Shift_JIS");
            msg.setText(contents);
            Transport.send(msg);
 
        } catch (AddressException e) {
            //�A�h���X�s����
        } catch (MessagingException e) {
            //�ڑ����s���̏���
        }
		
	}
}
