<%@ page import="java.util.List,model.Evenement,model.Club,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    Evenement event = (Evenement) request.getAttribute("event");
    Club club = (Club) request.getAttribute("club");
    List<Utilisateur> participants = (List<Utilisateur>) request.getAttribute("participants");
    String activeTab = (String) request.getAttribute("activeTab");
    Boolean isRegistered = (Boolean) request.getAttribute("isRegistered");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Evenement - <%= event.getTitre() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Evenement: <%= event.getTitre() %></h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/events">Retour liste evenements</a>
            <% if (club != null) { %>
                <a href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>">Voir club</a>
            <% } %>
        </div>
    </div>

    <% if (info != null && !info.isEmpty()) { %>
    <p class="success-text"><%= info %></p>
    <% } %>

    <div class="tabs">
        <a class="<%= "info".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/events/view?id=<%= event.getId() %>&tab=info">Info</a>
        <a class="<%= "participants".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/events/view?id=<%= event.getId() %>&tab=participants">Participants</a>
        <% if ("ETUDIANT".equals(user.getRole())) { %>
            <a class="<%= "register".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/events/view?id=<%= event.getId() %>&tab=register">Inscription</a>
        <% } %>
    </div>

    <% if ("info".equals(activeTab)) { %>
    <div class="card">
        <p><strong>Titre:</strong> <%= event.getTitre() %></p>
        <p><strong>Club:</strong> <%= club != null ? club.getNom() : ("Club #" + event.getClubId()) %></p>
        <p><strong>Description:</strong> <%= event.getDescription() %></p>
        <p><strong>Date:</strong> <%= event.getDateEvenement() %></p>
        <p><strong>Lieu:</strong> <%= event.getLieu() %></p>
    </div>
    <% } %>

    <% if ("participants".equals(activeTab)) { %>
    <table>
        <tr><th>ID</th><th>Nom</th><th>Email</th></tr>
        <% if (participants == null || participants.isEmpty()) { %>
        <tr><td colspan="4" class="muted">Aucun participant inscrit.</td></tr>
        <% } %>
        <% for (Utilisateur p : participants) { %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getNomComplet() %></td>
            <td><%= p.getEmail() %></td>
        </tr>
        <% } %>
    </table>
    <% } %>

    <% if ("register".equals(activeTab) && "ETUDIANT".equals(user.getRole())) { %>
    <div class="card">
        <% if (Boolean.TRUE.equals(isRegistered)) { %>
        <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
            <input type="hidden" name="eventId" value="<%= event.getId() %>">
            <input type="hidden" name="action" value="cancel">
            <input type="hidden" name="redirectEventId" value="<%= event.getId() %>">
            <button type="submit">Annuler mon inscription</button>
        </form>
        <% } else { %>
        <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
            <input type="hidden" name="eventId" value="<%= event.getId() %>">
            <input type="hidden" name="action" value="register">
            <input type="hidden" name="redirectEventId" value="<%= event.getId() %>">
            <button type="submit">S'inscrire a cet evenement</button>
        </form>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
