<%@ page import="model.Utilisateur,java.util.Map,java.util.List,model.Evenement,model.Club" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    String role = user.getRole();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestion Clubs Universitaires</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="app-container">
    <div class="sidebar">
        <div class="sidebar-header">
            <h1>🎓 Club Management</h1>
        </div>
        <div class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/dashboard" class="active">🏠 Dashboard</a>
            <a href="<%= request.getContextPath() %>/clubs">🏛️ Clubs</a>
            <a href="<%= request.getContextPath() %>/events">📅 Événements</a>
            <% if ("ADMIN".equals(role)) { %>
                <a href="<%= request.getContextPath() %>/users">👥 Utilisateurs</a>
            <% } %>
        </div>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" style="color: var(--danger);">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="main-content">
        <div class="page-header">
            <h2>Bienvenue <%= user.getNomComplet() %> (<%= role %>)</h2>
        </div>

        <% if ("ADMIN".equals(role)) { %>
            <%
                Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("statsMembres");
                List<Evenement> events = (List<Evenement>) request.getAttribute("upcomingEvents");
                List<Club> allClubs = (List<Club>) request.getAttribute("allClubs");
            %>
            <div class="card">
                <h3>Statistiques: Nombre de membres par club</h3>
                <table>
                    <tr><th>Club</th><th>Nombre membres actifs</th></tr>
                    <% for (Map.Entry<String, Integer> e : stats.entrySet()) { %>
                    <tr>
                        <td><%= e.getKey() %></td>
                        <td><%= e.getValue() %></td>
                    </tr>
                    <% } %>
                </table>
            </div>

            <div class="card">
                <h3>Événements à venir</h3>
                <table>
                    <tr><th>Titre</th><th>Date</th><th>Lieu</th><th>Action</th></tr>
                    <% for (Evenement e : events) { %>
                    <tr>
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
        <% } else if ("RESPONSABLE".equals(role)) { %>
            <%
                List<Club> myClubs = (List<Club>) request.getAttribute("myClubs");
                List<Evenement> myEvents = (List<Evenement>) request.getAttribute("myUpcomingEvents");
            %>
            <div class="card">
                <h3>Mes Clubs</h3>
                <% if (myClubs.isEmpty()) { %>
                    <p style="color: var(--text-muted);">Vous n'êtes responsable d'aucun club pour le moment.</p>
                <% } else { %>
                    <table>
                        <tr><th>Nom</th><th>Description</th><th>Date de création</th></tr>
                        <% for (Club c : myClubs) { %>
                        <tr>
                            <td><a href="<%= request.getContextPath() %>/clubs/view?id=<%= c.getId() %>"><%= c.getNom() %></a></td>
                            <td><%= c.getDescription() %></td>
                            <td><%= c.getDateCreation() %></td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>

            <div class="card">
                <h3>Événements à venir pour mes clubs</h3>
                <% if (myEvents.isEmpty()) { %>
                    <p style="color: var(--text-muted);">Aucun événement à venir pour vos clubs.</p>
                <% } else { %>
                    <table>
                        <tr><th>Titre</th><th>Date</th><th>Lieu</th><th>Action</th></tr>
                    <% for (Evenement e : myEvents) { %>
                    <tr>
                        <td><a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>"><%= e.getTitre() %></a></td>
                        <td><%= e.getDateEvenement() %></td>
                        <td><%= e.getLieu() %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>" style="background: var(--primary); color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px;">Voir détails</a>
                        </td>
                    </tr>
                    <% } %>
                    </table>
                <% } %>
            </div>
        <% } else { %>
            <%
                List<Club> myClubs = (List<Club>) request.getAttribute("myClubs");
                List<Evenement> myEvents = (List<Evenement>) request.getAttribute("myUpcomingEvents");
            %>
            <div class="card">
                <h3>Mes Clubs</h3>
                <% if (myClubs.isEmpty()) { %>
                    <p style="color: var(--text-muted);">Vous n'êtes membre d'aucun club pour le moment. Allez voir la liste des clubs !</p>
                <% } else { %>
                    <table>
                        <tr><th>Nom</th><th>Description</th></tr>
                        <% for (Club c : myClubs) { %>
                        <tr>
                            <td><a href="<%= request.getContextPath() %>/clubs/view?id=<%= c.getId() %>"><%= c.getNom() %></a></td>
                            <td><%= c.getDescription() %></td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>

            <div class="card">
                <h3>Événements à venir pour mes clubs</h3>
                <% if (myEvents.isEmpty()) { %>
                    <p style="color: var(--text-muted);">Aucun événement à venir pour vos clubs.</p>
                <% } else { %>
                    <table>
                        <tr><th>Titre</th><th>Date</th><th>Lieu</th><th>Action</th></tr>
                    <% for (Evenement e : myEvents) { %>
                    <tr>
                        <td><a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>"><%= e.getTitre() %></a></td>
                        <td><%= e.getDateEvenement() %></td>
                        <td><%= e.getLieu() %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>" style="background: var(--primary); color: white; padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px;">Voir détails</a>
                        </td>
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
