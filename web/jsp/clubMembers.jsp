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
    <title>Membres du club</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Membres actifs du club #<%= clubId %></h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/clubs">Retour clubs</a>
        </div>
    </div>
    <table>
        <tr><th>ID</th><th>Nom</th><th>Email</th>/tr>
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
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
