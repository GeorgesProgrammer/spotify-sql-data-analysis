-- ===============================================
-- Création de la table staging pour l'import des données brutes
-- ===============================================

USE spotify_db;
GO

-- Supprimer la table staging si elle existe
DROP TABLE IF EXISTS dbo.staging_spotify;
GO

-- Créer la table staging qui accepte toutes les données brutes avec NULLs
CREATE TABLE dbo.staging_spotify (
    artist NVARCHAR(255),
    track NVARCHAR(255),
    album NVARCHAR(255),
    album_type NVARCHAR(50),

    danceability FLOAT NULL,
    energy FLOAT NULL,
    loudness FLOAT NULL,
    speechiness FLOAT NULL,
    acousticness FLOAT NULL,
    instrumentalness FLOAT NULL,
    liveness FLOAT NULL,
    valence FLOAT NULL,
    tempo FLOAT NULL,
    duration_min FLOAT NULL,

    title NVARCHAR(255),
    channel NVARCHAR(255),

    views FLOAT NULL,
    likes FLOAT NULL,
    comments FLOAT NULL,

    licensed NVARCHAR(10),
    official_video NVARCHAR(10),

    stream FLOAT NULL,
    energy_liveness FLOAT NULL,
    most_played_on NVARCHAR(50)
);
GO

-- Vérifier si la table source existe
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'cleaned_dataset';
GO

-- Vider la table staging si elle contient déjà des données
TRUNCATE TABLE dbo.staging_spotify;
GO

-- Remplir la table staging depuis le dataset original
INSERT INTO dbo.staging_spotify
SELECT *
FROM dbo.cleaned_dataset;
GO
