Parfait 👍
Voici un **README.md complet, clair et professionnel**, exactement au niveau attendu pour un **portfolio Data Analyst / SQL**, rédigé en **français** et aligné avec tout le travail que tu as réalisé.

Tu peux le **copier-coller directement dans GitHub**.

---

# 🎵 Spotify – Analyse de données avec SQL Server

## 📌 Description du projet

Ce projet présente une **analyse de données Spotify de bout en bout** en utilisant **Microsoft SQL Server**.
L’objectif est de démontrer un **pipeline ETL complet**, depuis l’importation des données brutes jusqu’à l’exploration, le nettoyage, le contrôle qualité et l’analyse analytique via des requêtes SQL avancées.

Le projet met en avant des **bonnes pratiques professionnelles** utilisées en Data Analytics et Data Engineering.

---

## 🎯 Objectifs

* Importer un dataset Spotify dans SQL Server
* Gérer les erreurs d’importation via une **table de staging**
* Nettoyer et convertir les données (types, NULL, booléens)
* Vérifier la qualité des données (valeurs manquantes, doublons, cohérence)
* Réaliser des analyses exploratoires et analytiques
* Répondre à des questions métier à l’aide de requêtes SQL

---

## 🗂️ Architecture du projet

```
spotify-sql-data-analysis/
│
├── data/
│   └── cleaned_dataset.csv
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_staging_table.sql
│   ├── 03_final_table.sql
│   ├── 04_data_quality_checks.sql
│   ├── 05_exploratory_analysis.sql
│   └── 06_analytical_queries.sql
│
└── README.md
```

---

## 🔄 Pipeline de données (ETL)

### 1️⃣ Source des données

* Dataset Spotify nettoyé (`cleaned_dataset`)
* Contient des informations sur :

  * artistes, albums, titres
  * caractéristiques audio (energy, danceability, loudness…)
  * statistiques d’engagement (streams, views, likes, comments)
  * plateformes de diffusion (Spotify, YouTube)

---

### 2️⃣ Table de staging (`staging_spotify`)

Objectif :

* Accepter **toutes les données brutes**
* Autoriser les valeurs `NULL`
* Éviter les erreurs d’importation

Caractéristiques :

* Types souples (`FLOAT`, `NVARCHAR`)
* Booléens stockés en texte (`"true" / "false"`)

---

### 3️⃣ Table finale (`spotify`)

Objectif :

* Stocker des données propres et prêtes à l’analyse

Transformations appliquées :

* Conversion des métriques volumineuses en `BIGINT`
* Conversion des booléens en `BIT`
* Gestion sécurisée des valeurs manquantes (`NULL`)
* Validation des plages de valeurs (ex : energy ∈ [0,1])

---

## 🧪 Contrôle qualité des données

Les vérifications suivantes ont été effectuées :

* 🔍 Valeurs manquantes par colonne
* 🔁 Détection des doublons (artist, track, album)
* 📏 Validation des plages numériques
* ✅ Vérification des types de données
* 🔄 Cohérence des plateformes de diffusion

Exemple :

```sql
SELECT COUNT(*) - COUNT(energy) AS energy_nulls
FROM spotify;
```

---

## 📊 Exploration des données

Analyses exploratoires réalisées :

* Répartition des types d’albums (album / single)
* Distribution des valeurs audio (energy, danceability)
* Répartition des streams par plateforme
* Analyse des vidéos officielles
* Comparaison Spotify vs YouTube

---

## 📈 Analyses analytiques

Quelques questions métier traitées :

* 🎧 Titres dépassant 1 milliard de streams
* 👤 Nombre de titres par artiste
* 💃 Moyenne de la danceability par album
* ⚡ Top 5 des titres les plus énergiques
* 🎥 Titres avec vidéos officielles et leurs performances
* 🥇 Top 3 des titres les plus vus par artiste
* 📊 Comparaison des streams Spotify vs YouTube

Exemple :

```sql
SELECT track
FROM spotify
GROUP BY track
HAVING 
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END)
  >
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END);
```

---

## 🛠️ Technologies utilisées

* **Microsoft SQL Server**
* **T-SQL**
* SQL Server Management Studio (SSMS)
* CSV Dataset

---

## 📌 Compétences démontrées

* SQL avancé (CTE, Window Functions, CASE, HAVING)
* Data Cleaning & Data Quality
* ETL avec tables de staging
* Modélisation de données
* Analyse exploratoire
* Analyse métier orientée décision

---

## 🚀 Améliorations possibles

* Ajout d’index pour l’optimisation des requêtes
* Automatisation de l’import (SSIS / SQL Agent)
* Création de vues analytiques
* Connexion à Power BI pour la visualisation
* Gestion des dimensions (Artist, Album)

---

## 👤 Auteur

**Kodjo Georges AKAKPO**
Data Analyst | SQL | Power BI | Data Engineering
🔗 GitHub : [https://github.com/GeorgesProgrammer](https://github.com/GeorgesProgrammer)

---

Si tu veux, je peux maintenant :

* t’écrire une **description LinkedIn prête à poster**
* t’aider à découper ton SQL en fichiers professionnels
* transformer ce projet en **projet Power BI connecté à SQL Server**

Dis-moi 👍
