package cs5530;

public class POIInformation {
	public String name;
	public String address;
	public String url;
	public String phoneNumber;
	public String pricePerPerson;
	public String yearEstablished;
	public String hours;
	public String category;
	public String averageFeedbackScore;
	
	public POIInformation(String name, String address, String url, String phoneNumber, String pricePerPerson, String yearEstablished, String hours, String category, String averageFeedbackScore) {
		this.name = name;
		this.address = address;
		this.url = url;
		this.phoneNumber = phoneNumber;
		this.pricePerPerson = pricePerPerson;
		this.yearEstablished = yearEstablished;
		this.hours = hours;
		this.category = category;
		this.averageFeedbackScore = averageFeedbackScore;
	}
}
