<%@ page import="java.util.List,java.util.Map,model.Club,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    Map<Integer, String> clubResponsables = (Map<Integer, String>) request.getAttribute("clubResponsables");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clubs</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Liste des clubs</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/events">Evenements</a>
            <% if ("ADMIN".equals(user.getRole())) { %>
                <a href="<%= request.getContextPath() %>/clubs/create">Nouveau club</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </div>
<% if (info != null && !info.isEmpty()) { %>
    <p class="success-text"><%= info %></p>
<% } %>

<table>
    <tr><th>ID</th><th>Nom</th><th>Description</th><th>Responsable</th><th>View</th></tr>
    <% if (clubs == null || clubs.isEmpty()) { %>
    <tr>
        <td colspan="5" class="muted">Aucun club trouve.</td>
    </tr>
    <% } %>
    <% if (clubs != null) { for (Club c : clubs) { %>
    <tr>
        <td><%= c.getId() %></td>
        <td><%= c.getNom() %></td>
        <td><%= c.getDescription() %></td>
        <td><%= clubResponsables.get(c.getId()) != null ? clubResponsables.get(c.getId()) : "Non assigne" %></td>
        <td><a href="<%= request.getContextPath() %>/clubs/view?id=<%= c.getId() %>">Voir</a></td>
    </tr>
    <% }} %>
</table>
</div>
</body>
</html>
