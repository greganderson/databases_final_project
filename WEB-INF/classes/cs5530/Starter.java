package cs5530;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.Map;
import java.util.TreeMap;


/*
Admin:
- (3) Make a new POI
- (4) Update a POI
- (14) Provide user awards

Users:
- (1) Register themselves as a new user
- (2) Record a visit
- (5) Declare a POI as their favorite
- (6) Provide feedback
- (7) Rate feedbacks
- (8) Say specific users are trusted or not
- (9) Search for POI's
- (10) Ask for top rated feedback
- (13) Different stats

Other:
- (11) Visiting suggestions
- (12) Degrees of separation

 */

public class Starter {

    public Starter() { }

	/*
    public static void main(String[] args) {
        Connector con = null;
        String choice;
        String username;
        String password;
        int c = 0;
        try {
            con = new Connector();
            System.out.println("Database connection established");

            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

            while (true) {
                System.out.println("        Welcome to the UTrack System        ");
                System.out.println("1. Login as User");
                System.out.println("2. Login as Admin");
                System.out.println("3. Create new account");
                System.out.println("4. Exit");

                while ((choice = in.readLine()) == null && choice.length() == 0) ;
                try {
                    c = Integer.parseInt(choice);
                } catch (Exception e) {
                    continue;
                }

                if (c == 1) {
                    System.out.println("Username:");
                    while ((username = in.readLine()) == null && username.length() == 0) ;
                    System.out.println("Password:");
                    while ((password = in.readLine()) == null && password.length() == 0) ;

                    RegularUser user = new RegularUser(username);
                    boolean successful = user.login(username, password, false, con.con);
                    if (successful) {
                        System.out.println("Login successful");
                        while (displayRegularUserOptions(user, con.con));
                    }
                    else {
                        System.out.println("Invalid username or password");
                    }
                }
                else if (c == 2) {
                    Admin user = new Admin();
                    System.out.println("Username:");
                    while ((username = in.readLine()) == null && username.length() == 0) ;
                    System.out.println("Password:");
                    while ((password = in.readLine()) == null && password.length() == 0) ;

                    boolean successful = user.login(username, password, true, con.con);
                    if (successful) {
                        System.out.println("Login successful");
                        System.out.println("        Welcome Administrator!      ");
                        while (displayAdminOptions(user, con.con)) ;
                    }
                    else {
                        System.out.println("Invalid username or password");
                    }
                }
                else if (c == 3) {
                    if (RegularUser.createNewUser(con.con))
                        System.out.println("User successfully created!");
                }
                else if (c == 4) {
                    System.out.println("Remember to pay us!");
                    con.stmt.close();
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Either connection error or query execution error!");
        } finally {
            if (con != null) {
                try {
                    con.closeConnection();
                    System.out.println("Database connection terminated");
                } catch (Exception e) { }
            }
        }
    }
	*/

    public static boolean displayRegularUserOptions(RegularUser user, Connection con) {
        // This method is called inside a while loop, so return true to start this method over, false to stop the loop.
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String choice;
        int c;
        Map<Integer, String> options = new TreeMap<>();
        int i = 1;
        options.put(i++, "Record a visit");
        options.put(i++, "Set favorite POI");
        options.put(i++, "Provide feedback for a POI");
        options.put(i++, "Rate a feedback");
        options.put(i++, "Declare a user as trusted or not");
        options.put(i++, "Search for a POI");
        options.put(i++, "See top rated feedback");
        options.put(i++, "See cool statistics");

        while (true) {
            for (Map.Entry<Integer, String> entry : options.entrySet())
                System.out.println(entry.getKey() + ". " + entry.getValue());
            System.out.println(i + ". Exit");
            try {
                while ((choice = in.readLine()) == null && choice.length() == 0) ;
                c = Integer.parseInt(choice);
            } catch (IOException e) {
                continue;
            }
            break;
        }

        if (c == i)
            return false;

        if (c == 1) {
            String[] usernamePOINamePair = user.recordNewVisit(con);
            if (!usernamePOINamePair[1].isEmpty())
                displaySuggestedPOIs(con, usernamePOINamePair[0], usernamePOINamePair[1]);
        }
        else if (c == 2) {
            user.addFavoritePOI(con);
        }
        else if (c == 3) {
            user.provideFeedback(con);
        }
        else if (c == 4) {
            user.rateFeedback(con);
        }
        else if (c == 5) {
            user.declareUserTrust(con);
        }
        else if (c == 6) {
            while (user.searchForPOI(con));
        }
        else if (c == 7) {
            user.findTopNMostUsefulFeedbacks(con);
        }
        else if (c == 8) {
            user.getCoolStatistics(con);
        }
        return true;
    }

    public static boolean displayAdminOptions(Admin user, Connection con) {
        // This method is called inside a while loop, so return true to start this method over, false to stop the loop.
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String choice;
        int c;
        Map<Integer, String> options = new TreeMap<>();
        int i = 1;
        options.put(i++, "Create new POI");
        options.put(i++, "Update existing POI");
        options.put(i++, "Top most trusted users");
        options.put(i++, "Top most useful users");
        options.put(i++, "Get degrees of separation between two users");

        while (true) {
            for (Map.Entry<Integer, String> entry : options.entrySet())
                System.out.println(entry.getKey() + ". " + entry.getValue());
            System.out.println(i + ". Logout");

            try {
                while ((choice = in.readLine()) == null && choice.length() == 0) ;
                c = Integer.parseInt(choice);
            } catch (IOException e) {
                return true;
            }
            break;
        }

        if (c == i)
            return false;

        if (c == 1) {
            user.addPOI(con);
        }
        else if (c == 2) {
            user.updatePOI(con);
        }
        else if (c == 3) {
            user.getTopNMostTrustedUsers(con);
        }
        else if (c == 4) {
            user.getTopNMostUsefulUsers(con);
        }
        else if (c == 5) {
            user.getDegreesOfSeparation(con);
        }
        return true;
    }

    private static void displaySuggestedPOIs(Connection con, String username, String poiName) {
        try {
            String sql = "select t.name from" +
                    " (select p.name as name, count(v.username) as total_visits from POI p, Visit v" +
                    " where p.pid = v.pid and v.username in" +
                    " (select v.username from Visit v, POI p" +
                    " where v.pid = p.pid and p.name = ? and v.username <> ?) and p.name <> ?" +
                    " group by v.username, v.pid) as t group by t.name order by sum(t.total_visits) desc";
            PreparedStatement preparedStatement = con.prepareStatement(sql);
            preparedStatement.setString(1, poiName);
            preparedStatement.setString(2, username);
            preparedStatement.setString(3, poiName);
            ResultSet rs = preparedStatement.executeQuery();
            System.out.println("You also might like:");
            while (rs.next())
                System.out.println(rs.getString(1));
            System.out.println();
            rs.close();
            preparedStatement.close();
        } catch (SQLException e) {
            System.out.println("Could not get suggested POIs");
        }

    }
}
