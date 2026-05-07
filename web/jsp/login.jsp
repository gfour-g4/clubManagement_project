<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Gestion Clubs Universitaires</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div style="max-width: 480px; margin: 48px auto;">
        <div style="text-align: center; margin-bottom: 32px;">
            <div style="width: 80px; height: 80px; background: white; border-radius: 20px; display: inline-flex; align-items: center; justify-content: center; box-shadow: var(--shadow-lg); margin-bottom: 20px;">
                <span style="font-size: 40px;">🎓</span>
            </div>
            <h1 style="margin: 0; font-size: 28px; font-weight: 700;">Gestion Clubs Universitaires</h1>
            <p style="margin: 8px 0 0; font-size: 15px;">Connectez-vous pour continuer</p>
        </div>
        
        <div class="card">
            <% if (request.getAttribute("error") != null) { %>
                <p class="error-text">⚠️ <%= request.getAttribute("error") %></p>
            <% } %>
            <form method="post" action="<%= request.getContextPath() %>/login" class="form-layout">
                <div class="form-row">
                    <label for="email">Adresse email</label>
                    <input id="email" type="email" name="email" required placeholder="ex: jean.dupont@universite.fr">
                </div>
                <div class="form-row">
                    <label for="motDePasse">Mot de passe</label>
                    <input id="motDePasse" type="password" name="motDePasse" required placeholder="••••••••">
                </div>
                <div class="form-actions">
                    <button type="submit" style="width: 100%;">Se connecter</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
