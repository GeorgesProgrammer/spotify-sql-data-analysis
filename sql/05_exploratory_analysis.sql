-- ===============================================
-- Analyse exploratoire des données Spotify
-- ===============================================

USE spotify_db;
GO

-- 1. Statistiques descriptives des mesures audio
SELECT 
    'danceability' AS metric,
    AVG(danceability) AS avg_value,
    MIN(danceability) AS min_value,
    MAX(danceability) AS max_value,
    STDEV(danceability) AS std_dev
FROM spotify
UNION ALL
SELECT 
    'energy',
    AVG(energy),
    MIN(energy),
    MAX(energy),
    STDEV(energy)
FROM spotify
UNION ALL
SELECT 
    'loudness',
    AVG(loudness),
    MIN(loudness),
    MAX(loudness),
    STDEV(loudness)
FROM spotify
UNION ALL
SELECT 
    'valence',
    AVG(valence),
    MIN(valence),
    MAX(valence),
    STDEV(valence)
FROM spotify;
GO

-- 2. Distribution des streams
SELECT 
    CASE 
        WHEN stream < 1000000 THEN '< 1M'
        WHEN stream BETWEEN 1000000 AND 10000000 THEN '1M-10M'
        WHEN stream BETWEEN 10000001 AND 100000000 THEN '10M-100M'
        WHEN stream BETWEEN 100000001 AND 1000000000 THEN '100M-1B'
        ELSE '> 1B'
    END AS stream_range,
    COUNT(*) AS track_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS percentage
FROM spotify
WHERE stream IS NOT NULL
GROUP BY 
    CASE 
        WHEN stream < 1000000 THEN '< 1M'
        WHEN stream BETWEEN 1000000 AND 10000000 THEN '1M-10M'
        WHEN stream BETWEEN 10000001 AND 100000000 THEN '10M-100M'
        WHEN stream BETWEEN 100000001 AND 1000000000 THEN '100M-1B'
        ELSE '> 1B'
    END
ORDER BY MIN(stream);
GO

-- 3. Top 10 artistes par nombre de tracks
SELECT TOP 10
    artist,
    COUNT(track) AS track_count,
    AVG(stream) AS avg_streams,
    SUM(views) AS total_views
FROM spotify
GROUP BY artist
ORDER BY track_count DESC;
GO

-- 4. Corrélation entre likes et views
SELECT 
    AVG(CASE WHEN views > 0 THEN CAST(likes AS FLOAT)/views ELSE 0 END) AS avg_likes_per_view,
    AVG(CASE WHEN views > 0 THEN CAST(comments AS FLOAT)/views ELSE 0 END) AS avg_comments_per_view
FROM spotify
WHERE views > 0;
GO

-- 5. Analyse temporelle (par durée)
SELECT 
    CASE 
        WHEN duration_min < 2 THEN 'Très court (<2min)'
        WHEN duration_min BETWEEN 2 AND 3 THEN 'Court (2-3min)'
        WHEN duration_min BETWEEN 3 AND 4 THEN 'Moyen (3-4min)'
        WHEN duration_min BETWEEN 4 AND 5 THEN 'Long (4-5min)'
        ELSE 'Très long (>5min)'
    END AS duration_category,
    COUNT(*) AS track_count,
    AVG(stream) AS avg_streams,
    AVG(energy) AS avg_energy,
    AVG(danceability) AS avg_danceability
FROM spotify
WHERE duration_min IS NOT NULL
GROUP BY 
    CASE 
        WHEN duration_min < 2 THEN 'Très court (<2min)'
        WHEN duration_min BETWEEN 2 AND 3 THEN 'Court (2-3min)'
        WHEN duration_min BETWEEN 3 AND 4 THEN 'Moyen (3-4min)'
        WHEN duration_min BETWEEN 4 AND 5 THEN 'Long (4-5min)'
        ELSE 'Très long (>5min)'
    END
ORDER BY MIN(duration_min);
GO
