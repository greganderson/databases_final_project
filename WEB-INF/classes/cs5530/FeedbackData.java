package cs5530;

public class FeedbackData {
	public int fid;
	public int pid;
	public String username;
	public int score;
	public String text;
	public java.sql.Date date;

	public FeedbackData(int fid, int pid, String username, int score, String text, java.sql.Date date) {
		this.fid = fid;
		this.pid = pid;
		this.username = username;
		this.score = score;
		this.text = text;
		this.date = date;
	}
}
