<%@ page import="java.util.List,model.Club" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    String oldTitre = request.getAttribute("oldTitre") != null ? (String) request.getAttribute("oldTitre") : "";
    String oldDescription = request.getAttribute("oldDescription") != null ? (String) request.getAttribute("oldDescription") : "";
    String oldDateEvenement = request.getAttribute("oldDateEvenement") != null ? (String) request.getAttribute("oldDateEvenement") : "";
    String oldLieu = request.getAttribute("oldLieu") != null ? (String) request.getAttribute("oldLieu") : "";
    String oldClubId = request.getAttribute("oldClubId") != null ? (String) request.getAttribute("oldClubId") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer événement - Gestion Clubs Universitaires</title>
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
            <a href="<%= request.getContextPath() %>/events" class="active">📅 Événements</a>
        </div>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" style="color: var(--danger);">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="main-content">
        <div class="page-header">
            <h2>Créer un événement</h2>
        </div>

        <div class="card">
            <% if (request.getAttribute("error") != null) { %>
                <p class="error-text">⚠️ <%= request.getAttribute("error") %></p>
            <% } %>
            <% if (clubs == null || clubs.isEmpty()) { %>
                <p class="muted">Aucun club assigné. Contactez un administrateur.</p>
            <% } else { %>
            <form method="post" action="<%= request.getContextPath() %>/events/create" class="form-layout">
                <div class="form-row">
                    <label for="clubId">Club</label>
                    <select id="clubId" name="clubId" required>
                        <% for (Club c : clubs) { %>
                            <option value="<%= c.getId() %>" <%= String.valueOf(c.getId()).equals(oldClubId) ? "selected" : "" %>><%= c.getNom() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-row">
                    <label for="titre">Titre</label>
                    <input id="titre" type="text" name="titre" value="<%= oldTitre %>" required placeholder="Titre de l'événement">
                </div>

                <div class="form-row">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="4" placeholder="Description de l'événement..."><%= oldDescription %></textarea>
                </div>

                <div class="form-row">
                    <label for="dateEvenement">Date et heure</label>
                    <input id="dateEvenement" type="datetime-local" name="dateEvenement" min="1970-01-01T00:00" value="<%= oldDateEvenement %>" required>
                </div>

                <div class="form-row">
                    <label for="lieu">Lieu</label>
                    <input id="lieu" type="text" name="lieu" value="<%= oldLieu %>" required placeholder="Salle A, Amphithéâtre B, ...">
                </div>

                <div class="form-actions">
                    <button type="submit">Enregistrer</button>
                    <a href="<%= request.getContextPath() %>/events" style="padding: 12px 24px; border-radius: var(--radius-md); text-decoration: none; background: var(--gray-100); color: var(--gray-700); font-weight: 600;">Annuler</a>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
