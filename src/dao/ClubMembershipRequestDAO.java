package dao;

import model.ClubMembershipRequest;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ClubMembershipRequestDAO {
    private final AdhesionDAO adhesionDAO = new AdhesionDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public String requestJoinClub(int utilisateurId, int clubId) {
        if (adhesionDAO.isActiveMember(utilisateurId, clubId)) {
            return "Vous+etes+deja+membre+actif.";
        }
        if (hasPendingRequest(utilisateurId, clubId)) {
            return "Demande+deja+en+attente.";
        }

        // Resolve responsable_id for that club
        Integer responsableId = null;
        String clubName = null;
        try (Connection conn = DBConnection.getConnection()) {
            String responsableSql = "SELECT utilisateur_id FROM responsables_clubs WHERE club_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(responsableSql)) {
                ps.setInt(1, clubId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        responsableId = rs.getInt(1);
                    }
                }
            }

            String clubSql = "SELECT nom FROM clubs WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(clubSql)) {
                ps.setInt(1, clubId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        clubName = rs.getString("nom");
                    }
                }
            }

            // Fallback: if no responsable assigned, auto-approve.
            if (responsableId == null) {
                adhesionDAO.joinClub(utilisateurId, clubId);
                notificationDAO.create(utilisateurId,
                        "Votre demande d'adhésion au club " + clubName + " a été acceptée.");
                return "Demande+automatiquement+acceptée.";
            }

            String insertSql = "INSERT INTO club_membership_requests (utilisateur_id, club_id, responsable_id, statut) VALUES (?, ?, ?, 'EN_ATTENTE')";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, utilisateurId);
                ps.setInt(2, clubId);
                ps.setInt(3, responsableId);
                ps.executeUpdate();
            }
            return "Demande+envoyee+au+responsable.";
        } catch (Exception e) {
            throw new RuntimeException("Erreur creation demande adhesion club", e);
        }
    }

    public boolean hasPendingRequest(int utilisateurId, int clubId) {
        String sql = "SELECT 1 FROM club_membership_requests WHERE utilisateur_id = ? AND club_id = ? AND statut = 'EN_ATTENTE' LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            ps.setInt(2, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur verification demande adhesion club", e);
        }
    }

    public Set<Integer> findPendingClubIdsByUtilisateur(int utilisateurId) {
        String sql = "SELECT club_id FROM club_membership_requests WHERE utilisateur_id = ? AND statut = 'EN_ATTENTE'";
        Set<Integer> clubIds = new HashSet<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    clubIds.add(rs.getInt("club_id"));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste demandes adhesion en attente", e);
        }
        return clubIds;
    }

    public List<ClubMembershipRequest> findPendingByResponsableAndClub(int responsableId, int clubId) {
        String sql = "SELECT cmr.id, cmr.utilisateur_id, u.nom_complet, u.email, cmr.club_id, c.nom, cmr.responsable_id, cmr.statut, cmr.date_demande " +
                "FROM club_membership_requests cmr " +
                "JOIN utilisateurs u ON u.id = cmr.utilisateur_id " +
                "JOIN clubs c ON c.id = cmr.club_id " +
                "WHERE cmr.responsable_id = ? AND cmr.club_id = ? AND cmr.statut = 'EN_ATTENTE' " +
                "ORDER BY cmr.date_demande ASC";
        List<ClubMembershipRequest> requests = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, responsableId);
            ps.setInt(2, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ClubMembershipRequest req = new ClubMembershipRequest();
                    req.setId(rs.getInt("id"));
                    req.setUtilisateurId(rs.getInt("utilisateur_id"));
                    req.setUtilisateurNomComplet(rs.getString("nom_complet"));
                    req.setUtilisateurEmail(rs.getString("email"));
                    req.setClubId(rs.getInt("club_id"));
                    req.setClubNom(rs.getString("nom"));
                    req.setResponsableId(rs.getInt("responsable_id"));
                    req.setStatut(rs.getString("statut"));
                    Timestamp ts = rs.getTimestamp("date_demande");
                    req.setDateDemande(ts);
                    requests.add(req);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste demandes adhesion en attente", e);
        }
        return requests;
    }

    public void decide(int requestId, int responsableId, boolean accept) {
        String selectSql = "SELECT cmr.utilisateur_id, cmr.club_id, c.nom AS club_nom " +
                "FROM club_membership_requests cmr " +
                "JOIN clubs c ON c.id = cmr.club_id " +
                "WHERE cmr.id = ? AND cmr.responsable_id = ? AND cmr.statut = 'EN_ATTENTE'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
            psSelect.setInt(1, requestId);
            psSelect.setInt(2, responsableId);

            Integer utilisateurId = null;
            Integer clubId = null;
            String clubNom = null;

            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next()) {
                    utilisateurId = rs.getInt("utilisateur_id");
                    clubId = rs.getInt("club_id");
                    clubNom = rs.getString("club_nom");
                } else {
                    throw new RuntimeException("Demande introuvable ou deja traitee.");
                }
            }

            String newStatut = accept ? "ACCEPTEE" : "REFUSEE";
            String updateSql = "UPDATE club_membership_requests SET statut = ? WHERE id = ?";
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, newStatut);
                psUpdate.setInt(2, requestId);
                psUpdate.executeUpdate();
            }

            if (accept) {
                adhesionDAO.joinClub(utilisateurId, clubId);
            }

            String message;
            if (accept) {
                message = "Votre demande d'adhésion au club " + clubNom + " a été acceptée.";
            } else {
                message = "Votre demande d'adhésion au club " + clubNom + " a été refusée.";
            }
            notificationDAO.create(utilisateurId, message);
        } catch (Exception e) {
            throw new RuntimeException("Erreur decision demande adhesion club", e);
        }
    }
}

