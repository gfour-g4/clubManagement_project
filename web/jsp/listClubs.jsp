<%@ page import="java.util.List,java.util.Map,model.Club,model.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Utilisateur user = (Utilisateur) session.getAttribute("user");
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    Map<Integer, String> clubResponsables = (Map<Integer, String>) request.getAttribute("clubResponsables");
    Map<Integer, Boolean> membershipStatus = (Map<Integer, Boolean>) request.getAttribute("membershipStatus");
    String info = request.getParameter("info");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clubs - Gestion Clubs Universitaires</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .club-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .club-item {
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            transition: all 0.15s ease;
        }
        .club-item:hover {
            border-color: var(--primary);
        }
        .club-info h3 {
            margin: 0 0 6px 0;
            font-size: 16px;
            font-weight: 600;
        }
        .club-info p {
            margin: 0;
            font-size: 14px;
            color: var(--text-muted);
            line-height: 1.5;
        }
        .club-meta {
            margin-top: 10px;
            display: flex;
            gap: 16px;
            font-size: 13px;
            color: var(--text-muted);
        }
        .club-action {
            flex-shrink: 0;
            margin-left: 20px;
        }
        .member-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
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
            <h2>Liste des clubs</h2>
        </div>
        <% if (info != null && !info.isEmpty()) { %>
            <p class="success-text">✅ <%= info %></p>
        <% } %>
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <h3>Tous les clubs</h3>
                <% if ("ADMIN".equals(user.getRole())) { %>
                    <a href="<%= request.getContextPath() %>/clubs/create" style="background: var(--primary); color: white; padding: 10px 20px; border-radius: var(--radius-md); text-decoration: none;">➕ Nouveau club</a>
                <% } %>
            </div>
            <% if (clubs == null || clubs.isEmpty()) { %>
                <p class="muted" style="text-align: center; padding: 40px 0;">Aucun club trouvé.</p>
            <% } else { %>
                <div class="club-list">
                    <% for (Club c : clubs) { %>
                        <div class="club-item">
                            <div>
                                <div class="club-info">
                                    <h3><%= c.getNom() %></h3>
                                    <p><%= c.getDescription() %></p>
                                </div>
                                <div class="club-meta">
                                    <span>👤 <%= clubResponsables.get(c.getId()) != null ? clubResponsables.get(c.getId()) : "Non assigné" %></span>
                                    <% if ("MEMBRE".equals(user.getRole()) || "ETUDIANT".equals(user.getRole())) { %>
                                        <% if (Boolean.TRUE.equals(membershipStatus.get(c.getId()))) { %>
                                            <span class="member-badge">Membre</span>
                                        <% } %>
                                    <% } %>
                                </div>
                            </div>
                            <div class="club-action">
                                <a href="<%= request.getContextPath() %>/clubs/view?id=<%= c.getId() %>" style="background: var(--primary); color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 14px;">Voir détails</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
