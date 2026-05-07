# Rôles et Fonctionnalités

## Rôles disponibles
- **ADMIN**: Administrateur système
- **RESPONSABLE**: Responsable de club (gère uniquement ses propres clubs)
- **MEMBRE** (ou autre): Membre étudiant

---

## Dashboard par Rôle

### ADMIN
- **Statistiques**: Nombre de membres par club
- **Événements**: Tous les événements à venir
- **Accès**: Toutes les pages

### RESPONSABLE
- **Mes Clubs**: Liste des clubs dont il est responsable
- **Événements**: Événements à venir pour ses clubs uniquement
- **Aucun accès global**: Pas d'accès à d'autres clubs ou événements non liés à ses clubs

### MEMBRE
- **Mes Clubs**: Liste des clubs dont il est membre actif
- **Événements**: Événements à venir pour ses clubs
- **Actions**: Consultation + inscription aux événements

---

## Accès aux Pages par Rôle

| Page | ADMIN | RESPONSABLE | MEMBRE |
|------|-------|--------------|--------|
| /login | ✅ | ✅ | ✅ |
| /dashboard | ✅ | ✅ | ✅ |
| /my-events | ✅ | ✅ | ✅ |
| /clubs | ✅ | ✅ | ✅ |
| /clubs/create | ✅ | ❌ | ❌ |
| /clubs/view | ✅ | ✅ | ✅ |
| /events | ✅ | ✅ | ✅ |
| /events/create | ✅ | ✅ | ❌ |
| /users | ✅ | ❌ | ❌ |
| /users/create | ✅ | ❌ | ❌ |
| /users/delete | ✅ | ❌ | ❌ |

---

## Fonctionnalités Clés

### "Mes Événements"
Page unique pour tous les utilisateurs affichant:
- Événements auxquels je suis inscrit
- Événements de mes clubs (si responsable/membre)

### Gestion des Clubs
- Boutons "Rejoindre / Quitter club"
- Statut membre simple (actif ou non)

### UI
- Badge rôle sur utilisateur (ADMIN / RESPONSABLE / MEMBRE)
- Rôle actif affiché partout

