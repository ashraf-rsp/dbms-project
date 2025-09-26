package com.academic.listeners;

import com.academic.websockets.MessageWebsocket;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class BackgroundPoller implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                try {
                    // I need to get the db credentials here
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbms_project", "root", "a187");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT UserID, UnreadCount FROM User_Message_Status WHERE UnreadCount > 0");

                    while (rs.next()) {
                        String userId = rs.getString("UserID");
                        int unreadCount = rs.getInt("UnreadCount");
                        MessageWebsocket.sendMessageToUser(userId, "{\"type\": \"new_message_count\", \"count\": " + unreadCount + "}");
                    }
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, 0, 2, TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        scheduler.shutdownNow();
    }
}
