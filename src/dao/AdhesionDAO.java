package dao;

import model.Adhesion;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdhesionDAO {

    public void joinClub(int utilisateurId, int clubId) {
        String selectSql = "SELECT id FROM adhesions WHERE utilisateur_id = ? AND club_id = ?";
        String insertSql = "INSERT INTO adhesions (utilisateur_id, club_id, statut) VALUES (?, ?, 'ACTIF')";
        String updateSql = "UPDATE adhesions SET statut = 'ACTIF', date_adhesion = CURRENT_TIMESTAMP WHERE utilisateur_id = ? AND club_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
            psSelect.setInt(1, utilisateurId);
            psSelect.setInt(2, clubId);
            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next()) {
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setInt(1, utilisateurId);
                        psUpdate.setInt(2, clubId);
                        psUpdate.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setInt(1, utilisateurId);
                        psInsert.setInt(2, clubId);
                        psInsert.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur adhesion club", e);
        }
    }

    public void leaveClub(int utilisateurId, int clubId) {
        String sql = "UPDATE adhesions SET statut = 'QUITTE' WHERE utilisateur_id = ? AND club_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            ps.setInt(2, clubId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur sortie club", e);
        }
    }

    public List<Adhesion> findByUtilisateur(int utilisateurId) {
        List<Adhesion> adhesions = new ArrayList<>();
        String sql = "SELECT * FROM adhesions WHERE utilisateur_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Adhesion a = new Adhesion();
                    a.setId(rs.getInt("id"));
                    a.setUtilisateurId(rs.getInt("utilisateur_id"));
                    a.setClubId(rs.getInt("club_id"));
                    a.setStatut(rs.getString("statut"));
                    a.setDateAdhesion(rs.getTimestamp("date_adhesion"));
                    adhesions.add(a);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste adhesions utilisateur", e);
        }
        return adhesions;
    }

    public boolean isActiveMember(int utilisateurId, int clubId) {
        String sql = "SELECT 1 FROM adhesions WHERE utilisateur_id = ? AND club_id = ? AND statut = 'ACTIF'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            ps.setInt(2, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur verification adhesion active", e);
        }
    }
}
