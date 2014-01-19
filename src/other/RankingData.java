package other;

public class RankingData {
	//field
	private int grade;
	private String userName;
	private int total;
	private int average;

	//constructor
	public RankingData(int grade, String userName, int total, int average) {
		this.grade = grade;
		this.userName = userName;
		this.total = total;
		this.average = average;
	}

	//getter
	public int getGrade() {
		return grade;
	}

	public String getUserName() {
		return userName;
	}

	public int getTotal() {
		return total;
	}

	public int getAverage() {
		return average;
	}
	
}
