package com.academic;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.websocket.server.PathParam;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@ServerEndpoint("/message-updates/{userId}")
public class RealtimeManager implements ServletContextListener {

    private static ScheduledExecutorService scheduler;
    private static Map<String, Session> sessions = Collections.synchronizedMap(new HashMap<>());

    // WebSocket methods
    @OnOpen
    public void onOpen(@PathParam("userId") String userId, Session session) {
        sessions.put(userId, session);
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Not used for now
    }

    @OnClose
    public void onClose(Session session) {
        sessions.values().remove(session);
    }

    public static void sendMessageToUser(String userId, String message) {
        Session session = sessions.get(userId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // ServletContextListener methods
    @Override
    public void contextInitialized(ServletContextEvent event) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbms_project", "root", "a187");
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT UserID, UnreadCount FROM User_Message_Status WHERE UnreadCount > 0");

                while (rs.next()) {
                    String userId = rs.getString("UserID");
                    int unreadCount = rs.getInt("UnreadCount");
                    sendMessageToUser(userId, "{\"type\": \"new_message_count\", \"count\": " + unreadCount + "}");
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 0, 2, TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        scheduler.shutdownNow();
    }
}
