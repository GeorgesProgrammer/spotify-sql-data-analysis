-- ===============================================
-- Création de la table finale spotify avec types optimisés
-- ===============================================

USE spotify_db;
GO

-- Supprimer la table finale si elle existe
DROP TABLE IF EXISTS dbo.spotify;
GO

-- Créer la table finale avec les types corrects
CREATE TABLE dbo.spotify (
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

    views BIGINT NULL,
    likes BIGINT NULL,
    comments BIGINT NULL,

    licensed BIT NULL,
    official_video BIT NULL,

    stream BIGINT NULL,
    energy_liveness FLOAT NULL,
    most_played_on NVARCHAR(50)
);
GO

-- Transférer les données de staging vers la table finale
INSERT INTO dbo.spotify
SELECT
    artist,
    track,
    album,
    album_type,
    danceability,
    energy,
    loudness,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo,
    duration_min,
    title,
    channel,
    CAST(views AS BIGINT),
    CAST(likes AS BIGINT),
    CAST(comments AS BIGINT),
    CASE WHEN LOWER(licensed) = 'true' THEN 1 ELSE 0 END,
    CASE WHEN LOWER(official_video) = 'true' THEN 1 ELSE 0 END,
    CAST(stream AS BIGINT),
    energy_liveness,
    most_played_on
FROM dbo.staging_spotify;
GO

-- Nettoyer la table staging
TRUNCATE TABLE dbo.staging_spotify;
GO

-- Vérifications finales
SELECT COUNT(*) AS total_rows FROM dbo.spotify;
GO

SELECT licensed, official_video, COUNT(*) AS nb
FROM dbo.spotify
GROUP BY licensed, official_video;
GO
