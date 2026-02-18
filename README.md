📘 DOCUMENTATION COMPLÈTE – PROJET SQL SPOTIFY
🧩 1. OBJECTIF GLOBAL DU PROJET

Ce projet vise à :

Importer un dataset brut (cleaned_dataset)

Le sécuriser via une table de staging

Nettoyer et typer correctement les données

Vérifier la qualité des données (NULLs, doublons, cohérence)

Réaliser des analyses SQL progressives (des plus simples aux plus avancées)

🔁 PARTIE 1 — PIPELINE D’IMPORT (ETL)
🔹 1️⃣ Création de la base de données
CREATE DATABASE spotify_db;


Objectif :
Créer un espace dédié au projet pour isoler les données Spotify.

Bonne pratique :
Toujours séparer les projets dans des bases différentes.

🔹 2️⃣ Sélection de la base
USE spotify_db;


Objectif :
Indiquer à SQL Server que toutes les opérations suivantes concernent spotify_db.

🔹 3️⃣ Création de la table de staging (staging_spotify)
CREATE TABLE dbo.staging_spotify (...)


Objectif :

Accueillir les données brutes

Autoriser les NULL

Éviter les erreurs d’import

Pourquoi staging ?

Les données réelles sont rarement propres dès l’import.

📌 Règle pro :

Jamais de transformation directe depuis le dataset source vers la table finale.

🔹 4️⃣ Vérification des valeurs non NULL dans la source
SELECT COUNT(*), COUNT(energy), COUNT(loudness), COUNT(valence)
FROM dbo.cleaned_dataset;


Objectif :

Mesurer la qualité du dataset

Vérifier si certaines colonnes sont partiellement remplies

👉 COUNT(colonne) ignore les NULL

🔹 5️⃣ Vérification de l’existence de la table source
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'cleaned_dataset';


Objectif :
S’assurer que la table source existe avant toute manipulation.

🔹 6️⃣ Nettoyage de la table staging
TRUNCATE TABLE dbo.staging_spotify;


Objectif :

Éviter les doublons

Garantir un import propre

📌 TRUNCATE est plus rapide que DELETE.

🔹 7️⃣ Chargement des données dans staging
INSERT INTO dbo.staging_spotify
SELECT *
FROM dbo.cleaned_dataset;


Objectif :
Copier les données sans transformation.

🔹 8️⃣ Création de la table finale (spotify)
CREATE TABLE dbo.spotify (...)


Objectif :

Appliquer les bons types de données

Convertir les booléens en BIT

Préparer la table pour l’analyse

📌 Exemple :

views, likes, stream → BIGINT

licensed, official_video → BIT

🔹 9️⃣ Transformation et insertion finale
INSERT INTO dbo.spotify
SELECT ..., CAST(), CASE WHEN ...
FROM dbo.staging_spotify;


Objectif :

Transformer les types

Nettoyer les booléens (true/false → 1/0)

Charger les données propres

📌 C’est le cœur de l’ETL.

🔹 🔟 Vérification du volume de données
SELECT COUNT(*) FROM dbo.spotify;


Objectif :
Valider que toutes les lignes ont été transférées.

🔹 1️⃣1️⃣ Vérification des colonnes booléennes
SELECT licensed, official_video, COUNT(*)
FROM dbo.spotify
GROUP BY licensed, official_video;


Objectif :
S’assurer que les valeurs sont bien 0 / 1 / NULL.

🔹 1️⃣2️⃣ Vérification des valeurs NULL
SELECT COUNT(*), COUNT(danceability), COUNT(energy), ...
FROM dbo.spotify;


Objectif :
Comparer total des lignes vs valeurs non NULL.

🔹 1️⃣3️⃣ Nettoyage final de la staging
TRUNCATE TABLE dbo.staging_spotify;


Objectif :
Préparer la table pour un futur import.

🔍 PARTIE 2 — DATA QUALITY & EXPLORATION
🔹 Structure de la table
EXEC sp_columns spotify;


Objectif :
Afficher les colonnes, types et tailles.

🔹 Métadonnées détaillées
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS;


Objectif :
Audit structurel de la table.

🔹 Détection des valeurs manquantes (numériques)
COUNT(*) - COUNT(colonne)


Objectif :
Identifier les colonnes problématiques.

🔹 Valeurs manquantes (catégorielles)

Même logique pour NVARCHAR.

🔹 Détection des doublons
GROUP BY artist, track, album, ...
HAVING COUNT(*) > 1


Objectif :
Identifier les lignes dupliquées.

🔹 Contrôle des valeurs incohérentes
energy < 0 OR energy > 1


Objectif :
Vérifier la cohérence métier.

📊 PARTIE 3 — ANALYSE DES DONNÉES
Q1️⃣ Tracks > 1 milliard de streams

Filtrage simple avec WHERE.

Q2️⃣ Albums et artistes

DISTINCT pour éviter les doublons.

Q3️⃣ Total des commentaires (licensed)

Agrégation conditionnelle.

Q4️⃣ Tracks de type single

Filtrage par catégorie.

Q5️⃣ Nombre de tracks par artiste

GROUP BY + COUNT.

Q6️⃣ Moyenne de danceability par album

AVG().

Q7️⃣ Top 5 tracks les plus énergiques

Classement avec TOP.

Q8️⃣ Vues et likes pour vidéos officielles

Filtrage + agrégation.

Q9️⃣ Vues totales par album et track

Analyse hiérarchique.

Q🔟 Spotify vs YouTube
SUM(CASE WHEN ...)


Objectif :
Comparer deux plateformes dans une même requête.

Q1️⃣1️⃣ Top 3 tracks par artiste

Utilisation de DENSE_RANK().

Q1️⃣2️⃣ Liveness > moyenne globale

Sous-requête avec AVG().

Q1️⃣3️⃣ Ratio energy / liveness

Prévention des divisions par zéro.

Q1️⃣4️⃣ Écart d’énergie par album

CTE pour lisibilité.

🏁 CONCLUSION PROFESSIONNELLE

✔ Pipeline ETL clair
✔ Staging sécurisé
✔ Qualité des données vérifiée
✔ SQL analytique avancé
✔ Projet 100% présentable en portfolio
