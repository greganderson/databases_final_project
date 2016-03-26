package cs5530;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;

/**
 * Created by greg on 3/16/16.
 */
public class User {

    public User() { }

    public boolean login(String username, String password, boolean isAdmin, Connection con) {
        String sql = "select username from Users where username = '" + username + "' and password = '" + password + "' and is_admin = " + isAdmin;
        try {
            Statement statement = con.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            rs.first();
            String output = rs.getString("username");
            rs.close();
            statement.close();
            return !output.isEmpty();
        } catch (Exception e) {
            System.out.println("Cannot execute the login query");
            return false;
        }
    }

    protected TreeSet<String> getKeywords(TreeSet<String> keywords) {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String keyword;
        String choice;
        int c;
        keywords.remove("");
        while (true) {
            System.out.println("Current keywords:");
            for (String word : keywords)
                System.out.println(word);
            System.out.println();
            System.out.println("1. Add keyword");
            System.out.println("2. Looks good");
            try {
                while ((choice = in.readLine()) == null && choice.length() == 0) ;
                c = Integer.parseInt(choice);
            } catch (IOException e) {
                continue;
            }

            if (c == 1) {
                System.out.print("Keyword: ");
                try {
                    while ((keyword = in.readLine()) == null && keyword.length() == 0) ;
                } catch (IOException e) {
                    continue;
                }
                keywords.add(keyword.toLowerCase());
                System.out.println();
            } else if (c == 2) {
                System.out.println();
                keywords.remove("");
                return keywords;
            }
        }
    }

    public TreeSet<String> getUserInputPOIName(Connection con) {
        TreeSet<String> pois = new TreeSet<>();
        try {
            Statement statement = con.createStatement();
            ResultSet rs = statement.executeQuery("select name from POI");
            while (rs.next()) {
                pois.add(rs.getString(1));
            }
            statement.close();
            rs.close();
        } catch (SQLException e) {
            System.out.println("Could not execute getting list of POI's");
        }

        return pois;
    }
}
