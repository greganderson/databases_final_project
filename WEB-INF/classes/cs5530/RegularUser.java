package cs5530;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.sql.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by greg on 3/16/16.
 */
public class RegularUser extends User {

    private String username;

    public RegularUser(String username) {
        this.username = username;
    }

    public static boolean createNewUser(Connection con) {
        Utils.QuestionSizePair usernameQSP = new Utils.QuestionSizePair("Username: ", 30);
        Utils.QuestionSizePair passwordQSP = new Utils.QuestionSizePair("Password: ", 30);
        Utils.QuestionSizePair fullnameQSP = new Utils.QuestionSizePair("Full name (e.g. John Psmythe): ", 40);
        Utils.QuestionSizePair addressQSP = new Utils.QuestionSizePair("Address (e.g. 123 S. 456 E. Beaver, UT 12345): ", 80);
        Utils.QuestionSizePair phone_numQSP = new Utils.QuestionSizePair("Phone number (e.g. 1234567890): ", 10, "Invalid phone number");

        String username = Utils.getUserInput(usernameQSP, false);
        String password = Utils.getUserInput(passwordQSP, false);
        String fullname = Utils.getUserInput(fullnameQSP, false);
        String address = Utils.getUserInput(addressQSP, false);
        String phone_num;
        while (true) {
            phone_num = Utils.getUserInput(phone_numQSP, true);
            if (phone_num.length() == 10)
                break;
            System.out.println(phone_numQSP.errorMessage);
        }

        String sql = "insert into Users values (?, ?, false, ?, ?, ?)";
        try {
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, fullname);
            preparedStatement.setString(3, password);
            preparedStatement.setString(4, address);
            preparedStatement.setString(5, phone_num);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (BatchUpdateException e) {
            System.out.println("Invalid username");
            return false;
        } catch (SQLException e) {
            System.out.println("Could not execute creating new user");
            return false;
        }
        return true;
    }

    public boolean recordNewVisit(Connection con, String poiName, String cost, String numOfPeople, String dateString) {
		Date date = null;
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
		try {
			date = new java.sql.Date(format.parse(dateString).getTime());
		} catch (ParseException e) {
			System.out.println("recordNewVisit: could not parse date");
			return false;
		}

		return recordNewVisitSql(con, poiName, cost, numOfPeople, date);
    }

    private boolean recordNewVisitSql(Connection con, String poiName, String cost, String numOfPeople, Date date) {
        try {
            String sql = "insert into VisitEvent (cost, num_of_people) values (?, ?)";
            PreparedStatement preparedStatement = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setInt(1, Integer.parseInt(cost));
            preparedStatement.setInt(2, Integer.parseInt(numOfPeople));
            preparedStatement.executeUpdate();

            ResultSet rs = preparedStatement.getGeneratedKeys();
            int vid = -1;
            if (rs.next())
                vid = rs.getInt(1);
            rs.close();

            sql = "insert into Visit values (?, (select pid from POI where name = ?), ?, ?)";
            preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, poiName);
            preparedStatement.setInt(3, vid);
            preparedStatement.setDate(4, date);
            preparedStatement.executeUpdate();
            preparedStatement.close();
			return true;
        } catch (SQLException e) {
            System.out.println("Could not execute recording new visit");
			return false;
        }
    }

    public boolean addFavoritePOI(Connection con, String poiName) {
        try {
            String sql = "insert into Favorites values (?, (select pid from POI where name = ?))";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, poiName);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not update favorite");
			return false;
        }
		return true;
    }

    public boolean provideFeedback(Connection con, String poiName, String scoreString, String feedback) {
		int score = Integer.parseInt(scoreString);
        try {
            // Check for duplicates
            String sql = "select count(*) from Feedback " +
                    "where pid = (select pid from POI where name = ?) and username = ?";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, poiName);
            preparedStatement.setString(2, username);
            ResultSet rs = preparedStatement.executeQuery();
            rs.first();
            if (rs.getInt(1) > 0) {
                System.out.println("Could not provide feedback for this POI, feedback from this user already exists");
                return false;
            }

            // No duplicates, so insert feedback
            sql = "insert into Feedback (pid, username, score, text, fbdate) values (" +
                    "(select pid from POI where name = ?), ?, ?, ?, CURDATE())";
            preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, poiName);
            preparedStatement.setString(2, username);
            preparedStatement.setInt(3, score);
            preparedStatement.setString(4, feedback);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not execute feedback creation");
			return false;
        }
		return true;
    }

	/**
	 * Returns feedbackDataset, usernameToFullName, and pidToPOIName as an array.
	 */
	public FeedbackInformation getFeedbackInformation(Connection con) {
        Map<Integer, FeedbackData> feedbackDataSet = new TreeMap<>();
        Map<String, String> usernameToFullName = new HashMap<>();
        Map<Integer, String> pidToPOIName = new HashMap<>();
        int i = 1;
        int c;
        int feedbackRating = 0;

        try {
            String sql = "select * from Feedback where username <> ?";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();
            int fid;
            int pid;
            String fb_username;
            int score;
            String text;
            java.sql.Date date;

            while (rs.next()) {
                fid = rs.getInt("fid");
                pid = rs.getInt("pid");
                fb_username = rs.getString("username");
                score = rs.getInt("score");
                text = rs.getString("text");
                date = rs.getDate("fbdate");
                feedbackDataSet.put(i++, new FeedbackData(fid, pid, fb_username, score, text, date));
            }

            Statement statement = con.createStatement();
            rs = statement.executeQuery("select distinct f.username, u.name from Feedback f, Users u where f.username = u.username");
            while (rs.next()) {
                usernameToFullName.put(rs.getString("username"), rs.getString("name"));
            }

            rs = statement.executeQuery("select distinct p.pid, p.name from POI p, Feedback f where p.pid = f.pid");
            while (rs.next()) {
                pidToPOIName.put(rs.getInt("pid"), rs.getString("name"));
            }
            rs.close();
            statement.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not rate feedback");
			return null;
        }
		return new FeedbackInformation(feedbackDataSet, usernameToFullName, pidToPOIName);
	}

    public void rateFeedbackSql(Connection con, int fid, int feedbackRating) {
        try {
            // Check if user already rated this feedback
            String sql = "select count(*) from Rates where username = ? and fid = ?";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setInt(2, fid);
            ResultSet rs = preparedStatement.executeQuery();
            rs.first();
            if (rs.getInt(1) > 0) {
                System.out.println("You have already rated this feedback");
                return;
            }

            sql = "insert into Rates values (?, ?, ?)";
            preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setInt(2, fid);
            preparedStatement.setInt(3, feedbackRating);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not add rating for feedback");
        }
    }

    public List<String> getListOfUsers(Connection con) {
        List<String> users = new ArrayList<>();
        try {
            String sql = "select name from Users where username <> ? and is_admin = false";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                users.add(rs.getString(1));
            }
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not declare user trust");
        }
		Collections.sort(users);
		return users;
    }

    public void declareUserTrustSql(Connection con, String userToTrust, int trustValue) {
        try {
            // Remove the trust if it was there before
            String sql = "delete from Trust where username1 = ? and username2 = (select username from Users where name = ?)";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, userToTrust);
            preparedStatement.executeUpdate();

            // Now add them to the table
            sql = "insert into Trust values (?, (select username from Users where name = ?), ?)";
            preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, userToTrust);
            preparedStatement.setInt(3, trustValue);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not declare user trust");
        }
    }

	public List<String> getListOfCategories(Connection con) {
		List<String> categories = new ArrayList<>();
		try {
			String sql = "select distinct category from POI";
			PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString(1));
            }
            rs.close();
			preparedStatement.close();
		} catch (SQLException e) {
			System.out.println("Could not get list of categories");
		}
		Collections.sort(categories);
		return categories;
	}

    public List<POIInformation> searchForPOI(Connection con, SearchObject searchObject) {
		List<POIInformation> pois = new ArrayList<>();
        try {
            PreparedStatement preparedStatement = con.prepareStatement(searchObject.sql);
            ResultSet rs = preparedStatement.executeQuery();
			while (rs.next()) {
				String name = rs.getString("name");
				String address = rs.getString("address");
				String url = rs.getString("url");
				String phone_num = rs.getString("phone_num");
				String price_per_person = rs.getString("price_per_person");
				String year_of_est = rs.getString("year_of_est");
				String hours = rs.getString("hours");
				String category = rs.getString("category");
				String score = "";
				if (searchObject.includeScore)
					score = rs.getString("score");
				POIInformation poi = new POIInformation(name, address, url, phone_num, price_per_person, year_of_est, hours, category, score);
				pois.add(poi);
			}

        } catch (SQLException e) {
            System.out.println("Could not get POI's based on query parameters");
        }
		return pois;
    }

    public void findTopNMostUsefulFeedbacks(Connection con) {
        Utils.QuestionSizePair topQSP = new Utils.QuestionSizePair("How many top feedbacks to view (e.g. 5): ", 10, "Invalid number");
        int top = Integer.parseInt(Utils.getUserInput(topQSP, true));

        try {
            String sql = "select u.name as username," +
                    " p.name as poi_name," +
                    " f.score as score," +
                    " f.text as text," +
                    " f.fbdate as fbdate," +
                    " avg(r.rating) as avg_rating from Feedback f, Rates r, POI p, Users u" +
                    " where f.fid = r.fid and f.pid = p.pid and f.username = u.username" +
                    " group by r.fid order by avg(r.rating) desc limit ?";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setInt(1, top);
            ResultSet rs = preparedStatement.executeQuery();
            System.out.println("Top " + top + " most useful feedbacks:");
            System.out.println("User | POI name | Feedback score | Text | Feedback date | Average usefulness rating");
            while (rs.next()) {
                String result = rs.getString("username") + " | " + rs.getString("poi_name") + " | ";
                result += rs.getString("score") + " | " + rs.getString("text") + " | ";
                result += rs.getString("fbdate") + " | " + rs.getString("avg_rating");
                System.out.println(result);
            }
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get top n feedbacks");
        }
    }

    public void getCoolStatistics(Connection con) {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String choice;
        int c;
        Map<Integer, String> options = new TreeMap<>();
        int i = 1;
        options.put(i++, "Top most popular POI's per category");
        options.put(i++, "Most expensive POI's per category");
        options.put(i++, "Top rated POI's per category");

        while (true) {
            System.out.println("Cool statistics:");
            for (Map.Entry<Integer, String> entry : options.entrySet())
                System.out.println(entry.getKey() + ". " + entry.getValue());
            System.out.println(i + ". Go back");

            try {
                while ((choice = in.readLine()) == null && choice.length() == 0) ;
                c = Integer.parseInt(choice);
            } catch (IOException e) {
                continue;
            }
            if (c < 1 || c > i) {
                System.out.println("Invalid choice");
                continue;
            }
            break;
        }

        Utils.QuestionSizePair nQSP = new Utils.QuestionSizePair("How many results per category do you want to see: ", 10, "Invalid number");
        int n = Integer.parseInt(Utils.getUserInput(nQSP, true));

        if (c == 1) {
            String sql = "select p.name, count(*) from Visit v, POI p where v.pid = p.pid and p.category = ? group by v.pid order by count(*) desc limit " + n;
            String resultSchema = "POI Name | Total number of visits";
            getTopNStatPOIs(con, sql, resultSchema);
        }
        else if (c == 2) {
            String sql = "select p.name, avg(e.cost) from Visit v, POI p, VisitEvent e" +
                    " where v.pid = p.pid and v.vid = e.vid and p.category = ?" +
                    " group by v.pid order by avg(e.cost) desc limit " + n;
            String resultSchema = "POI name | Price per person";
            getTopNStatPOIs(con, sql, resultSchema);
        }
        else if (c == 3) {
            String sql = "select p.name, avg(f.score) from Feedback f, POI p" +
                    " where f.pid = p.pid and p.category = ? group by p.pid order by avg(f.score) desc limit " + n;
            String resultSchema = "POI name | Average feedback score";
            getTopNStatPOIs(con, sql, resultSchema);
        }
    }

    private void getTopNStatPOIs(Connection con, String sql, String resultSchema) {
        Set<String> categories = getCategories(con);
        try {
            PreparedStatement preparedStatement;
            ResultSet rs;
            System.out.println(resultSchema);
            for (String category : categories) {
                preparedStatement = con.prepareStatement(sql);
                preparedStatement.setString(1, category);
                rs = preparedStatement.executeQuery();
                System.out.println("Category: " + category);
                while (rs.next())
                    System.out.println(rs.getString(1) + " | " + rs.getInt(2));
            }
        } catch (SQLException e) {
            System.out.println("Could not get top n results");
        }
    }

    private Set<String> getCategories(Connection con) {
        Set<String> categories = new HashSet<>();
        try {
            String sql = "select distinct category from POI";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next())
                categories.add(rs.getString(1));
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get list of categories");
        }
        return categories;
    }
}
