<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Creer club</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>Creer un club</h2>
        <div class="nav">
            <a href="<%= request.getContextPath() %>/clubs">Retour liste clubs</a>
        </div>
    </div>
    <div class="card">
        <form method="post" action="<%= request.getContextPath() %>/clubs/create" class="form-layout">
            <div class="form-row">
                <label for="nom">Nom</label>
                <input id="nom" type="text" name="nom" required>
            </div>
            <div class="form-row">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="4"></textarea>
            </div>
            <div class="form-actions">
                <button type="submit">Enregistrer</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
