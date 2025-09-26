package com.academic.websockets;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.server.PathParam;

@ServerEndpoint("/message-updates/{userId}")
public class MessageWebsocket {

    private static Map<String, Session> sessions = Collections.synchronizedMap(new HashMap<>());

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
}
