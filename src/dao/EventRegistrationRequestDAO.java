package dao;

import model.EventRegistrationRequest;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class EventRegistrationRequestDAO {
    private final InscriptionEvenementDAO inscriptionDAO = new InscriptionEvenementDAO();
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public String requestRegister(int eventId, int utilisateurId) {
        if (inscriptionDAO.isRegistered(eventId, utilisateurId)) {
            return "Vous+etes+deja+inscrit+à+cet+evenement.";
        }
        if (isPendingRegistration(eventId, utilisateurId)) {
            return "Demande+d'inscription+deja+en+attente.";
        }

        try (Connection conn = DBConnection.getConnection()) {
            Integer clubId = null;
            String eventTitle = null;
            Integer responsableId = null;

            String eventSql = "SELECT club_id, titre FROM evenements WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(eventSql)) {
                ps.setInt(1, eventId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        clubId = rs.getInt("club_id");
                        eventTitle = rs.getString("titre");
                    }
                }
            }

            if (clubId == null) {
                throw new RuntimeException("Evenement introuvable.");
            }

            String respSql = "SELECT utilisateur_id FROM responsables_clubs WHERE club_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(respSql)) {
                ps.setInt(1, clubId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        responsableId = rs.getInt(1);
                    }
                }
            }

            // Fallback: if no responsable assigned, auto-approve.
            if (responsableId == null) {
                inscriptionDAO.register(eventId, utilisateurId);
                notificationDAO.create(utilisateurId,
                        "Votre demande d'inscription pour l'événement " + eventTitle + " a été acceptée.");
                return "Demande+automatiquement+acceptée.";
            }

            String insertSql = "INSERT INTO event_registration_requests (evenement_id, utilisateur_id, club_id, responsable_id, statut) " +
                    "VALUES (?, ?, ?, ?, 'EN_ATTENTE')";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, eventId);
                ps.setInt(2, utilisateurId);
                ps.setInt(3, clubId);
                ps.setInt(4, responsableId);
                ps.executeUpdate();
            }

            return "Demande+d'inscription+envoyee+au+responsable.";
        } catch (Exception e) {
            throw new RuntimeException("Erreur creation demande inscription evenement", e);
        }
    }

    public boolean isPendingRegistration(int eventId, int utilisateurId) {
        String sql = "SELECT 1 FROM event_registration_requests WHERE evenement_id = ? AND utilisateur_id = ? AND statut = 'EN_ATTENTE' LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur verification demande inscription evenement", e);
        }
    }

    public Set<Integer> findPendingEventIdsByUtilisateur(int utilisateurId) {
        String sql = "SELECT evenement_id FROM event_registration_requests WHERE utilisateur_id = ? AND statut = 'EN_ATTENTE'";
        Set<Integer> eventIds = new HashSet<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    eventIds.add(rs.getInt("evenement_id"));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste demandes inscription en attente", e);
        }
        return eventIds;
    }

    public List<EventRegistrationRequest> findPendingByResponsableAndClub(int responsableId, int clubId) {
        String sql = "SELECT err.id, err.evenement_id, e.titre, e.date_evenement, e.lieu, " +
                "err.utilisateur_id, u.nom_complet, u.email, " +
                "err.club_id, c.nom, err.responsable_id, err.statut, err.date_demande " +
                "FROM event_registration_requests err " +
                "JOIN evenements e ON e.id = err.evenement_id " +
                "JOIN utilisateurs u ON u.id = err.utilisateur_id " +
                "JOIN clubs c ON c.id = err.club_id " +
                "WHERE err.responsable_id = ? AND err.club_id = ? AND err.statut = 'EN_ATTENTE' " +
                "ORDER BY err.date_demande ASC";
        List<EventRegistrationRequest> requests = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, responsableId);
            ps.setInt(2, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EventRegistrationRequest req = new EventRegistrationRequest();
                    req.setId(rs.getInt("id"));
                    req.setEvenementId(rs.getInt("evenement_id"));
                    req.setEvenementTitre(rs.getString("titre"));
                    Timestamp tsEvent = rs.getTimestamp("date_evenement");
                    req.setEvenementDate(tsEvent);
                    req.setEvenementLieu(rs.getString("lieu"));

                    req.setUtilisateurId(rs.getInt("utilisateur_id"));
                    req.setUtilisateurNomComplet(rs.getString("nom_complet"));
                    req.setUtilisateurEmail(rs.getString("email"));

                    req.setClubId(rs.getInt("club_id"));
                    req.setClubNom(rs.getString("nom"));
                    req.setResponsableId(rs.getInt("responsable_id"));
                    req.setStatut(rs.getString("statut"));
                    req.setDateDemande(rs.getTimestamp("date_demande"));

                    requests.add(req);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste demandes inscription en attente", e);
        }
        return requests;
    }

    public void decide(int requestId, int responsableId, boolean accept) {
        String selectSql = "SELECT err.utilisateur_id, err.evenement_id, e.titre AS evenement_titre " +
                "FROM event_registration_requests err " +
                "JOIN evenements e ON e.id = err.evenement_id " +
                "WHERE err.id = ? AND err.responsable_id = ? AND err.statut = 'EN_ATTENTE'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
            psSelect.setInt(1, requestId);
            psSelect.setInt(2, responsableId);

            Integer utilisateurId = null;
            Integer evenementId = null;
            String evenementTitre = null;

            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next()) {
                    utilisateurId = rs.getInt("utilisateur_id");
                    evenementId = rs.getInt("evenement_id");
                    evenementTitre = rs.getString("evenement_titre");
                } else {
                    throw new RuntimeException("Demande introuvable ou deja traitee.");
                }
            }

            String newStatut = accept ? "ACCEPTEE" : "REFUSEE";
            String updateSql = "UPDATE event_registration_requests SET statut = ? WHERE id = ?";
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, newStatut);
                psUpdate.setInt(2, requestId);
                psUpdate.executeUpdate();
            }

            if (accept) {
                inscriptionDAO.register(evenementId, utilisateurId);
            }

            String message;
            if (accept) {
                message = "Votre demande d'inscription pour l'événement " + evenementTitre + " a été acceptée.";
            } else {
                message = "Votre demande d'inscription pour l'événement " + evenementTitre + " a été refusée.";
            }
            notificationDAO.create(utilisateurId, message);
        } catch (Exception e) {
            throw new RuntimeException("Erreur decision demande inscription evenement", e);
        }
    }
}

