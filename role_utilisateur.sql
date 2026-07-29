-- RÔLES ET UTILISATEURS


-- Q1 — Créer un rôle ecommerce_readonly qui ne peut que lire les données

create role ecommerce_readonly;

-- Q2 — Créer un rôle ecommerce_engineer qui peut lire et modifier les données

create role ecommerce_engineer;

-- Q3 — Créer un utilisateur analyste_user avec le mot de passe analyste123
--       et lui assigner le rôle ecommerce_readonly

create user analyste_user with login password 'analyste123';
grant analyste_user to ecommerce_readonly with inherit true;

-- Q4 — Créer un utilisateur engineer_user avec le mot de passe engineer123
--       et lui assigner le rôle ecommerce_engineer

create user engineer_user with login password 'engineer123';
grant engineer_user to ecommerce_engineer with inherit true;

-- Privilèges

-- Q5 — Donner accès à la base de données aux deux rôles

grant connect on database sqlproject to ecommerce_readonly, ecommerce_engineer; 

-- Q6 — Donner accès au schéma public aux deux rôles

grant usage on schema public to ecommerce_readonly, ecommerce_engineer;

-- Q7 — Accorder le privilège SELECT sur toutes les tables au rôle ecommerce_readonly

grant select on all tables in schema public to ecommerce_readonly;

-- Q8 — Accorder les privilèges SELECT, INSERT, UPDATE, DELETE
--       sur toutes les tables au rôle ecommerce_engineer

grant select, insert, update, delete 
on all tables in schema public to ecommerce_engineer;

-- Q9 — Faire en sorte que ces privilèges s'appliquent automatiquement aux futures tables

ALTER default privileges in schema public
	grant select on tables to ecommerce_readonly;

ALTER default privileges in schema public
	grant select, insert, update, delete on tables to ecommerce_engineer;

-- Q10 — Révoquer tous les accès publics sur les tables

REVOKE all on schema public from public;

--Index

-- Q11 — Créer un index sur la colonne client_id de la table commandes
create index if not exists indx_index_id
on commandes(client_id);

-- Q12 — Créer un index sur la colonne date_commande de la table commandes
create index if not exists indx_date_commande
on commandes(date_commande);

-- Q13 — Créer un index sur la colonne statut de la table commandes
create index if not exists indx_statut
on commandes(statut);

-- Q14 — Créer un index sur la colonne commande_id de la table lignes_commande

create index if not exists indx_commande_id
on lignes_commandes(commande_id);


-- Q15 — Créer un index sur la colonne produit_id de la table lignes_commande

create index if not exists indx_produit_id
on lignes_commandes(produit_id);

-- Q16 — Créer un index sur la colonne categorie de la table produits
create index if not exists idx_categorie
on produits(categorie);

-- Q17 — Créer un index partiel sur date_commande
--        uniquement pour les commandes avec statut 'livre'

create index if not exists indx_statut_livre
on commandes(date_commande) where statut = 'livre';

-- Q18 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index
--        sur une requête filtrée par statut

EXPLAIN ANALYZE select * from commandes
where statut = 'livre'; 

-- Q19 — Utiliser EXPLAIN ANALYZE pour vérifier l'impact de l'index
--        sur une requête filtrée par date

EXPLAIN ANALYZE select * from commandes
where date_commande between '2022/01/01' and '2022/06/01';


-- CONTRAINTES

-- Q20 — Ajouter une contrainte : prix d'un produit toujours positif

ALTER TABLE produits
ADD CONSTRAINT prix_positif CHECK (prix > 0);

-- Q21 — Ajouter une contrainte : stock d'un produit toujours positif ou nul

ALTER TABLE produits
ADD CONSTRAINT stock_positif CHECK (stock >= 0);

-- Q22 — Ajouter une contrainte : statut d'une commande uniquement
--        'en_attente', 'expedie', 'livre' ou 'annule'

ALTER TABLE commandes
ADD CONSTRAINT statut_valid CHECK (statut in ('en_attente', 'expedie', 'livre', 'annule'));

-- Q23 — Ajouter une contrainte : quantité dans lignes_commande toujours positive

ALTER TABLE lignes_commandes
ADD CONSTRAINT quantite_positif CHECK (quantite > 0);

-- Q24 — Ajouter une contrainte : prix_unitaire dans lignes_commande toujours positif

ALTER TABLE lignes_commandes
ADD CONSTRAINT prix_unitaire_positif CHECK (prix_unitaire > 0);

-- Q25 — Tester qu'une contrainte fonctionne
--        en essayant d'insérer une valeur invalide (doit retourner une erreur)

INSERT INTO produits
VALUES (42, 'Alice', 'Electronique', -25, -12); --OK

--  
-- VÉRIFICATIONS

-- Q26 — Lister tous les index créés sur les tables du schéma public

SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;


-- Q27 — Lister toutes les contraintes sur les 4 tables

SELECT
    c.conname,
    t.relname AS table_name,
    c.contype,
    pg_get_constraintdef(c.oid)
FROM pg_constraint c
JOIN pg_class t ON t.oid = c.conrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
WHERE n.nspname = 'public'
ORDER BY t.relname, c.conname;


-- Q28 — Vérifier les privilèges accordés aux rôles ecommerce_readonly et ecommerce_engineer


SELECT
    n.nspname AS schema_name,
    c.relname AS object_name,
    c.relkind AS object_type,
    pg_roles.rolname AS grantee,
    c.relacl AS raw_acl,
    pg_catalog.array_to_string(c.relacl, E'\n') AS acl_text
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_roles ON pg_roles.rolname IN ('ecommerce_readonly', 'ecommerce_engineer')
WHERE n.nspname = 'public'
  AND c.relacl IS NOT NULL
  AND (
        pg_catalog.array_to_string(c.relacl, ' ') LIKE '%ecommerce_readonly%'
     OR pg_catalog.array_to_string(c.relacl, ' ') LIKE '%ecommerce_engineer%')
ORDER BY object_type, object_name;

 
-- SAUVEGARDE (à exécuter dans le terminal)

-- ecommerce_readonly=r/postgres
-- ecommerce_engineer=arwdDxt/postgres

-- Q29 — Faire un dump compressé de la base de données
-- Commande à exécuter dans le terminal :

-- pg_dump -U postgres -F p ecommerce_db | gzip > dump.sql.gz


-- Q30 — Faire un dump SQL lisible de la base de données
-- Commande à exécuter dans le terminal :

--pg_dump -U <analyste_user> -h <hôte> -p <port> -F p <sqlproject> <nom_dump>.sql


