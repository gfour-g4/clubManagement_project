<%@ page import="java.util.List,java.util.Map,model.Evenement,model.Club,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    List<Evenement> events = (List<Evenement>) request.getAttribute("events");
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    Map<Integer, String> clubNamesById = (Map<Integer, String>) request.getAttribute("clubNamesById");
    Integer selectedClubId = (Integer) request.getAttribute("selectedClubId");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Evenements</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Liste des evenements</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/clubs">Clubs</a>
            <% if ("ADMIN".equals(user.getRole()) || "RESPONSABLE_CLUB".equals(user.getRole())) { %>
                <a href="<%= request.getContextPath() %>/events/create">Nouvel evenement</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </div>
<% if (info != null && !info.isEmpty()) { %>
    <p class="success-text"><%= info %></p>
<% } %>

<div class="card">
    <form method="get" action="<%= request.getContextPath() %>/events" class="inline-form">
        <label>Filtrer par club :</label>
        <select name="clubId">
            <option value="">Tous</option>
            <% for (Club c : clubs) { %>
                <option value="<%= c.getId() %>" <%= selectedClubId != null && selectedClubId == c.getId() ? "selected" : "" %>><%= c.getNom() %></option>
            <% } %>
        </select>
        <button type="submit">Filtrer</button>
    </form>
</div>

<table>
    <tr><th>ID</th><th>Club</th><th>Titre</th><th>Date</th><th>Lieu</th><th>View</th></tr>
    <% if (events == null || events.isEmpty()) { %>
    <tr>
        <td colspan="6" class="muted">Aucun evenement trouve pour ce filtre.</td>
    </tr>
    <% } %>
    <% for (Evenement e : events) { %>
    <tr>
        <td><%= e.getId() %></td>
        <td><%= clubNamesById.get(e.getClubId()) != null ? clubNamesById.get(e.getClubId()) : ("Club #" + e.getClubId()) %></td>
        <td><%= e.getTitre() %></td>
        <td><%= e.getDateEvenement() %></td>
        <td><%= e.getLieu() %></td>
        <td><a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>">Voir</a></td>
    </tr>
    <% } %>
</table>
</div>
</body>
</html>
