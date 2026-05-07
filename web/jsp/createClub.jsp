<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer club - Gestion Clubs Universitaires</title>
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
            <h2>Créer un club</h2>
        </div>
        <div class="card">
            <form method="post" action="<%= request.getContextPath() %>/clubs/create" class="form-layout">
                <div class="form-row">
                    <label for="nom">Nom</label>
                    <input id="nom" type="text" name="nom" required placeholder="Nom du club">
                </div>
                <div class="form-row">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="4" placeholder="Description du club..."></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit">Enregistrer</button>
                    <a href="<%= request.getContextPath() %>/clubs" style="padding: 12px 24px; border-radius: var(--radius-md); text-decoration: none; background: var(--gray-100); color: var(--gray-700); font-weight: 600;">Annuler</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
