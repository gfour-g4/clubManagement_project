package dao;

import model.Club;
import model.Utilisateur;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ClubDAO {

    public void create(Club club) {
        String sql = "INSERT INTO clubs (nom, description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, club.getNom());
            ps.setString(2, club.getDescription());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur creation club", e);
        }
    }

    public List<Club> findAll() {
        List<Club> clubs = new ArrayList<>();
        String sql = "SELECT * FROM clubs ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Club c = new Club();
                c.setId(rs.getInt("id"));
                c.setNom(rs.getString("nom"));
                c.setDescription(rs.getString("description"));
                c.setDateCreation(rs.getTimestamp("date_creation"));
                clubs.add(c);
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste clubs", e);
        }
        return clubs;
    }

    public Club findById(int clubId) {
        String sql = "SELECT * FROM clubs WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Club c = new Club();
                    c.setId(rs.getInt("id"));
                    c.setNom(rs.getString("nom"));
                    c.setDescription(rs.getString("description"));
                    c.setDateCreation(rs.getTimestamp("date_creation"));
                    return c;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur recherche club par id", e);
        }
        return null;
    }

    public List<Club> findByResponsableUserId(int utilisateurId) {
        List<Club> clubs = new ArrayList<>();
        String sql = "SELECT c.* FROM clubs c " +
                "JOIN responsables_clubs rc ON rc.club_id = c.id " +
                "WHERE rc.utilisateur_id = ? ORDER BY c.nom";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Club c = new Club();
                    c.setId(rs.getInt("id"));
                    c.setNom(rs.getString("nom"));
                    c.setDescription(rs.getString("description"));
                    c.setDateCreation(rs.getTimestamp("date_creation"));
                    clubs.add(c);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste clubs responsable", e);
        }
        return clubs;
    }

    public boolean isResponsableOfClub(int utilisateurId, int clubId) {
        String sql = "SELECT 1 FROM responsables_clubs WHERE utilisateur_id = ? AND club_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            ps.setInt(2, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur verification responsable club", e);
        }
    }

    public void assignResponsable(int utilisateurId, int clubId) {
        String deleteSql = "DELETE FROM responsables_clubs WHERE club_id = ?";
        String insertSql = "INSERT INTO responsables_clubs (utilisateur_id, club_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psDelete = conn.prepareStatement(deleteSql);
             PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
            psDelete.setInt(1, clubId);
            psDelete.executeUpdate();
            psInsert.setInt(1, utilisateurId);
            psInsert.setInt(2, clubId);
            psInsert.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Erreur assignation responsable", e);
        }
    }

    public List<Utilisateur> findMembersByClub(int clubId) {
        List<Utilisateur> membres = new ArrayList<>();
        String sql = "SELECT u.* FROM utilisateurs u " +
                "JOIN adhesions a ON a.utilisateur_id = u.id " +
                "WHERE a.club_id = ? AND a.statut = 'ACTIF' ORDER BY u.nom_complet";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Utilisateur u = new Utilisateur();
                    u.setId(rs.getInt("id"));
                    u.setNomComplet(rs.getString("nom_complet"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    membres.add(u);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste membres club", e);
        }
        return membres;
    }

    public Map<String, Integer> countMembersPerClub() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String sql = "SELECT c.nom, COUNT(a.id) AS total " +
                "FROM clubs c " +
                "LEFT JOIN adhesions a ON a.club_id = c.id AND a.statut = 'ACTIF' " +
                "GROUP BY c.id, c.nom ORDER BY c.nom";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("nom"), rs.getInt("total"));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur statistiques membres par club", e);
        }
        return stats;
    }

    public Map<Integer, String> findResponsableNamesByClub() {
        Map<Integer, String> responsablesByClub = new HashMap<>();
        String sql = "SELECT rc.club_id, u.nom_complet FROM responsables_clubs rc " +
                "JOIN utilisateurs u ON u.id = rc.utilisateur_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                responsablesByClub.put(rs.getInt("club_id"), rs.getString("nom_complet"));
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur mapping responsables par club", e);
        }
        return responsablesByClub;
    }

    public List<Club> findByMemberUserId(int utilisateurId) {
        List<Club> clubs = new ArrayList<>();
        String sql = "SELECT c.* FROM clubs c " +
                "JOIN adhesions a ON a.club_id = c.id " +
                "WHERE a.utilisateur_id = ? AND a.statut = 'ACTIF' ORDER BY c.nom";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, utilisateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Club c = new Club();
                    c.setId(rs.getInt("id"));
                    c.setNom(rs.getString("nom"));
                    c.setDescription(rs.getString("description"));
                    c.setDateCreation(rs.getTimestamp("date_creation"));
                    clubs.add(c);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Erreur liste clubs membre", e);
        }
        return clubs;
    }
}
