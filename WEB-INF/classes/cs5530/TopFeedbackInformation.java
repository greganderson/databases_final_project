package cs5530;

public class TopFeedbackInformation {
	public String user;
	public String poiName;
	public String score;
	public String text;
	public String date;
	public String rating;
	
	public TopFeedbackInformation(String user, String poiName, String score, String text, String date, String rating) {
		this.user = user;
		this.poiName = poiName;
		this.score = score;
		this.text = text;
		this.date = date;
		this.rating = rating;
	}
}
