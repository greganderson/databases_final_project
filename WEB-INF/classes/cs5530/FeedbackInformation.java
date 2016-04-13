package cs5530;

import java.util.Map;

public class FeedbackInformation {
	public Map<Integer, FeedbackData> feedbackDataSet;
	public Map<String, String> usernameToFullName;
	public Map<Integer, String> pidToPOIName;

	public FeedbackInformation(Map<Integer, FeedbackData> fbds, Map<String, String> untfn, Map<Integer, String> ptpn) {
		feedbackDataSet = fbds;
		usernameToFullName = untfn;
		pidToPOIName = ptpn;
	}
}
