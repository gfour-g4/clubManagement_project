package dao;

import model.Notification;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public void create(int utilisateurId, String message) {
        String sql = "INSERT INTO notifications (utilisateur_id, message, est_lu, date_creation) VALUES (?, ?, 0, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            ps.setString(2, message);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur creation notification", e);
        }
    }

    public List<Notification> findByUtilisateur(int utilisateurId) {
        String sql = "SELECT * FROM notifications WHERE utilisateur_id = ? ORDER BY date_creation DESC LIMIT 20";
        List<Notification> notifications = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUtilisateurId(rs.getInt("utilisateur_id"));
                    n.setMessage(rs.getString("message"));
                    n.setEstLu(rs.getBoolean("est_lu"));
                    Timestamp ts = rs.getTimestamp("date_creation");
                    n.setDateCreation(ts);
                    notifications.add(n);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste notifications", e);
        }
        return notifications;
    }

    public int countUnread(int utilisateurId) {
        String sql = "SELECT COUNT(*) AS total FROM notifications WHERE utilisateur_id = ? AND est_lu = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur count notifications non lues", e);
        }
        return 0;
    }
}

