package other;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class registerMail {
	//field
	String email;
	String subject;
	String contents;
	//field ���[�����M
	Properties props;
    Session session;
    
    //constructor
    public registerMail(String email, String subject, String contents) {
    	this.email = email;
    	this.subject = subject;
    	this.contents = contents;
    	this.props = new Properties();
    	this.session = Session.getDefaultInstance(props, null);
    }
    
    public void sendMail() {
	    try {
	    	Message msg = new MimeMessage(session);
		    //���M�����F���[���A�h���X�A���O
		    msg.setFrom(new InternetAddress("filmlife1226@gmail.com", "iikawa"));
		    //���M����
		    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email, ""));
		    //�^�C�g���Ɩ{��
		    ((MimeMessage) msg).setSubject(subject, "Shift_JIS");
		    msg.setText(contents);
		    //���M�I
		    Transport.send(msg);
	    } catch (AddressException e) {
	        //�A�h���X�s����
	    } catch (MessagingException e) {
	        //�ڑ����s���̏���
	    } catch (UnsupportedEncodingException e) {
			// TODO �����������ꂽ catch �u���b�N
		}
    }
}
