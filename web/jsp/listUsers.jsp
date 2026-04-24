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
    <title>Utilisateurs</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Gestion des utilisateurs</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            <a href="<%= request.getContextPath() %>/users/create">Nouvel utilisateur</a>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>
    </div>
<% if (info != null && !info.isEmpty()) { %>
    <p class="success-text"><%= info %></p>
<% } %>
<table>
    <tr>
        <th>ID</th><th>Nom</th><th>Email</th><th>Role</th><th>View</th>
    </tr>
    <% for (Utilisateur u : users) { %>
    <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getNomComplet() %></td>
        <td><%= u.getEmail() %></td>
        <td><%= u.getRole() %></td>
        <td><a href="<%= request.getContextPath() %>/users/view?id=<%= u.getId() %>">Voir</a></td>
    </tr>
    <% } %>
</table>
</div>
</body>
</html>
