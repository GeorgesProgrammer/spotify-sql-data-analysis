-- ===============================================
-- Requêtes analytiques avancées - Projet Spotify
-- ===============================================

USE spotify_db;
GO

-- EASY CATEGORY
-- -------------

-- Q1: Tracks avec plus d'1 milliard de streams
SELECT 
    track,
    artist,
    stream
FROM spotify
WHERE stream > 1000000000
ORDER BY stream DESC;
GO

-- Q2: Liste des albums avec leurs artistes
SELECT DISTINCT
    album,
    artist
FROM spotify
ORDER BY album;
GO

-- Q3: Total des commentaires pour les tracks licenciées
SELECT 
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 1;
GO

-- Q4: Tracks de type 'single'
SELECT 
    track,
    artist,
    album
FROM spotify
WHERE album_type LIKE 'single';
GO

-- Q5: Nombre de tracks par artiste
SELECT 
    artist,
    COUNT(track) AS track_count
FROM spotify
GROUP BY artist
ORDER BY track_count DESC;
GO

-- Q6: Danceabilité moyenne par album
SELECT
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
GO

-- Q7: Top 5 tracks par énergie
SELECT TOP 5
    track,
    AVG(energy) AS avg_energy
FROM spotify
GROUP BY track
ORDER BY avg_energy DESC;
GO

-- Q8: Tracks avec vidéo officielle - vues et likes
SELECT 
    track,
    SUM(views) AS total_views, 
    SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 1
GROUP BY track
ORDER BY total_views DESC;
GO

-- Q9: Vues totales par album et track
SELECT
    album,
    track,
    SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY album, total_views DESC;
GO

-- Q10: Tracks plus streamées sur Spotify que YouTube
SELECT track
FROM spotify
GROUP BY track
HAVING 
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END)
    >
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END);
GO

-- MEDIUM/HARD CATEGORY
-- --------------------

-- Q11: Top 3 tracks les plus vues par artiste
WITH rankingartist AS
(
    SELECT 
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rang
    FROM spotify
    GROUP BY artist, track
)
SELECT *
FROM rankingartist
WHERE rang <= 3
ORDER BY artist, rang;
GO

-- Q12: Tracks avec liveness au-dessus de la moyenne
SELECT
    artist,
    track,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC;
GO

-- Q13: Ratio énergie/liveness > 1.2
SELECT 
    artist,
    track,
    energy,
    liveness,
    (energy / liveness) AS energy_liveness_ratio
FROM spotify
WHERE liveness IS NOT NULL
  AND liveness > 0
  AND (energy / liveness) > 1.2
ORDER BY energy_liveness_ratio DESC;
GO

-- Q14: Différence entre énergie max et min par album
WITH energy_stats AS
(
    SELECT 
        album, 
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY album
)
SELECT 
    album,
    highest_energy,
    lowest_energy,
    highest_energy - lowest_energy AS energy_diff
FROM energy_stats
ORDER BY energy_diff DESC;
GO

-- Q15: Analyse comparative Spotify vs YouTube
SELECT 
    most_played_on,
    COUNT(*) AS track_count,
    AVG(stream) AS avg_streams,
    AVG(views) AS avg_views,
    AVG(likes) AS avg_likes,
    AVG(energy) AS avg_energy,
    AVG(danceability) AS avg_danceability
FROM spotify
WHERE most_played_on IN ('Spotify', 'Youtube')
GROUP BY most_played_on;
GO

-- Q16: Corrélation entre caractéristiques audio et popularité
SELECT 
    CASE 
        WHEN stream < PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY stream) OVER() THEN 'Faible'
        WHEN stream < PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY stream) OVER() THEN 'Moyen'
        ELSE 'Élevé'
    END AS popularity_segment,
    AVG(energy) AS avg_energy,
    AVG(danceability) AS avg_danceability,
    AVG(valence) AS avg_valence,
    AVG(loudness) AS avg_loudness,
    AVG(tempo) AS avg_tempo
FROM spotify
WHERE stream IS NOT NULL
GROUP BY 
    CASE 
        WHEN stream < PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY stream) OVER() THEN 'Faible'
        WHEN stream < PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY stream) OVER() THEN 'Moyen'
        ELSE 'Élevé'
    END;
GO
