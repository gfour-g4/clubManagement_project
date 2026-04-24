package model;

import java.sql.Timestamp;

public class Adhesion {
    private int id;
    private int utilisateurId;
    private int clubId;
    private String statut;
    private Timestamp dateAdhesion;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUtilisateurId() {
        return utilisateurId;
    }

    public void setUtilisateurId(int utilisateurId) {
        this.utilisateurId = utilisateurId;
    }

    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Timestamp getDateAdhesion() {
        return dateAdhesion;
    }

    public void setDateAdhesion(Timestamp dateAdhesion) {
        this.dateAdhesion = dateAdhesion;
    }
}
