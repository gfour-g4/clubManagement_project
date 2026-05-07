<%@ page import="java.util.List,model.Club,model.Evenement,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    Club club = (Club) request.getAttribute("club");
    List<Evenement> events = (List<Evenement>) request.getAttribute("events");
    List<Utilisateur> members = (List<Utilisateur>) request.getAttribute("members");
    List<Utilisateur> responsables = (List<Utilisateur>) request.getAttribute("responsables");
    String responsableName = (String) request.getAttribute("responsableName");
    String activeTab = (String) request.getAttribute("activeTab");
    Boolean isStudentMember = (Boolean) request.getAttribute("isStudentMember");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club - <%= club.getNom() %> - Gestion Clubs Universitaires</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .club-header-section {
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 20px;
        }
        .club-header-section h1 {
            margin: 0 0 8px 0;
            font-size: 22px;
            font-weight: 600;
        }
        .club-header-section p {
            margin: 0 0 16px 0;
            color: var(--text-muted);
        }
        .event-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .event-item {
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 6px;
        }
        .event-item h4 {
            margin: 0 0 6px 0;
            font-size: 15px;
            font-weight: 600;
        }
        .event-item p {
            margin: 0;
            font-size: 13px;
            color: var(--text-muted);
        }
        .member-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .member-item {
            padding: 12px 16px;
            border: 1px solid var(--border);
            border-radius: 6px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .member-item .name {
            font-weight: 500;
        }
        .member-item .email {
            font-size: 13px;
            color: var(--text-muted);
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
            <a href="<%= request.getContextPath() %>/clubs" class="active">🏛️ Clubs</a>
            <a href="<%= request.getContextPath() %>/events">📅 Événements</a>
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
            <h2>Club: <%= club.getNom() %></h2>
        </div>

        <% if (info != null && !info.isEmpty()) { %>
        <p class="success-text">✅ <%= info %></p>
        <% } %>

        <div class="club-header-section">
            <h1><%= club.getNom() %></h1>
            <p><%= club.getDescription() %></p>
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div style="font-size: 14px; color: var(--text-muted);">
                    👤 Responsable: <%= responsableName != null ? responsableName : "Non assigné" %>
                </div>
                <% if ("MEMBRE".equals(user.getRole()) || "ETUDIANT".equals(user.getRole())) { %>
                    <div class="actions" style="margin: 0;">
                        <% if (Boolean.TRUE.equals(isStudentMember)) { %>
                        <form method="post" action="<%= request.getContextPath() %>/membership" class="inline-form">
                            <input type="hidden" name="clubId" value="<%= club.getId() %>">
                            <input type="hidden" name="action" value="leave">
                            <input type="hidden" name="redirectClubId" value="<%= club.getId() %>">
                            <button type="submit" class="danger-btn">Quitter ce club</button>
                        </form>
                        <% } else { %>
                        <form method="post" action="<%= request.getContextPath() %>/membership" class="inline-form">
                            <input type="hidden" name="clubId" value="<%= club.getId() %>">
                            <input type="hidden" name="action" value="join">
                            <input type="hidden" name="redirectClubId" value="<%= club.getId() %>">
                            <button type="submit">Adhérer à ce club</button>
                        </form>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>

        <div class="card">
            <div class="tabs">
                <a class="<%= "info".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=info">ℹ️ Info</a>
                <a class="<%= "events".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=events">📅 Événements</a>
                <a class="<%= "members".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=members">👥 Membres</a>
                <% if ("ADMIN".equals(user.getRole())) { %>
                    <a class="<%= "assign".equals(activeTab) ? "tab active" : "tab" %>" href="<%= request.getContextPath() %>/clubs/view?id=<%= club.getId() %>&tab=assign">👤 Assigner responsable</a>
                <% } %>
            </div>

            <% if ("info".equals(activeTab)) { %>
            <div style="margin-top: 20px;">
                <p style="margin: 12px 0;"><strong>Nom:</strong> <%= club.getNom() %></p>
                <p style="margin: 12px 0;"><strong>Description:</strong> <%= club.getDescription() %></p>
                <p style="margin: 12px 0;"><strong>Responsable:</strong> <%= responsableName != null ? responsableName : "Non assigné" %></p>
                <p style="margin: 12px 0;"><strong>Date de création:</strong> <%= club.getDateCreation() %></p>
            </div>
            <% } %>

            <% if ("events".equals(activeTab)) { %>
            <div style="margin-top: 20px;">
                <h3 style="margin: 0 0 16px 0;">Événements du club</h3>
                <% if (events == null || events.isEmpty()) { %>
                    <p class="muted" style="text-align: center; padding: 40px 0;">Aucun événement pour ce club.</p>
                <% } else { %>
                    <div class="event-list">
                        <% for (Evenement e : events) { %>
                            <a href="<%= request.getContextPath() %>/events/view?id=<%= e.getId() %>" style="text-decoration: none; color: inherit;">
                                <div class="event-item" style="cursor: pointer;">
                                    <h4><%= e.getTitre() %></h4>
                                    <p><%= e.getDescription() %></p>
                                    <p style="margin-top: 8px; font-size: 13px;">
                                        <span style="margin-right: 16px;">📅 <%= e.getDateEvenement() %></span>
                                        <span>📍 <%= e.getLieu() %></span>
                                    </p>
                                </div>
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
            <% } %>

            <% if ("members".equals(activeTab)) { %>
            <div style="margin-top: 20px;">
                <h3 style="margin: 0 0 16px 0;">Membres du club</h3>
                <% if (members == null || members.isEmpty()) { %>
                    <p class="muted" style="text-align: center; padding: 40px 0;">Aucun membre actif.</p>
                <% } else { %>
                    <div class="member-list">
                        <% for (Utilisateur m : members) { %>
                            <div class="member-item">
                                <div>
                                    <div class="name"><%= m.getNomComplet() %></div>
                                    <div class="email"><%= m.getEmail() %></div>
                                </div>
                                <div style="font-size: 13px; color: var(--text-muted);"><%= m.getRole() %></div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            <% } %>

            <% if ("assign".equals(activeTab) && "ADMIN".equals(user.getRole())) { %>
            <div style="margin-top: 20px;">
                <h3 style="margin: 0 0 16px 0;">Assigner un responsable</h3>
                <form method="post" action="<%= request.getContextPath() %>/clubs/assign-responsable" class="form-layout">
                    <input type="hidden" name="clubId" value="<%= club.getId() %>">
                    <input type="hidden" name="redirectClubId" value="<%= club.getId() %>">
                    <div class="form-row">
                        <label for="utilisateurId">Responsable</label>
                        <select id="utilisateurId" name="utilisateurId" required>
                            <% for (Utilisateur r : responsables) { %>
                                <option value="<%= r.getId() %>"><%= r.getNomComplet() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Assigner</button>
                    </div>
                </form>
            </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
