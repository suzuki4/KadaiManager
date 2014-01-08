package database;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

import javax.jdo.annotations.*;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class StudentData implements Serializable {
	private static final long serialVersionUID = 1L;

	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;

	@Persistent
	private String userName;
	@Persistent
	private String pass;
	@Persistent
	private int grade;
	@Persistent
	private String email;
    @Persistent
    private ArrayList<String> reportNameList;
    @Persistent
    private ArrayList<Integer> reportMinutesList;
    @Persistent
    private ArrayList<Date> reportFinishTimeList;
        
	public StudentData(Long id, String userName, String pass, int grade, String email) {
		super();
		this.id = id;
		this.userName = userName;
		this.pass = pass;
		this.grade = grade;
		this.email = email;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public ArrayList<String> getReportNameList() {
		return reportNameList;
	}

	public void setReportNameList(ArrayList<String> reportNameList) {
		this.reportNameList = reportNameList;
	}

	public ArrayList<Integer> getReportMinutesList() {
		return reportMinutesList;
	}

	public void setReportMinutesList(ArrayList<Integer> reportMinutesList) {
		this.reportMinutesList = reportMinutesList;
	}

	public ArrayList<Date> getReportFinishTimeList() {
		return reportFinishTimeList;
	}

	public void setReportFinishTimeList(ArrayList<Date> reportFinishTimeList) {
		this.reportFinishTimeList = reportFinishTimeList;
	}
}
