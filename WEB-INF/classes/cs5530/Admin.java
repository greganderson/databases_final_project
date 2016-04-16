package cs5530;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.*;

/**
 * Created by greg on 3/16/16.
 */
public class Admin extends User {

	private String username;

    public Admin(String username) {
		this.username = username;
    }

    public int addPOISql(Connection con,
                           String name,
                           String address,
                           String url,
                           String phone_num,
                           String price_per_person,
                           String year_of_est,
                           String hours,
                           String category) {
        // Add POI
        String sql = "INSERT INTO POI (name, address, url, phone_num, price_per_person, year_of_est, hours, category)" +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, name);
            preparedStatement.setString(2, address);
            preparedStatement.setString(3, url);
            preparedStatement.setString(4, phone_num);
            preparedStatement.setString(5, price_per_person);
            preparedStatement.setString(6, year_of_est);
            preparedStatement.setString(7, hours);
            preparedStatement.setString(8, category);
            preparedStatement.execute();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not execute add POI SQL");
        }

        int pid = -1;
        try {
            Statement statement = con.createStatement();
            ResultSet rs = statement.executeQuery("select pid from POI where name = '" + name + "'");
            rs.first();
            pid = rs.getInt("pid");
            rs.close();
            statement.close();
        } catch (SQLException e) {
            System.out.println("Could not execute getting pid from POI");
        }
		return pid;
    }

    public POIInformation updatePOI(Connection con, String poiName) {
		POIInformation poi = null;
		try {
			Statement statement = con.createStatement();
			ResultSet rs = statement.executeQuery("select * from POI where name = '" + poiName + "'");
			rs.first();
			int pid = rs.getInt("pid");
			String address = rs.getString("address");
			String url = rs.getString("url");
			String phone_num = rs.getString("phone_num");
			String price_per_person = rs.getString("price_per_person");
			String year_of_est = rs.getString("year_of_est");
			String hours = rs.getString("hours");
			String category = rs.getString("category");

			// Get keywords
			rs = statement.executeQuery("select k.word from Keywords k, HasKeywords h " +
					"where k.wid = h.wid and h.pid = " + pid);
			Set<String> words = new HashSet<>();
			while (rs.next())
				words.add(rs.getString(1));

			poi = new POIInformation(poiName, address, url, phone_num, price_per_person, year_of_est, hours, category, "");
			poi.setPid(pid);
			poi.setKeywords(words);

			statement.close();
			rs.close();
		} catch (SQLException e) {
			System.out.println("Could not execute getting list of fields for POI");
		}

		return poi;
    }

	public void updateKeywords(Connection con, Set<String> keywords, int pid) {
		// Clear current POI's keywords from database
		try {
			Statement statement = con.createStatement();
			statement.executeUpdate("delete from HasKeywords where pid = " + pid);
		} catch (SQLException e) {
			System.out.println("Could not execute deletion from HasKeywords");
		}
		addKeywords(con, keywords, pid);
	}

	public void updatePOIFields(Connection con, POIInformation poi) {
		Map<String, String> fields = new HashMap<>();
		fields.put("name", poi.name);
		fields.put("address", poi.address);
		fields.put("url", poi.url);
		fields.put("phone_num", poi.phoneNumber);
		fields.put("price_per_person", poi.pricePerPerson);
		fields.put("year_of_est", poi.yearEstablished);
		fields.put("hours", poi.hours);
		fields.put("category", poi.category);

		for (Map.Entry<String, String> entry : fields.entrySet())
			updatePOIField(con, entry.getKey(), entry.getValue(), poi.pid);
	}

    private void updatePOIField(Connection con, String field, String newValue, int pid) {
        String sql = "update POI set " + field + " = ? where pid = ?";
        try {
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, newValue);
            preparedStatement.setInt(2, pid);
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not execute update for POI");
        }
    }

    public void addKeywords(Connection con, Set<String> keywords, int pid) {
        // Add keywords to keywords table
        try {
            Statement statement = con.createStatement();
            for (String word : keywords) {
                statement.addBatch("INSERT INTO Keywords (word) VALUES ('" + word + "')");
            }
            statement.executeBatch();
            statement.close();
        } catch (BatchUpdateException e) {
            // Do nothing
        } catch (SQLException e) {
            System.out.println("Could not execute adding keywords");
        }

        // Now link keywords to POI
        try {
            Statement statement = con.createStatement();
            for (String word : keywords) {
                statement.addBatch("insert into HasKeywords values (" + pid + ", " +
                        "(select wid from Keywords where word = '" + word + "'))");
            }
            statement.executeBatch();
            statement.close();
        } catch (SQLException e) {
            System.out.println("Could not execute linking keywords to POI");
        }
    }

    public List<String[]> getTopNMostTrustedUsers(Connection con, int n) {
		List<String[]> result = new ArrayList<>();
        try {
            String sql = "select u.name, sum(t.is_trusted) from Trust t, Users u" +
                    " where t.username2 = u.username group by username2 order by sum(is_trusted) desc limit " + n;
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
				String[] arr = {rs.getString(1), rs.getInt(2) + ""};
				result.add(arr);
			}
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get top N most trusted users");
        }

		return result;
    }

    public List<String[]> getTopNMostUsefulUsers(Connection con, int n) {
		List<String[]> result = new ArrayList<>();
        try {
            String sql = "select f.username, avg(r.rating) from Rates r, Feedback f" +
                    " where r.fid = f.fid group by f.username order by avg(r.rating) desc limit " + n;
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
				String[] arr = {rs.getString(1), rs.getFloat(2) + ""};
                result.add(arr);
			}
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get top N most useful users");
        }

		return result;
    }

	public Set<String> getListOfUsers(Connection con) {
        Set<String> users = new TreeSet<>();
        try {
            String sql = "select username from Users where is_admin = false";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next())
                users.add(rs.getString(1));
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get degrees of separation");
        }
		return users;
	}

    public String getDegreesOfSeparation(Connection con, String user1, String user2) {
        Set<String> user1FirstDegreers = getFirstDegreeUsers(con, user1);
		String result = "";
        if (user1FirstDegreers.contains(user2))
            return user1 + " and " + user2 + " are 1-degree away";

        Set<String> user2FirstDegreers = getFirstDegreeUsers(con, user2);

        for (String u : user1FirstDegreers)
            if (user2FirstDegreers.contains(u))
                return user1 + " and " + user2 + " are 2-degrees away";

        return user1 + " and " + user2 + " are more than 2-degrees away";
    }

    private Set<String> getFirstDegreeUsers(Connection con, String user) {
        Set<String> users = new TreeSet<>();
        try {
            String sql = "select f.username from Favorites f" +
                    " where f.pid in (select pid from Favorites where username = ?) and f.username <> ?";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, user);
            preparedStatement.setString(2, user);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next())
                users.add(rs.getString(1));
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get list of first degree users");
        }
        return users;
    }
}
