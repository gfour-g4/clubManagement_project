package dao;

import model.Evenement;
import model.InscriptionEvenement;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InscriptionEvenementDAO {

    public void register(int evenementId, int utilisateurId) {
        String selectSql = "SELECT id FROM inscriptions_evenements WHERE evenement_id = ? AND utilisateur_id = ?";
        String insertSql = "INSERT INTO inscriptions_evenements (evenement_id, utilisateur_id, statut) VALUES (?, ?, 'INSCRIT')";
        String updateSql = "UPDATE inscriptions_evenements SET statut = 'INSCRIT', date_inscription = CURRENT_TIMESTAMP WHERE evenement_id = ? AND utilisateur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
            psSelect.setInt(1, evenementId);
            psSelect.setInt(2, utilisateurId);
            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next()) {
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setInt(1, evenementId);
                        psUpdate.setInt(2, utilisateurId);
                        psUpdate.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setInt(1, evenementId);
                        psInsert.setInt(2, utilisateurId);
                        psInsert.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur inscription evenement", e);
        }
    }

    public void cancel(int evenementId, int utilisateurId) {
        String sql = "UPDATE inscriptions_evenements SET statut = 'ANNULE' WHERE evenement_id = ? AND utilisateur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evenementId);
            ps.setInt(2, utilisateurId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur annulation inscription", e);
        }
    }

    public List<InscriptionEvenement> findByEvenement(int evenementId) {
        List<InscriptionEvenement> inscriptions = new ArrayList<>();
        String sql = "SELECT * FROM inscriptions_evenements WHERE evenement_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evenementId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InscriptionEvenement i = new InscriptionEvenement();
                    i.setId(rs.getInt("id"));
                    i.setEvenementId(rs.getInt("evenement_id"));
                    i.setUtilisateurId(rs.getInt("utilisateur_id"));
                    i.setStatut(rs.getString("statut"));
                    i.setDateInscription(rs.getTimestamp("date_inscription"));
                    inscriptions.add(i);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste inscriptions evenement", e);
        }
        return inscriptions;
    }

    public List<Evenement> findRegisteredEventsByUser(int utilisateurId) {
        List<Evenement> events = new ArrayList<>();
        String sql = "SELECT e.* FROM evenements e " +
                "JOIN inscriptions_evenements ie ON ie.evenement_id = e.id " +
                "WHERE ie.utilisateur_id = ? AND ie.statut = 'INSCRIT' " +
                "ORDER BY e.date_evenement ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Evenement e = new Evenement();
                    e.setId(rs.getInt("id"));
                    e.setClubId(rs.getInt("club_id"));
                    e.setTitre(rs.getString("titre"));
                    e.setDescription(rs.getString("description"));
                    e.setDateEvenement(rs.getTimestamp("date_evenement"));
                    e.setLieu(rs.getString("lieu"));
                    e.setDateCreation(rs.getTimestamp("date_creation"));
                    events.add(e);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste evenements inscrits utilisateur", e);
        }
        return events;
    }

    public boolean isRegistered(int evenementId, int utilisateurId) {
        String sql = "SELECT 1 FROM inscriptions_evenements WHERE evenement_id = ? AND utilisateur_id = ? AND statut = 'INSCRIT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evenementId);
            ps.setInt(2, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur verification inscription evenement", e);
        }
    }

    public List<model.Utilisateur> findRegisteredUsersByEvenement(int evenementId) {
        List<model.Utilisateur> users = new ArrayList<>();
        String sql = "SELECT u.* FROM utilisateurs u " +
                "JOIN inscriptions_evenements ie ON ie.utilisateur_id = u.id " +
                "WHERE ie.evenement_id = ? AND ie.statut = 'INSCRIT' " +
                "ORDER BY u.nom_complet";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evenementId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Utilisateur u = new model.Utilisateur();
                    u.setId(rs.getInt("id"));
                    u.setNomComplet(rs.getString("nom_complet"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    u.setDateCreation(rs.getTimestamp("date_creation"));
                    users.add(u);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste utilisateurs inscrits evenement", e);
        }
        return users;
    }
}
