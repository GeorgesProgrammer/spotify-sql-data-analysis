-- ===============================================
-- 01_create_database.sql
-- Objectif : Créer et sélectionner la base de données du projet
-- ===============================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'spotify_db')
BEGIN
    CREATE DATABASE spotify_db;
END
GO

USE spotify_db;
GO

