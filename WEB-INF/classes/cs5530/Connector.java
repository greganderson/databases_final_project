package cs5530;

import javax.swing.*;
import java.sql.*;

public class Connector {
    public Connection con;

    public Connector() throws Exception {
        try {
            //String userName = JOptionPane.showInputDialog("Username:");
            //String password = JOptionPane.showInputDialog("Password:");
            //String db = JOptionPane.showInputDialog("Database:");
            String url = "jdbc:mysql://georgia.eng.utah.edu/" + db;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            con = DriverManager.getConnection(url, userName, password);
        } catch (Exception e) {
            System.err.println("Unable to open mysql jdbc connection. The error is as follows,\n");
            System.err.println(e.getMessage());
            throw (e);
        }
    }

    public void closeConnection() throws Exception {
        con.close();
    }
}
