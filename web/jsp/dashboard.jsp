<%@ page import="model.Utilisateur,java.util.Map,java.util.List,model.Evenement" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("statsMembres");
    List<Evenement> events = (List<Evenement>) request.getAttribute("upcomingEvents");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Bienvenue <%= user.getNomComplet() %> (<%= user.getRole() %>)</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/clubs">Clubs</a>
            <a href="<%= request.getContextPath() %>/events">Evenements</a>
            <% if ("ADMIN".equals(user.getRole())) { %>
                <a href="<%= request.getContextPath() %>/users">Utilisateurs</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </div>

<h3>Statistiques: Nombre de membres par club</h3>
<table>
    <tr><th>Club</th><th>Nombre membres actifs</th></tr>
    <% for (Map.Entry<String, Integer> e : stats.entrySet()) { %>
    <tr>
        <td><%= e.getKey() %></td>
        <td><%= e.getValue() %></td>
    </tr>
    <% } %>
</table>

<h3>Evenements a venir</h3>
<table>
    <tr><th>Titre</th><th>Date</th><th>Lieu</th></tr>
    <% for (Evenement e : events) { %>
    <tr>
        <td><%= e.getTitre() %></td>
        <td><%= e.getDateEvenement() %></td>
        <td><%= e.getLieu() %></td>
    </tr>
    <% } %>
</table>
</div>
</body>
</html>
