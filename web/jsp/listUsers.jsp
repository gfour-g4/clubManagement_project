<%@ page import="java.util.List,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur current = (Utilisateur) session.getAttribute("user");
    List<Utilisateur> users = (List<Utilisateur>) request.getAttribute("users");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Utilisateurs - Gestion Clubs Universitaires</title>
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
            <a href="<%= request.getContextPath() %>/clubs">🏛️ Clubs</a>
            <a href="<%= request.getContextPath() %>/events">📅 Événements</a>
            <% if ("ADMIN".equals(current.getRole())) { %>
                <a href="<%= request.getContextPath() %>/users" class="active">👥 Utilisateurs</a>
            <% } %>
        </div>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" style="color: var(--danger);">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="main-content">
        <div class="page-header">
            <h2>Gestion des utilisateurs</h2>
        </div>
        <% if (info != null && !info.isEmpty()) { %>
            <p class="success-text">✅ <%= info %></p>
        <% } %>
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <h3>Liste des utilisateurs</h3>
                <a href="<%= request.getContextPath() %>/users/create" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: var(--radius-md); text-decoration: none;">➕ Nouvel utilisateur</a>
            </div>
            <table>
                <tr>
                    <th>ID</th><th>Nom</th><th>Email</th><th>Role</th><th>Action</th>
                </tr>
                <% for (Utilisateur u : users) { %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getNomComplet() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getRole() %></td>
                    <td>
                        <% if (u.getId() != current.getId()) { %>
                        <form method="post" action="<%= request.getContextPath() %>/users/delete" class="inline-form" onsubmit="return confirm('Supprimer cet utilisateur ?');">
                            <input type="hidden" name="id" value="<%= u.getId() %>">
                            <button type="submit" class="danger-btn">Supprimer</button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</div>
</body>
</html>
