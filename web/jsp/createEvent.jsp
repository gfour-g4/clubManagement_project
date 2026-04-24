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
    <title>Creer evenement</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Creer un evenement</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/events">Retour liste evenements</a>
        </div>
    </div>

    <div class="card">
        <% if (request.getAttribute("error") != null) { %>
            <p class="error-text"><%= request.getAttribute("error") %></p>
        <% } %>
        <% if (clubs == null || clubs.isEmpty()) { %>
            <p class="muted">Aucun club assigne. Contactez un administrateur.</p>
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
                <input id="titre" type="text" name="titre" value="<%= oldTitre %>" required>
            </div>

            <div class="form-row">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="4"><%= oldDescription %></textarea>
            </div>

            <div class="form-row">
                <label for="dateEvenement">Date evenement</label>
                <input id="dateEvenement" type="datetime-local" name="dateEvenement" min="1970-01-01T00:00" value="<%= oldDateEvenement %>" required>
            </div>

            <div class="form-row">
                <label for="lieu">Lieu</label>
                <input id="lieu" type="text" name="lieu" value="<%= oldLieu %>" required>
            </div>

            <div class="form-actions">
                <button type="submit">Enregistrer</button>
            </div>
        </form>
        <% } %>
    </div>
</div>
</body>
</html>
