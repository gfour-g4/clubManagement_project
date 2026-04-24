package dao;

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
}
