<%@ page import="model.Utilisateur,model.Evenement,model.Club,java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    Evenement event = (Evenement) request.getAttribute("event");
    Club club = (Club) request.getAttribute("club");
    Boolean isRegistered = (Boolean) request.getAttribute("isRegistered");
    Boolean canViewMembers = (Boolean) request.getAttribute("canViewMembers");
    List<Utilisateur> registeredUsers = (List<Utilisateur>) request.getAttribute("registeredUsers");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Événement - <%= event.getTitre() %> - Gestion Clubs Universitaires</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-inscrit {
            background: #ecfdf5;
            color: #059669;
        }
    </style>
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
            <% if ("ADMIN".equals(user.getRole())) { %>
                <a href="<%= request.getContextPath() %>/users">👥 Utilisateurs</a>
            <% } %>
        </div>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" style="color: var(--danger);">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="main-content">
        <div class="page-header">
            <h2>Événement: <%= event.getTitre() %></h2>
        </div>

        <% if (info != null && !info.isEmpty()) { %>
            <p class="success-text">✅ <%= info %></p>
        <% } %>

        <div class="card">
            <h3>Détails</h3>
            <p style="margin: 12px 0;"><strong>Titre:</strong> <%= event.getTitre() %></p>
            <p style="margin: 12px 0;"><strong>Description:</strong> <%= event.getDescription() %></p>
            <p style="margin: 12px 0;"><strong>Date:</strong> <%= event.getDateEvenement() %></p>
            <p style="margin: 12px 0;"><strong>Lieu:</strong> <%= event.getLieu() %></p>
            <p style="margin: 12px 0;"><strong>Club:</strong>
                <% if (club != null) { %>
                    <a href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>"><%= club.getNom() %></a>
                <% } else { %>
                    -
                <% } %>
            </p>

            <% if ("MEMBRE".equals(user.getRole()) || "ETUDIANT".equals(user.getRole())) { %>
                <div style="margin-top: 16px;">
                    <p style="margin: 12px 0;"><strong>Statut d'inscription:</strong>
                        <% if (Boolean.TRUE.equals(isRegistered)) { %>
                            <span class="status-badge status-inscrit">Inscrit</span>
                        <% } else { %>
                            <span class="muted">Non inscrit</span>
                        <% } %>
                    </p>
                    <div class="actions" style="margin-top: 16px;">
                        <% if (!Boolean.TRUE.equals(isRegistered)) { %>
                            <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
                                <input type="hidden" name="eventId" value="<%= event.getId() %>">
                                <input type="hidden" name="action" value="register">
                                <input type="hidden" name="redirectUrl" value="/events/view">
                                <input type="hidden" name="eventIdParam" value="id">
                                <button type="submit">S'inscrire</button>
                            </form>
                        <% } else { %>
                            <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
                                <input type="hidden" name="eventId" value="<%= event.getId() %>">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="redirectUrl" value="/events/view">
                                <input type="hidden" name="eventIdParam" value="id">
                                <button type="submit" class="danger-btn">Annuler l'inscription</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>

        <% if (Boolean.TRUE.equals(canViewMembers)) { %>
            <div class="card">
                <h3>Membres inscrits à cet événement</h3>
                <% if (registeredUsers == null || registeredUsers.isEmpty()) { %>
                    <p class="muted" style="text-align: center; padding: 40px 0;">Aucun membre inscrit à cet événement.</p>
                <% } else { %>
                    <table>
                        <tr><th>ID</th><th>Nom</th><th>Email</th><th>Rôle</th></tr>
                        <% for (Utilisateur u : registeredUsers) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getNomComplet() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getRole() %></td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
