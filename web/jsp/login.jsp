<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="card">
        <h2>Gestion Clubs Universitaires - Connexion</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-text"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/login" class="form-layout">
            <div class="form-row">
                <label for="email">Email</label>
                <input id="email" type="email" name="email" required>
            </div>
            <div class="form-row">
                <label for="motDePasse">Mot de passe</label>
                <input id="motDePasse" type="password" name="motDePasse" required>
            </div>
            <div class="form-actions">
                <button type="submit">Se connecter</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
