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
    private Utils.QuestionSizePair nameQSP;
    private Utils.QuestionSizePair addressQSP;
    private Utils.QuestionSizePair urlQSP;
    private Utils.QuestionSizePair phone_numQSP;
    private Utils.QuestionSizePair price_per_personQSP;
    private Utils.QuestionSizePair year_of_estQSP;
    private Utils.QuestionSizePair hoursQSP;
    private Utils.QuestionSizePair categoryQSP;

    public Admin(String username) {
		this.username = username;
        nameQSP = new Utils.QuestionSizePair("Name (e.g. Pizza Place): ", 50);
        addressQSP = new Utils.QuestionSizePair("Address (e.g. 123 S. 456 E. Beaver, UT 12345): ", 80);
        urlQSP = new Utils.QuestionSizePair("URL (e.g. www.mywebsitegoeshere.com): ", 50);
        phone_numQSP = new Utils.QuestionSizePair("Phone number (e.g. 1234567890): ", 10, "Invalid phone number");
        price_per_personQSP = new Utils.QuestionSizePair("Price per person (e.g. $12): ", 1000, "Invalid price");
        year_of_estQSP = new Utils.QuestionSizePair("Year of establishment (e.g. 1970): ", 4, "Invalid year");
        hoursQSP = new Utils.QuestionSizePair("Hours (e.g. 7:00am-9:00pm): ", 22);
        categoryQSP = new Utils.QuestionSizePair("Category (e.g. restaurant): ", 50);
    }

    public void addPOI(Connection con) {
        String name = Utils.getUserInput(nameQSP, false);
        String address = Utils.getUserInput(addressQSP, false);
        String url = Utils.getUserInput(urlQSP, false);
        String phone_num;
        while (true) {
            phone_num = Utils.getUserInput(phone_numQSP, true);
            if (phone_num.length() == 10)
                break;
            System.out.println(phone_numQSP.errorMessage);
        }
        String price_per_person = Utils.getDollarAmount(price_per_personQSP);
        String year_of_est = Utils.getUserInput(year_of_estQSP, true);
        // TODO: Probably needs some error checking here :(
        String hours = Utils.getUserInput(hoursQSP, false);
        String category = Utils.getUserInput(categoryQSP, false);
        TreeSet<String> keywords = getKeywords();

        addPOISql(con, name, address, url, phone_num, price_per_person, year_of_est, hours, category, keywords);
    }

    private void addPOISql(Connection con,
                           String name,
                           String address,
                           String url,
                           String phone_num,
                           String price_per_person,
                           String year_of_est,
                           String hours,
                           String category,
                           Set<String> keywords) {
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
        addKeywords(con, keywords, pid);
    }

    public void updatePOI(Connection con) {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String choice;
        int c;

        int pid = -1;
        String name = getUserInputPOIName(con, "Please select a POI to update:");
        if (name.isEmpty())
            return;
        String address = "";
        String url = "";
        String phone_num = "";
        String price_per_person = "";
        String year_of_est = "";
        String hours = "";
        String category = "";
        TreeSet<String> words = new TreeSet<>();

        // Get specific part of POI to update
        while (true) {
            System.out.println("Current fields:");
            String[] keywords = new String[0];
            try {
                Statement statement = con.createStatement();
                ResultSet rs = statement.executeQuery("select * from POI where name = '" + name + "'");
                rs.first();
                pid = rs.getInt("pid");
                address = rs.getString("address");
                url = rs.getString("url");
                phone_num = rs.getString("phone_num");
                price_per_person = rs.getString("price_per_person");
                year_of_est = rs.getString("year_of_est");
                hours = rs.getString("hours");
                category = rs.getString("category");

                // Get keywords
                rs = statement.executeQuery("select k.word from Keywords k, HasKeywords h " +
                        "where k.wid = h.wid and h.pid = " + pid);
                while (rs.next()) {
                    words.add(rs.getString(1));
                }
                keywords = words.toArray(new String[words.size()]);

                statement.close();
                rs.close();
            } catch (SQLException e) {
                System.out.println("Could not execute getting list of fields for POI");
            }
            System.out.println("Name: " + name);
            System.out.println("Address: " + address);
            System.out.println("URL: " + url);
            System.out.println("Phone number: " + phone_num);
            System.out.println("Price per person: $" + price_per_person);
            System.out.println("Year of establishment: " + year_of_est);
            System.out.println("Hours: " + hours);
            System.out.println("Category: " + category);
            System.out.print("Keywords: ");
            if (keywords.length != 0) {
                System.out.print(keywords[0]);
                if (keywords.length > 1) {
                    System.out.print(", ");
                    for (int j = 1; j < keywords.length - 1; j++) {
                        System.out.print(keywords[j] + ", ");
                    }
                    System.out.print(keywords[keywords.length - 1]);
                }
                System.out.println();
            }
            System.out.println();

            System.out.println("Please select a field to update:");
            System.out.println("1. Name");
            System.out.println("2. Address");
            System.out.println("3. URL");
            System.out.println("4. Phone number");
            System.out.println("5. Price per person");
            System.out.println("6. Year of establishment");
            System.out.println("7. Hours");
            System.out.println("8. Category");
            System.out.println("9. Keywords");
            System.out.println("10. Exit");

            try {
                while ((choice = in.readLine()) == null && choice.length() == 0) ;
                c = Integer.parseInt(choice);
            } catch (IOException e) {
                continue;
            }

            String field = "";
            String newValue = "";

            if (c == 1) {
                field = "name";
                newValue = Utils.getUserInput(nameQSP, false);
            }
            else if (c == 2) {
                field = "address";
                newValue = Utils.getUserInput(addressQSP, false);
            }
            else if (c == 3) {
                field = "url";
                newValue = Utils.getUserInput(urlQSP, false);
            }
            else if (c == 4) {
                field = "phone_num";
                while (true) {
                    newValue = Utils.getUserInput(phone_numQSP, true);
                    if (newValue.length() == 10)
                        break;
                    System.out.println(phone_numQSP.errorMessage);
                }
            }
            else if (c == 5) {
                field = "price_per_person";
                newValue = Utils.getDollarAmount(price_per_personQSP);
            }
            else if (c == 6) {
                field = "year_of_est";
                newValue = Utils.getUserInput(year_of_estQSP, true);
            }
            else if (c == 7) {
                field = "hours";
                newValue = Utils.getUserInput(hoursQSP, false);
            }
            else if (c == 8) {
                field = "category";
                newValue = Utils.getUserInput(categoryQSP, false);
            }
            else if (c == 9) {
                // Clear current POI's keywords from database
                try {
                    Statement statement = con.createStatement();
                    statement.executeUpdate("delete from HasKeywords where pid = " + pid);
                } catch (SQLException e) {
                    System.out.println("Could not execute deletion from HasKeywords");
                }
                // TODO: Need an option to delete a keyword
                addKeywords(con, getKeywords(words), pid);
                break;
            }
            else if (c == 10)
                break;
            else
                break;

            updatePOIField(con, field, newValue, pid);
            break;
        }
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

    private TreeSet<String> getKeywords() {
        return getKeywords(new TreeSet<String>());
    }

    private void addKeywords(Connection con, Set<String> keywords, int pid) {
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

    public void getTopNMostTrustedUsers(Connection con) {
        Utils.QuestionSizePair nQSP = new Utils.QuestionSizePair("How many most trusted users do you want to see: ", 10, "Invalid number");
        int n = Integer.parseInt(Utils.getUserInput(nQSP, true));
        try {
            String sql = "select u.name, sum(t.is_trusted) from Trust t, Users u" +
                    " where t.username2 = u.username group by username2 order by sum(is_trusted) desc limit " + n;
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            System.out.println("Name | Total trusted score");
            while (rs.next())
                System.out.println(rs.getString(1) + " | " + rs.getInt(2));
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get top N most trusted users");
        }
    }

    public void getTopNMostUsefulUsers(Connection con) {
        Utils.QuestionSizePair nQSP = new Utils.QuestionSizePair("How many most useful users do you want to see: ", 10, "Invalid number");
        int n = Integer.parseInt(Utils.getUserInput(nQSP, true));
        try {
            String sql = "select f.username, avg(r.rating) from Rates r, Feedback f" +
                    " where r.fid = f.fid group by f.username order by avg(r.rating) desc limit " + n;
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            System.out.println("Name | Average usefulness score");
            while (rs.next())
                System.out.println(rs.getString(1) + " | " + rs.getFloat(2));
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get top N most useful users");
        }
    }

    public void getDegreesOfSeparation(Connection con) {
        // Get two users
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String choice;
        int c;
        Map<Integer, String> users = new TreeMap<>();
        int i = 1;
        try {
            String sql = "select username from Users where is_admin = false";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next())
                users.put(i++, rs.getString(1));
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get degrees of separation");
        }

        while (true) {
            System.out.println("Select the first user:");
            for (Map.Entry<Integer, String> entry : users.entrySet())
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

        if (c == i)
            return;

        String user1 = users.get(c);
        users.remove(c);

        while (true) {
            System.out.println("Select the second user:");
            for (Map.Entry<Integer, String> entry : users.entrySet())
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

        String user2 = users.get(c);
        Set<String> user1FirstDegreers = getFirstDegreeUsers(con, user1);
        if (user1FirstDegreers.contains(user2)) {
            System.out.println(user1 + " and " + user2 + " are 1-degree away");
            return;
        }

        Set<String> user2FirstDegreers = getFirstDegreeUsers(con, user2);

        for (String u : user1FirstDegreers) {
            if (user2FirstDegreers.contains(u)) {
                System.out.println(user1 + " and " + user2 + " are 2-degrees away");
                return;
            }
        }

        System.out.println(user1 + " and " + user2 + " are more than 2-degrees away");
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
