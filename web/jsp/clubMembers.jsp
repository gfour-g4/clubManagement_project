<%@ page import="java.util.List,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<Utilisateur> members = (List<Utilisateur>) request.getAttribute("members");
    Integer clubId = (Integer) request.getAttribute("clubId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Membres du club - Gestion Clubs Universitaires</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="app-container">
    <div class="sidebar">
        <div class="sidebar-header">
            <h1>🎓 Club Management</h1>
        </div>
        <div class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/dashboard">🏠 Dashboard</a>
            <a href="<%= request.getContextPath() %>/clubs" class="active">🏛️ Clubs</a>
            <a href="<%= request.getContextPath() %>/events">📅 Événements</a>
        </div>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" style="color: var(--danger);">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="main-content">
        <div class="page-header">
            <h2>Membres actifs du club #<%= clubId %></h2>
        </div>
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <h3>Membres</h3>
                <a href="<%= request.getContextPath() %>/clubs" style="text-decoration: none; color: var(--primary); font-weight: 600;">← Retour aux clubs</a>
            </div>
            <table>
                <tr><th>ID</th><th>Nom</th><th>Email</th><th>Rôle</th></tr>
                <% if (members == null || members.isEmpty()) { %>
                <tr>
                    <td colspan="4" class="muted">Aucun membre actif dans ce club.</td>
                </tr>
                <% } %>
                <% for (Utilisateur m : members) { %>
                <tr>
                    <td><%= m.getId() %></td>
                    <td><%= m.getNomComplet() %></td>
                    <td><%= m.getEmail() %></td>
                    <td><%= m.getRole() %></td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</div>
</body>
</html>
