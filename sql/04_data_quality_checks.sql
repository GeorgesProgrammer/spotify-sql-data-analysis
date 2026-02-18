-- ===============================================
-- Data Quality Checks pour la table spotify
-- ===============================================

USE spotify_db;
GO

-- Vérifier la structure de la table
EXEC sp_columns spotify;
GO

-- Voir le type et la taille de chaque colonne
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'spotify';
GO

-- Compter le nombre total de lignes
SELECT COUNT(*) AS total_rows FROM spotify;
GO

-- Vérifier les valeurs manquantes pour les colonnes numériques
SELECT 
    COUNT(*) - COUNT(danceability) AS danceability_nulls,
    COUNT(*) - COUNT(energy) AS energy_nulls,
    COUNT(*) - COUNT(loudness) AS loudness_nulls,
    COUNT(*) - COUNT(speechiness) AS speechiness_nulls,
    COUNT(*) - COUNT(acousticness) AS acousticness_nulls,
    COUNT(*) - COUNT(liveness) AS liveness_nulls,
    COUNT(*) - COUNT(valence) AS valence_nulls,
    COUNT(*) - COUNT(tempo) AS tempo_nulls,
    COUNT(*) - COUNT(duration_min) AS duration_min_nulls,
    COUNT(*) - COUNT(views) AS views_nulls,
    COUNT(*) - COUNT(likes) AS likes_nulls,
    COUNT(*) - COUNT(comments) AS comments_nulls,
    COUNT(*) - COUNT(licensed) AS licensed_nulls,
    COUNT(*) - COUNT(official_video) AS officialvideo_nulls
FROM dbo.spotify;
GO

-- Vérifier les valeurs manquantes pour les colonnes non numériques
SELECT 
    COUNT(*) - COUNT(artist) AS artist_nulls,
    COUNT(*) - COUNT(track) AS track_nulls,
    COUNT(*) - COUNT(album) AS album_nulls,
    COUNT(*) - COUNT(album_type) AS album_type_nulls,
    COUNT(*) - COUNT(title) AS title_nulls,
    COUNT(*) - COUNT(channel) AS channel_nulls,
    COUNT(*) - COUNT(most_played_on) AS mostplayon_nulls
FROM dbo.spotify;
GO

-- Vérifier les doublons
SELECT 
    artist, track, album, album_type, title,
    COUNT(*) AS count_dup
FROM spotify
GROUP BY artist, track, album, album_type, title
HAVING COUNT(*) > 1;
GO

-- Distribution par type d'album
SELECT album_type, COUNT(*) AS count
FROM spotify
GROUP BY album_type;
GO

-- Distribution des booléens
SELECT licensed, COUNT(*) AS count
FROM spotify
GROUP BY licensed;
GO

SELECT official_video, COUNT(*) AS count
FROM spotify
GROUP BY official_video;
GO

-- Vérifier les contraintes de domaine
-- Energie doit être entre 0 et 1
SELECT * FROM spotify WHERE energy < 0 OR energy > 1;
GO

-- Danceability doit être entre 0 et 1
SELECT * FROM spotify WHERE danceability < 0 OR danceability > 1;
GO

-- Loudness en dB (souvent négatif)
SELECT MIN(loudness) AS min_loudness, MAX(loudness) AS max_loudness FROM spotify;
GO
