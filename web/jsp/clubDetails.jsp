<%@ page import="java.util.List,model.Club,model.Evenement,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    Club club = (Club) request.getAttribute("club");
    List<Evenement> events = (List<Evenement>) request.getAttribute("events");
    List<Utilisateur> members = (List<Utilisateur>) request.getAttribute("members");
    List<Utilisateur> responsables = (List<Utilisateur>) request.getAttribute("responsables");
    String responsableName = (String) request.getAttribute("responsableName");
    String activeTab = (String) request.getAttribute("activeTab");
    Boolean isStudentMember = (Boolean) request.getAttribute("isStudentMember");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Club - <%= club.getNom() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Club: <%= club.getNom() %></h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/clubs">Retour liste clubs</a>
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        </div>
    </div>

    <% if (info != null && !info.isEmpty()) { %>
    <p class="success-text"><%= info %></p>
    <% } %>

    <div class="tabs">
        <a class="<%= "info".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=info">Info</a>
        <a class="<%= "events".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=events">Events</a>
        <a class="<%= "members".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=members">Members</a>
        <% if ("ADMIN".equals(user.getRole())) { %>
            <a class="<%= "assign".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=assign">Assign Responsable</a>
        <% } %>
    </div>

    <% if ("info".equals(activeTab)) { %>
    <div class="card">
        <p><strong>Nom:</strong> <%= club.getNom() %></p>
        <p><strong>Description:</strong> <%= club.getDescription() %></p>
        <p><strong>Responsable:</strong> <%= responsableName != null ? responsableName : "Non assigne" %></p>
        <% if ("ETUDIANT".equals(user.getRole())) { %>
        <div class="actions">
            <% if (Boolean.TRUE.equals(isStudentMember)) { %>
            <form method="post" action="<%= request.getContextPath() %>/membership" class="inline-form">
                <input type="hidden" name="clubId" value="<%= club.getId() %>">
                <input type="hidden" name="action" value="leave">
                <input type="hidden" name="redirectClubId" value="<%= club.getId() %>">
                <button type="submit">Quitter ce club</button>
            </form>
            <% } else { %>
            <form method="post" action="<%= request.getContextPath() %>/membership" class="inline-form">
                <input type="hidden" name="clubId" value="<%= club.getId() %>">
                <input type="hidden" name="action" value="join">
                <input type="hidden" name="redirectClubId" value="<%= club.getId() %>">
                <button type="submit">Adherer a ce club</button>
            </form>
            <% } %>
        </div>
        <% } %>
    </div>
    <% } %>

    <% if ("events".equals(activeTab)) { %>
    <table>
        <tr><th>Titre</th><th>Description</th><th>Date</th><th>Lieu</th></tr>
        <% if (events == null || events.isEmpty()) { %>
        <tr><td colspan="4" class="muted">Aucun evenement pour ce club.</td></tr>
        <% } %>
        <% for (Evenement e : events) { %>
        <tr>
            <td><%= e.getTitre() %></td>
            <td><%= e.getDescription() %></td>
            <td><%= e.getDateEvenement() %></td>
            <td><%= e.getLieu() %></td>
        </tr>
        <% } %>
    </table>
    <% } %>

    <% if ("members".equals(activeTab)) { %>
    <table>
        <tr><th>ID</th><th>Nom</th><th>Email</th></tr>
        <% if (members == null || members.isEmpty()) { %>
        <tr><td colspan="4" class="muted">Aucun membre actif.</td></tr>
        <% } %>
        <% for (Utilisateur m : members) { %>
        <tr>
            <td><%= m.getId() %></td>
            <td><%= m.getNomComplet() %></td>
            <td><%= m.getEmail() %></td>
        </tr>
        <% } %>
    </table>
    <% } %>

    <% if ("assign".equals(activeTab) && "ADMIN".equals(user.getRole())) { %>
    <div class="card">
        <form method="post" action="<%= request.getContextPath() %>/clubs/assign-responsable" class="form-layout">
            <input type="hidden" name="clubId" value="<%= club.getId() %>">
            <input type="hidden" name="redirectClubId" value="<%= club.getId() %>">
            <div class="form-row">
                <label for="utilisateurId">Responsable</label>
                <select id="utilisateurId" name="utilisateurId" required>
                    <% for (Utilisateur r : responsables) { %>
                        <option value="<%= r.getId() %>"><%= r.getNomComplet() %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit">Assigner</button>
            </div>
        </form>
    </div>
    <% } %>
</div>
</body>
</html>
