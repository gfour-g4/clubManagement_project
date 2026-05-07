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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer utilisateur - Gestion Clubs Universitaires</title>
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
            <a href="<%= request.getContextPath() %>/users" class="active">👥 Utilisateurs</a>
        </div>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" style="color: var(--danger);">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="main-content">
        <div class="page-header">
            <h2>Créer un utilisateur</h2>
        </div>

        <div class="card">
            <% if (request.getAttribute("error") != null) { %>
                <p class="error-text">⚠️ <%= request.getAttribute("error") %></p>
            <% } %>
            <form method="post" action="<%= request.getContextPath() %>/users/create" class="form-layout">
                <div class="form-row">
                    <label for="nomComplet">Nom complet</label>
                    <input id="nomComplet" type="text" name="nomComplet" value="<%= oldNomComplet %>" required placeholder="Jean Dupont">
                </div>

                <div class="form-row">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" value="<%= oldEmail %>" required placeholder="jean.dupont@universite.fr">
                </div>

                <div class="form-row">
                    <label for="motDePasse">Mot de passe</label>
                    <input id="motDePasse" type="password" name="motDePasse" required placeholder="••••••••">
                </div>

                <div class="form-row">
                    <label for="role">Rôle</label>
                    <select id="role" name="role">
                        <option value="MEMBRE" <%= "MEMBRE".equals(oldRole) ? "selected" : "" %>>Membre</option>
                        <option value="ADMIN" <%= "ADMIN".equals(oldRole) ? "selected" : "" %>>Administrateur</option>
                        <option value="RESPONSABLE" <%= "RESPONSABLE".equals(oldRole) ? "selected" : "" %>>Responsable Club</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit">Enregistrer</button>
                    <a href="<%= request.getContextPath() %>/users" style="padding: 12px 24px; border-radius: var(--radius-md); text-decoration: none; background: var(--gray-100); color: var(--gray-700); font-weight: 600;">Annuler</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
