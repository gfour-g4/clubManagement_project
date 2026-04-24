<%@ page import="java.util.List,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur current = (Utilisateur) session.getAttribute("user");
    Utilisateur target = (Utilisateur) request.getAttribute("targetUser");
    String activeTab = (String) request.getAttribute("activeTab");
    List<String> clubs = (List<String>) request.getAttribute("clubs");
    List<String> events = (List<String>) request.getAttribute("events");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Utilisateur - <%= target.getNomComplet() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Utilisateur: <%= target.getNomComplet() %></h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/users">Retour liste utilisateurs</a>
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        </div>
    </div>

    <% if (info != null && !info.isEmpty()) { %>
    <p class="success-text"><%= info %></p>
    <% } %>

    <div class="tabs">
        <a class="<%= "info".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/users/view?id=<%= target.getId() %>&tab=info">Info</a>
        <a class="<%= "clubs".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/users/view?id=<%= target.getId() %>&tab=clubs">Clubs</a>
        <a class="<%= "events".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/users/view?id=<%= target.getId() %>&tab=events">Events</a>
        <a class="<%= "actions".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/users/view?id=<%= target.getId() %>&tab=actions">Admin Actions</a>
    </div>

    <% if ("info".equals(activeTab)) { %>
    <div class="card">
        <p><strong>ID:</strong> <%= target.getId() %></p>
        <p><strong>Nom:</strong> <%= target.getNomComplet() %></p>
        <p><strong>Email:</strong> <%= target.getEmail() %></p>
        <p><strong>Role:</strong> <%= target.getRole() %></p>
        <p><strong>Date creation:</strong> <%= target.getDateCreation() %></p>
    </div>
    <% } %>

    <% if ("clubs".equals(activeTab)) { %>
    <table>
        <tr><th>Clubs actifs</th></tr>
        <% if (clubs == null || clubs.isEmpty()) { %>
        <tr><td class="muted">Aucun club actif.</td></tr>
        <% } %>
        <% for (String clubName : clubs) { %>
        <tr><td><%= clubName %></td></tr>
        <% } %>
    </table>
    <% } %>

    <% if ("events".equals(activeTab)) { %>
    <table>
        <tr><th>Evenements inscrits</th></tr>
        <% if (events == null || events.isEmpty()) { %>
        <tr><td class="muted">Aucun evenement inscrit.</td></tr>
        <% } %>
        <% for (String eventTitle : events) { %>
        <tr><td><%= eventTitle %></td></tr>
        <% } %>
    </table>
    <% } %>

    <% if ("actions".equals(activeTab)) { %>
    <div class="card">
        <% if (current.getId() == target.getId()) { %>
            <p class="muted">Vous ne pouvez pas supprimer votre propre compte.</p>
        <% } else { %>
            <form method="post" action="<%= request.getContextPath() %>/users/delete" class="inline-form" onsubmit="return confirm('Supprimer cet utilisateur ?');">
                <input type="hidden" name="id" value="<%= target.getId() %>">
                <input type="hidden" name="redirectUserId" value="<%= target.getId() %>">
                <button type="submit">Supprimer cet utilisateur</button>
            </form>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
