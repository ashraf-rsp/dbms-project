<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="jakarta.websocket.OnClose" %>
<%@ page import="jakarta.websocket.OnMessage" %>
<%@ page import="jakarta.websocket.OnOpen" %>
<%@ page import="jakarta.websocket.Session" %>
<%@ page import="jakarta.websocket.server.ServerEndpoint" %>

<%
    // This is an unconventional way to create a WebSocket endpoint.
    // The standard approach is to use a separate .java class.
    // Given the project constraints, this is a workaround.
%>
<%!
    @ServerEndpoint("/message-updates")
    public static class MessageWebsocket {

        private static Set<Session> sessions = Collections.synchronizedSet(new HashSet<Session>());

        @OnOpen
        public void onOpen(Session session) {
            sessions.add(session);
        }

        @OnMessage
        public void onMessage(String message, Session session) {
            // For now, we'll just broadcast any message received to all clients.
            // This can be refined later.
            sendMessageToAll(message);
        }

        @OnClose
        public void onClose(Session session) {
            sessions.remove(session);
        }

        public static void sendMessageToAll(String message) {
            for (Session session : sessions) {
                try {
                    session.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    // Log the error or handle it as needed
                    e.printStackTrace();
                }
            }
        }
    }
%>