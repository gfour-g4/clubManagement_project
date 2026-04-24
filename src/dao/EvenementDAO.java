package dao;

import model.Evenement;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EvenementDAO {

    public void create(Evenement evenement) {
        String sql = "INSERT INTO evenements (club_id, titre, description, date_evenement, lieu) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evenement.getClubId());
            ps.setString(2, evenement.getTitre());
            ps.setString(3, evenement.getDescription());
            ps.setTimestamp(4, evenement.getDateEvenement());
            ps.setString(5, evenement.getLieu());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur creation evenement", e);
        }
    }

    public List<Evenement> findAll() {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT * FROM evenements ORDER BY date_evenement ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                evenements.add(map(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste evenements", e);
        }
        return evenements;
    }

    public Evenement findById(int id) {
        String sql = "SELECT * FROM evenements WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur evenement par id", e);
        }
        return null;
    }

    public List<Evenement> findByClub(int clubId) {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT * FROM evenements WHERE club_id = ? ORDER BY date_evenement ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    evenements.add(map(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste evenements par club", e);
        }
        return evenements;
    }

    public List<Evenement> findUpcoming() {
        List<Evenement> evenements = new ArrayList<>();
        String sql = "SELECT * FROM evenements WHERE date_evenement >= NOW() ORDER BY date_evenement ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                evenements.add(map(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste evenements a venir", e);
        }
        return evenements;
    }

    private Evenement map(ResultSet rs) throws Exception {
        Evenement e = new Evenement();
        e.setId(rs.getInt("id"));
        e.setClubId(rs.getInt("club_id"));
        e.setTitre(rs.getString("titre"));
        e.setDescription(rs.getString("description"));
        e.setDateEvenement(rs.getTimestamp("date_evenement"));
        e.setLieu(rs.getString("lieu"));
        e.setDateCreation(rs.getTimestamp("date_creation"));
        return e;
    }
}
