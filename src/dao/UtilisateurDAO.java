package dao;

import model.Utilisateur;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {

    public Utilisateur login(String email, String motDePasse) {
        String sql = "SELECT * FROM utilisateurs WHERE email = ? AND mot_de_passe = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, motDePasse);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur login utilisateur", e);
        }
        return null;
    }

    public List<Utilisateur> findAll() {
        List<Utilisateur> utilisateurs = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                utilisateurs.add(map(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste utilisateurs", e);
        }
        return utilisateurs;
    }

    public List<Utilisateur> findByRole(String role) {
        List<Utilisateur> utilisateurs = new ArrayList<>();
        String sql = "SELECT * FROM utilisateurs WHERE role = ? ORDER BY nom_complet";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    utilisateurs.add(map(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste utilisateurs par role", e);
        }
        return utilisateurs;
    }

    public void create(Utilisateur utilisateur) {
        String sql = "INSERT INTO utilisateurs (nom_complet, email, mot_de_passe, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, utilisateur.getNomComplet());
            ps.setString(2, utilisateur.getEmail());
            ps.setString(3, utilisateur.getMotDePasse());
            ps.setString(4, utilisateur.getRole());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur creation utilisateur", e);
        }
    }

    public void deleteById(int id) {
        String sql = "DELETE FROM utilisateurs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur suppression utilisateur", e);
        }
    }

    private Utilisateur map(ResultSet rs) throws Exception {
        Utilisateur u = new Utilisateur();
        u.setId(rs.getInt("id"));
        u.setNomComplet(rs.getString("nom_complet"));
        u.setEmail(rs.getString("email"));
        u.setMotDePasse(rs.getString("mot_de_passe"));
        u.setRole(rs.getString("role"));
        u.setDateCreation(rs.getTimestamp("date_creation"));
        return u;
    }
}
