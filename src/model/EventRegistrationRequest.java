package model;

import java.sql.Timestamp;

public class EventRegistrationRequest {
    private int id;
    private int evenementId;
    private String evenementTitre;
    private Timestamp evenementDate;
    private String evenementLieu;

    private int utilisateurId;
    private String utilisateurNomComplet;
    private String utilisateurEmail;

    private int clubId;
    private String clubNom;

    private int responsableId;
    private String statut;
    private Timestamp dateDemande;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEvenementId() {
        return evenementId;
    }

    public void setEvenementId(int evenementId) {
        this.evenementId = evenementId;
    }

    public String getEvenementTitre() {
        return evenementTitre;
    }

    public void setEvenementTitre(String evenementTitre) {
        this.evenementTitre = evenementTitre;
    }

    public Timestamp getEvenementDate() {
        return evenementDate;
    }

    public void setEvenementDate(Timestamp evenementDate) {
        this.evenementDate = evenementDate;
    }

    public String getEvenementLieu() {
        return evenementLieu;
    }

    public void setEvenementLieu(String evenementLieu) {
        this.evenementLieu = evenementLieu;
    }

    public int getUtilisateurId() {
        return utilisateurId;
    }

    public void setUtilisateurId(int utilisateurId) {
        this.utilisateurId = utilisateurId;
    }

    public String getUtilisateurNomComplet() {
        return utilisateurNomComplet;
    }

    public void setUtilisateurNomComplet(String utilisateurNomComplet) {
        this.utilisateurNomComplet = utilisateurNomComplet;
    }

    public String getUtilisateurEmail() {
        return utilisateurEmail;
    }

    public void setUtilisateurEmail(String utilisateurEmail) {
        this.utilisateurEmail = utilisateurEmail;
    }

    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getClubNom() {
        return clubNom;
    }

    public void setClubNom(String clubNom) {
        this.clubNom = clubNom;
    }

    public int getResponsableId() {
        return responsableId;
    }

    public void setResponsableId(int responsableId) {
        this.responsableId = responsableId;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Timestamp getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(Timestamp dateDemande) {
        this.dateDemande = dateDemande;
    }
}

