<%@ page import="java.util.List,java.util.Map,model.Evenement,model.Club,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    List<Evenement> events = (List<Evenement>) request.getAttribute("events");
    List<Evenement> registeredEvents = (List<Evenement>) request.getAttribute("registeredEvents");
    List<Evenement> upcomingClubEvents = (List<Evenement>) request.getAttribute("upcomingClubEvents");
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    Map<Integer, String> clubNamesById = (Map<Integer, String>) request.getAttribute("clubNamesById");
    Map<Integer, Boolean> registrationStatus = (Map<Integer, Boolean>) request.getAttribute("registrationStatus");
    Integer selectedClubId = (Integer) request.getAttribute("selectedClubId");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Événements - Gestion Clubs Universitaires</title>
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
            <h2>Liste des événements</h2>
        </div>
        <% if (info != null && !info.isEmpty()) { %>
            <p class="success-text">✅ <%= info %></p>
        <% } %>
        <% if ("ADMIN".equals(user.getRole()) || "RESPONSABLE".equals(user.getRole())) { %>
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 12px;">
                    <h3>Filtrer par club</h3>
                    <a href="<%= request.getContextPath() %>/events/create" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: var(--radius-md); text-decoration: none;">➕ Nouvel événement</a>
                </div>
                <form method="get" action="<%= request.getContextPath() %>/events" class="inline-form" style="gap: 12px; align-items: flex-end;">
                    <div style="flex: 1; max-width: 300px;">
                        <label style="display: block; margin-bottom: 6px; color: var(--gray-700); font-weight: 500; font-size: 14px;">Club</label>
                        <select name="clubId" style="width: 100%;">
                            <option value="">Tous</option>
                            <% for (Club c : clubs) { %>
                                <option value="<%= c.getId() %>" <%= selectedClubId != null && selectedClubId == c.getId() ? "selected" : "" %>><%= c.getNom() %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit">Filtrer</button>
                </form>
            </div>
        <% } %>

        <% if ("MEMBRE".equals(user.getRole()) || "ETUDIANT".equals(user.getRole())) { %>
            <div class="card">
                <h3>Événements auxquels je suis inscrit</h3>
                <% if (registeredEvents == null || registeredEvents.isEmpty()) { %>
                    <p style="color: var(--text-muted);">Vous n'êtes inscrit à aucun événement.</p>
                <% } else { %>
                    <table>
                        <tr><th>Titre</th><th>Date</th><th>Lieu</th><th>Actions</th></tr>
                        <% for (Evenement e : registeredEvents) { %>
                        <tr>
                            <td><a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>"><%= e.getTitre() %></a></td>
                            <td><%= e.getDateEvenement() %></td>
                            <td><%= e.getLieu() %></td>
                            <td>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>" style="background: var(--primary); color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; text-align: center;">Voir détails</a>
                                    <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
                                        <input type="hidden" name="eventId" value="<%= e.getId() %>">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="redirectUrl" value="/events">
                                        <button type="submit" class="danger-btn" style="width: 100%;">Annuler</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>

            <div class="card">
                <h3>Événements à venir pour mes clubs</h3>
                <% if (upcomingClubEvents == null || upcomingClubEvents.isEmpty()) { %>
                    <p style="color: var(--text-muted);">Aucun événement à venir pour vos clubs.</p>
                <% } else { %>
                    <table>
                        <tr><th>Titre</th><th>Date</th><th>Lieu</th><th>Actions</th></tr>
                        <% for (Evenement e : upcomingClubEvents) { %>
                        <tr>
                            <td><a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>"><%= e.getTitre() %></a></td>
                            <td><%= e.getDateEvenement() %></td>
                            <td><%= e.getLieu() %></td>
                            <td>
                                <div style="display: flex; flex-direction: column; gap: 8px;">
                                    <a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>" style="background: var(--primary); color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; text-align: center;">Voir détails</a>
                                    <% 
                                        boolean isRegisteredHere = false;
                                        if (registrationStatus != null && registrationStatus.containsKey(e.getId())) {
                                            isRegisteredHere = Boolean.TRUE.equals(registrationStatus.get(e.getId()));
                                        }
                                    %>
                                    <% if (!isRegisteredHere) { %>
                                        <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
                                            <input type="hidden" name="eventId" value="<%= e.getId() %>">
                                            <input type="hidden" name="action" value="register">
                                            <input type="hidden" name="redirectUrl" value="/events">
                                            <button type="submit" style="width: 100%;">S'inscrire</button>
                                        </form>
                                    <% } else { %>
                                        <form method="post" action="<%= request.getContextPath() %>/events/register" class="inline-form">
                                            <input type="hidden" name="eventId" value="<%= e.getId() %>">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="redirectUrl" value="/events">
                                            <button type="submit" class="danger-btn" style="width: 100%;">Annuler</button>
                                        </form>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>
        <% } else { %>
            <div class="card">
                <h3>Tous les événements</h3>
                <table>
                    <tr><th>ID</th><th>Club</th><th>Titre</th><th>Date</th><th>Lieu</th><th>Action</th></tr>
                    <% if (events == null || events.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="muted">Aucun événement trouvé pour ce filtre.</td>
                    </tr>
                    <% } %>
                    <% for (Evenement e : events) { %>
                    <tr>
                        <td><%= e.getId() %></td>
                        <td><%= clubNamesById.get(e.getClubId()) != null ? clubNamesById.get(e.getClubId()) : ("Club #" + e.getClubId()) %></td>
                        <td><a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>"><%= e.getTitre() %></a></td>
                        <td><%= e.getDateEvenement() %></td>
                        <td><%= e.getLieu() %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>" style="background: var(--primary); color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px;">Voir détails</a>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
