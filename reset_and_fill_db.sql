DROP DATABASE IF EXISTS CLUB;
CREATE DATABASE CLUB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE CLUB;

CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_complet VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'RESPONSABLE', 'MEMBRE', 'ETUDIANT') NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clubs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE responsables_clubs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    club_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_responsable (club_id)
);

CREATE TABLE adhesions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utilisateur_id INT NOT NULL,
    club_id INT NOT NULL,
    statut ENUM('ACTIF', 'INACTIF') DEFAULT 'ACTIF',
    date_adhesion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_adhesion (utilisateur_id, club_id)
);

CREATE TABLE evenements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    club_id INT NOT NULL,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    date_evenement TIMESTAMP NOT NULL,
    lieu VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE
);

CREATE TABLE inscriptions_evenements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evenement_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    statut ENUM('INSCRIT', 'ANNULE') DEFAULT 'INSCRIT',
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (evenement_id) REFERENCES evenements(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_inscription (evenement_id, utilisateur_id)
);

-- Insert example users
INSERT INTO utilisateurs (nom_complet, email, mot_de_passe, role) VALUES
('Admin Test', 'admin@club.local', 'admin123', 'ADMIN'),
('Noureddine Kesah', 'resp@club.local', 'resp123', 'RESPONSABLE'),
('laymoun', 'etud@club.local', 'etud123', 'ETUDIANT'),
('ons', 'ons@gmail.com', 'ons123', 'ETUDIANT'),
('noureddine mouch kesah', 'resp2@club.local', 'resp2123', 'RESPONSABLE'),
('eya', 'eya@gmail.com', 'eya123', 'RESPONSABLE'),
('test', 'test@gmail.com', 'test123', 'RESPONSABLE');

-- Insert example clubs
INSERT INTO clubs (nom, description) VALUES
('IEEE', 'this is a desc of IEEE'),
('laymouna', 'desc'),
('fan ons', 'hahah'),
('test', 'test');

-- Assign responsables to clubs
INSERT INTO responsables_clubs (utilisateur_id, club_id) VALUES
(2, 1), -- Noureddine Kesah -> IEEE
(5, 2), -- noureddine mouch kesah -> laymouna
(6, 3), -- eya -> fan ons
(7, 4); -- test -> test

-- Add some memberships
INSERT INTO adhesions (utilisateur_id, club_id, statut) VALUES
(3, 1, 'ACTIF'), -- laymoun -> IEEE
(4, 3, 'ACTIF'); -- ons -> fan ons

-- Insert example events
INSERT INTO evenements (club_id, titre, description, date_evenement, lieu) VALUES
(1, 'event 1', 'description of event 1', '1970-11-11 11:11:00', '111'),
(2, 'event 2', 'description of event 2', '2000-02-02 22:22:00', '222'),
(3, 'test', 'test event description', '2026-06-08 10:00:00', 'hi'),
(3, 'evenement kbir barcha', 'un grand événement', '2026-06-20 10:00:00', 'SFAX'),
(1, 'evenement heyel barcha', 'un autre grand événement', '2026-10-28 10:00:00', 'sfax');

-- Add some event registrations
INSERT INTO inscriptions_evenements (evenement_id, utilisateur_id, statut) VALUES
(1, 3, 'INSCRIT'), -- laymoun -> event 1
(3, 4, 'INSCRIT'); -- ons -> test event
