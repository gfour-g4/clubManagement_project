<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String oldNomComplet = request.getAttribute("oldNomComplet") != null ? (String) request.getAttribute("oldNomComplet") : "";
    String oldEmail = request.getAttribute("oldEmail") != null ? (String) request.getAttribute("oldEmail") : "";
    String oldRole = request.getAttribute("oldRole") != null ? (String) request.getAttribute("oldRole") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Creer utilisateur</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Creer un utilisateur</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/users">Retour liste utilisateurs</a>
        </div>
    </div>

    <div class="card">
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-text"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/users/create" class="form-layout">
            <div class="form-row">
                <label for="nomComplet">Nom complet</label>
                <input id="nomComplet" type="text" name="nomComplet" value="<%= oldNomComplet %>" required>
            </div>

            <div class="form-row">
                <label for="email">Email</label>
                <input id="email" type="email" name="email" value="<%= oldEmail %>" required>
            </div>

            <div class="form-row">
                <label for="motDePasse">Mot de passe</label>
                <input id="motDePasse" type="password" name="motDePasse" required>
            </div>

            <div class="form-row">
                <label for="role">Role</label>
                <select id="role" name="role">
                    <option value="ETUDIANT" <%= "ETUDIANT".equals(oldRole) ? "selected" : "" %>>ETUDIANT</option>
                    <option value="ADMIN" <%= "ADMIN".equals(oldRole) ? "selected" : "" %>>ADMIN</option>
                    <option value="RESPONSABLE_CLUB" <%= "RESPONSABLE_CLUB".equals(oldRole) ? "selected" : "" %>>RESPONSABLE_CLUB</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit">Enregistrer</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
