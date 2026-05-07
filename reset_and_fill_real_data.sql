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

-- Insert realistic users
INSERT INTO utilisateurs (nom_complet, email, mot_de_passe, role) VALUES
('Sarah Benali', 'admin@universite.edu', 'adminpass', 'ADMIN'),
('Youssef El Amrani', 'youssef.elamrani@universite.edu', 'youssef123', 'RESPONSABLE'),
('Amina Chraibi', 'amina.chraibi@universite.edu', 'amina123', 'RESPONSABLE'),
('Karim Saidi', 'karim.saidi@universite.edu', 'karim123', 'RESPONSABLE'),
('Leila Benjelloun', 'leila.benjelloun@universite.edu', 'leila123', 'ETUDIANT'),
('Omar El Fassi', 'omar.elfassi@universite.edu', 'omar123', 'ETUDIANT'),
('Hanae Lahlou', 'hanae.lahlou@universite.edu', 'hanae123', 'ETUDIANT'),
('Anas Ouazzani', 'anas.ouazzani@universite.edu', 'anas123', 'ETUDIANT'),
('Sara Zaki', 'sara.zaki@universite.edu', 'sara123', 'ETUDIANT'),
('Mehdi Bouali', 'mehdi.bouali@universite.edu', 'mehdi123', 'ETUDIANT');

-- Insert realistic clubs
INSERT INTO clubs (nom, description, date_creation) VALUES
('Club de Développement Web', 'Un club pour apprendre et pratiquer le développement web (HTML, CSS, JavaScript, frameworks modernes).', '2025-09-15 10:00:00'),
('Club IA et Data Science', 'Exploration de l’intelligence artificielle, machine learning, et analyse de données.', '2025-10-01 14:00:00'),
('Club de Robotique', 'Conception et réalisation de projets robotiques, compétitions et ateliers pratiques.', '2025-09-20 09:00:00'),
('Club de Photographie', 'Ateliers de photo, sorties, et exposition des œuvres des membres.', '2025-10-10 11:00:00');

-- Assign responsables to clubs
INSERT INTO responsables_clubs (utilisateur_id, club_id) VALUES
(2, 1), -- Youssef El Amrani -> Club de Développement Web
(3, 2), -- Amina Chraibi -> Club IA et Data Science
(4, 3), -- Karim Saidi -> Club de Robotique
(2, 4); -- Youssef El Amrani -> Club de Photographie

-- Add many memberships
INSERT INTO adhesions (utilisateur_id, club_id, statut, date_adhesion) VALUES
(5, 1, 'ACTIF', '2025-09-16 08:30:00'), -- Leila -> Dev Web
(6, 1, 'ACTIF', '2025-09-17 09:15:00'), -- Omar -> Dev Web
(7, 1, 'ACTIF', '2025-09-18 10:00:00'), -- Hanae -> Dev Web
(5, 2, 'ACTIF', '2025-10-02 14:30:00'), -- Leila -> IA & DS
(8, 2, 'ACTIF', '2025-10-03 15:00:00'), -- Anas -> IA & DS
(9, 2, 'ACTIF', '2025-10-04 16:00:00'), -- Sara -> IA & DS
(6, 3, 'ACTIF', '2025-09-21 09:30:00'), -- Omar -> Robotique
(10, 3, 'ACTIF', '2025-09-22 10:00:00'), -- Mehdi -> Robotique
(7, 4, 'ACTIF', '2025-10-11 11:30:00'), -- Hanae -> Photo
(8, 4, 'ACTIF', '2025-10-12 12:00:00'), -- Anas -> Photo
(9, 4, 'ACTIF', '2025-10-13 13:00:00'); -- Sara -> Photo

-- Insert realistic events
INSERT INTO evenements (club_id, titre, description, date_evenement, lieu) VALUES
(1, 'Atelier: Introduction à React', 'Apprenez les bases de React, hooks, et composants réutilisables.', '2026-06-10 14:00:00', 'Amphithéâtre A'),
(1, 'Hackathon Web 24h', 'Compétition de développement web en équipe sur 24 heures.', '2026-07-15 09:00:00', 'Salle Informatique 201'),
(2, 'Conférence: Machine Learning pour débutants', 'Découvrez les concepts fondamentaux du ML avec des exemples concrets.', '2026-06-20 15:00:00', 'Amphithéâtre B'),
(2, 'Atelier: Analyse de données avec Python', 'Utilisez Pandas et Matplotlib pour analyser des jeux de données réels.', '2026-07-05 10:00:00', 'Salle Informatique 202'),
(3, 'Workshop: Construire un robot suiveur de ligne', 'Atelier pratique pour assembler et programmer un robot.', '2026-06-25 09:00:00', 'Laboratoire de Robotique'),
(3, 'Compétition Régionale de Robotique', 'Participez à la compétition inter-universitaire.', '2026-09-10 08:00:00', 'Centre des Congrès'),
(4, 'Sortie Photo: Jardin Botanique', 'Sortie pour pratiquer la photographie de paysage et de nature.', '2026-06-15 07:00:00', 'Jardin Botanique de la Ville'),
(4, 'Exposition annuelle des photos', 'Venez découvrir les œuvres des membres du club.', '2026-08-20 18:00:00', 'Galerie d’Art Universitaire');

-- Add realistic event registrations
INSERT INTO inscriptions_evenements (evenement_id, utilisateur_id, statut, date_inscription) VALUES
(1, 5, 'INSCRIT', '2026-05-20 10:00:00'), -- Leila -> React atelier
(1, 6, 'INSCRIT', '2026-05-21 11:00:00'), -- Omar -> React atelier
(1, 7, 'INSCRIT', '2026-05-22 09:30:00'), -- Hanae -> React atelier
(2, 5, 'INSCRIT', '2026-06-01 14:00:00'), -- Leila -> Hackathon
(3, 5, 'INSCRIT', '2026-05-25 15:30:00'), -- Leila -> ML conf
(3, 8, 'INSCRIT', '2026-05-26 16:00:00'), -- Anas -> ML conf
(3, 9, 'INSCRIT', '2026-05-27 14:45:00'), -- Sara -> ML conf
(4, 8, 'INSCRIT', '2026-06-10 10:30:00'), -- Anas -> Python atelier
(4, 9, 'INSCRIT', '2026-06-11 11:00:00'), -- Sara -> Python atelier
(5, 6, 'INSCRIT', '2026-05-28 09:15:00'), -- Omar -> Robot workshop
(5, 10, 'INSCRIT', '2026-05-29 10:00:00'), -- Mehdi -> Robot workshop
(7, 7, 'INSCRIT', '2026-06-01 07:30:00'), -- Hanae -> Photo sortie
(7, 8, 'INSCRIT', '2026-06-02 08:00:00'), -- Anas -> Photo sortie
(7, 9, 'INSCRIT', '2026-06-03 07:45:00'); -- Sara -> Photo sortie
