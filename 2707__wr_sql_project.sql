-- Q1 Afficher le nom et l'email de tous les clients

SELECT nom, email
FROM clients;

--Q2: Afficher tous les produits de la categorie 'Electronique'
SELECT *
FROM produits AS p
WHERE categorie = 'Electronique';

-- Q3: Afficher les produits dont le prix est supérieur à 50 €

SELECT *
FROM produits
WHERE prix > 50

-- Q4 Afficher les 5 produits les plus chers

SELECT *
FROM produits
ORDER BY prix DESC
LIMIT 5;

-- Q5: Afficher les clients qui habitent à Paris ou Lyon

SELECT *
FROM clients
WHERE ville = 'Paris' OR ville = 'Lyon';

-- Q6: Afficher les commandes avec le statut 'livré' ou 'expédiée'

SELECT *
FROM commandes
WHERE statut ='livre' OR statut ='expedie';

--Q7: Afficher les produits dont le nom contient le mot 'capable'(insensible à la caisse)

SELECT *
FROM produits
WHERE nom ILIKE 'cable%'; --insensible a la classe


-- Q8 Afficher les clients sans ville renseignée 
SELECT *
FROM clients
WHERE ville IS NULL;

-- Q9: Afficher les produits dont le prix est entre 20 et 100 euros, triés par prix croissant
SELECT *
FROM produits
WHERE prix BETWEEN 20 AND 100
ORDER BY prix DESC;

--Q10: Afficher la liste des catégories distinctes de produits
SELECT DISTINCT nom, categorie
FROM produits;

-- Q11 Afficher les commandes passées en 2023, triées du plus récent au plus ancien
SELECT *
FROM commandes
WHERE date_commande BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY date_commande DESC;

--Q12 Afficher le nom et le prix TTC(prix*1.20) de tous les produits, avec l'alias prix_ttc
SELECT
	nom, prix,
	prix*1.20 AS prix_ttc
FROM produits;

-- Q13 Afficher les 3 produits avec le moins de stock

SELECT *
FROM produits
ORDER BY stock ASC
LIMIT 3; 

--Q14 Afficher les clients inscrits après le 1er janvier 2022.
SELECT *
FROM clients
WHERE date_inscription > '2022-01-01'
order by date_inscription desc;

--Q15 Afficher les commandes dont le total est supérieur à 200 € et le statut 'livré'
SELECT *
FROM commandes
WHERE total > 200 AND statut = 'livre';

--Q16 Compter le nombre total de clients

SELECT 
	COUNT(*) AS nb
FROM clients

 --Q17 Calculer le prix moyen des produits
SELECT round(AVG(prix),2) AS prix_moyen
FROM produits;

 -- Q18 Afficher le produit le plus cher et le moins cher
SELECT
	MIN(prix) AS prix_min,
	MAX(prix) AS prix_max
FROM produits;

 -- Q19 Calculer le chiffre d'affaires total(somme des totaux de toutes les commandes)
 SELECT SUM(total) AS ca_total 
 FROM commandes;
 
 -- Q20 Compter le nombre de produits par catégorie
SELECT
	categorie, COUNT(*) AS nb_produits
FROM produits
GROUP BY categorie
ORDER BY nb_produits DESC;

 -- Q21 Afficher le total des commandes par statut

SELECT
	statut, COUNT(*) AS nb_commandes
FROM commandes
GROUP BY statut
ORDER BY nb_commandes DESC;

 --Q22 Calculer le panier moyen(total moyen d'une commande) par mois
SELECT
	extract(month from date_commande) AS mois,
    round(AVG(total),2) AS panier_moyen
FROM commandes
GROUP BY extract(month from date_commande)
ORDER BY mois;

-- Q23 Afficher les catégories avec un prix moyen supérieur à 50€

SELECT categorie, AVG(prix) AS prix_moyen
FROM produits
GROUP BY categorie HAVING AVG(prix)>50
ORDER BY prix_moyen DESC;

-- Q24 Afficher le nombre de commandes par client(client_id + nombre de commandes)
SELECT client_id, COUNT(*) AS nb_commande
FROM commandes
GROUP BY client_id
ORDER BY client_id ASC;

-- Q25 Afficher le client ayant passé plus de 3 commandes
SELECT client_id, COUNT(*) AS nb_commande
FROM commandes
GROUP BY client_id
HAVING COUNT(*) >3
ORDER BY client_id ASC;

-- Q26 Afficher le CA total par mois tiré chronologiquement

SELECT 
	extract(month from date_commande) AS mois,
    SUM(total) AS ca_total
FROM commandes
GROUP by extract(month from date_commande)
ORDER BY mois;

-- Q27 Afficher les catégories ayant au moins 3 produits en stock supérieur à 0

SELECT categorie, SUM(stock) AS stock_total 
FROM produits
GROUP BY categorie
HAVING COUNT(*) >3
ORDER BY stock_total ASC; 

-- Q28 Calculer la valeur totale du stock pour chaque catégorie(prix*stock)

SELECT categorie,
SUM(prix * stock) AS valeur_total_stock
FROM produits
GROUP BY categorie;

-- Q29 Afficher le nombre de clients par pays, uniquement les pays avec plus de 10 clients

SELECT pays, COUNT(*) AS nb_clients
FROM clients
GROUP BY pays
ORDER BY COUNT(*) > 10 ASC;

--Q30 Afficher le mois ayant généré le plus de commandes
SELECT extract(month from date_commande) AS mois,
COUNT(*) AS mois_le_plus_genere
FROM commandes
GROUP BY extract(month from date_commande)
ORDER BY mois_le_plus_genere DESC LIMIT 1;

--Q31 Afficher toutes les commandes avec le nom et l'email du client associé

SELECT
    co.*,
    cl.nom,
    cl.email
FROM commandes co
JOIN clients cl
    ON co.client_id = cl.client_id
ORDER BY co.date_commande;


-- Q32 Afficher les lignes de commande avec le nom du produit et la quantité commandée

SELECT co.client_id, co.total, c.nom
FROM commandes AS co

LEFT JOIN clients AS c
ON co.client_id = c.client_id
LEFT JOIN produits AS p
ON c.nom = p.nom


-- Q33 Afficher les clients qui n'ont jamais passé de commande

SELECT cl.client_id, co.client_id, co.commande_id
FROM clients AS cl
LEFT JOIN commandes AS co
ON cl.client_id = co.client_id
WHERE co.commande_id IS NULL

--Q34  Afficher le détail complet de commandes: client, produit, quantité, sous-total
SELECT c.client_id,
	cmd.commande_id,
	cmd.total AS ca_total,
	ls.commande_id,
	ls.produit_id,
	ls.quantite,
	ls.prix_unitaire
FROM clients c
LEFT JOIN commandes cmd
	ON c.client_id = cmd.client_id
LEFT JOIN lignes_commandes ls
	ON cmd.commande_id = ls.commande_id

--Q35 Afficher le CA total généré par chaque client (nom + total CA), trié par CA décroissant

SELECT *
FROM clients AS c

-- Q36 Afficher le nombre de fois que chaque produit a été commandé
SELECT p.nom AS nom_produit, COUNT(*) AS nb_commandes
FROM lignes_commandes AS lc
LEFT JOIN produits AS p
	ON lc.produit_id = p.produit_id
GROUP BY p.nom
ORDER BY nb_commandes DESC;

-- Q37 Afficher les produits qui n'ont jamais été commandés
SELECT
	p.produit_id,
	p.nom AS nom_produit,
	lc.quantite
FROM produits AS p
LEFT JOIN lignes_commandes AS lc
ON p.produit_id = lc.produit_id
WHERE lc.quantite IS NULL;

-- Q38 Afficher le CA total par catégorie de produit

SELECT
	p.categorie,
	COUNT(lc.quantite * lc.prix_unitaire) AS ca_total
FROM produits AS p
LEFT JOIN lignes_commandes AS lc
ON p.produit_id = lc.produit_id
GROUP BY p.categorie
ORDER BY ca_total DESC;

-- Q39 Afficher les 5 clients ayant le CA total le plus élevé 
SELECT
	c.nom,
	SUM(lc.quantite * lc.prix_unitaire) AS ca_total
FROM clients AS c
LEFT JOIN commandes AS cmd
ON c.client_id = cmd.client_id
LEFT JOIN lignes_commandes AS lc
ON cmd.commande_id = lc.commande_id
GROUP BY c.nom
ORDER BY ca_total DESC LIMIT 5;

-- Q40 Afficher le produit le plus vendu (en quantité totale)
SELECT 
	p.produit_id, 
	p.nom AS nom_produit,
	COUNT(lc.quantite) AS qt_vendu 
FROM produits AS p
LEFT JOIN lignes_commandes AS lc
	ON p.produit_id = lc.produit_id
LEFT JOIN commandes AS cmd
	ON cmd.commande_id = lc.commande_id
GROUP BY p.produit_id, nom_produit
ORDER BY qt_vendu DESC LIMIT 1;

--Q41 Afficher pour chaque commande: nom client, nombre d'articles, total commande

SELECT
c.nom,
lc.commande_id,
SUM(lc.quantite) AS nb_articles,
cmd.total AS total_commande
FROM commandes AS cmd
JOIN clients AS c
	ON c.client_id = cmd.client_id
JOIN lignes_commandes AS lc
	ON cmd.commande_id = lc.commande_id
GROUP BY c.nom, lc.commande_id, total_commande
ORDER BY commande_id DESC;

--Q42 Afficher les clients ayant commandé des produits de la catégorie 'Électronique'

SELECT DISTINCT
    c.client_id,
    c.nom
FROM clients c
JOIN commandes co ON co.client_id = c.client_id
JOIN lignes_commandes lc ON lc.commande_id = co.commande_id
JOIN produits p ON p.produit_id = lc.produit_id
WHERE p.categorie = 'Électronique'
ORDER BY c.nom;

--Q43 Afficher le CA moyen par commande pour chaque client

SELECT
c.nom,
round(AVG(cmd.total),2) AS ca_moyen_par_commande
FROM clients AS c
JOIN commandes AS cmd
ON c.client_id = cmd.client_id
JOIN lignes_commandes AS lc
ON  cmd.commande_id = lc.commande_id
GROUP BY c.nom, cmd. total
ORDER BY ca_moyen_par_commande DESC;

-- Q44 Afficher les produits vendus en 2023 avec leur catégorie et quantité totale

SELECT
p.nom AS nom_produit,
lc.quantite,
cmd.total AS ca_total

FROM produits AS p
JOIN lignes_commandes AS lc
ON lc.produit_id = p.produit_id
JOIN commandes AS cmd
ON lc.commande_id = cmd.commande_id
WHERE cmd.date_commande BETWEEN '01/01/2023' AND '01/01/2024';


-- Q45 Afficher les clients et le montant total de leurs commandes livrées uniquement

SELECT 
c.nom,
cmd.statut,
cmd.total AS ca_sous_total

FROM clients AS c
LEFT JOIN commandes AS cmd
ON c.client_id = cmd.client_id
WHERE cmd.statut = 'livre';

--Q46 Afficher les produits dont le prix est supérieur au prix moyen de leur catégorie

SELECT nom, categorie, prix
FROM produits
WHERE prix > (SELECT AVG(prix) FROM produits)
ORDER BY prix DESC;

--Q47 Afficher les clients qui n'ont passé aucune commande depuis 2022


SELECT client_id 
	FROM (
		SELECT 
		client_id, 
		MAX(date_commande) AS last_command_date
		FROM commandes
		GROUP BY client_id) as last_command_date
WHERE last_command_date < '01-01-2023';


--Q48 Avec une CTE, calculer le CA par client puis afficher ceux dont le CA dépasse 1000 euros

WITH ca_par_client AS (
		SELECT
		c.client_id,
		c.nom,
		round(SUM(cmd.total),2) AS ca_total
		FROM commandes AS cmd
		INNER JOIN clients AS c ON cmd.client_id = c.client_id
		GROUP BY c.client_id, c.nom
)
SELECT nom, ca_total
FROM ca_par_client
WHERE ca_total >1000
ORDER BY ca_total DESC;
--Q49 Créer une vue v_catalogue affichant nom, catégorie, prix, et stock de tous les produits en stock

CREATE OR REPLACE VIEW v_catalogue AS
SELECT
nom, 
categorie,
prix,
stock
FROM produits
WHERE stock > 0;

--Q50 Avec une CTE, trouver le mois ayant généré le plus de CA

WITH mois_ayant_genere_le_plus_de_ca AS 
	(SELECT 
extract(month from date_commande) AS mois,
SUM(total) AS ca_total
FROM commandes
GROUP BY extract(month from date_commande)
ORDER BY mois)
SELECT *
FROM mois_ayant_genere_le_plus_de_ca
ORDER BY ca_total DESC LIMIT 1;


--Q51 Afficher les produits commandés par au moins 3 clients différents 

WITH produit_commande_par_client AS (
	SELECT 
	cmd.client_id,
	COUNT(*) AS produit_commande
	FROM commandes AS cmd
	JOIN lignes_commandes AS lc
	ON cmd.commande_id = lc.commande_id
	GROUP BY cmd.client_id
	)
SELECT *
FROM produit_commande_par_client
WHERE produit_commande >= 3

 --Q52 Avec 2 CTEs; CA par catégorie, puis afficher uniquement les catégories dans le top 3

WITH ca_par_categorie AS (
    SELECT
        categorie,
        SUM(prix * stock) AS valeur_stock
    FROM produits
    GROUP BY categorie
),
top3 AS (
    SELECT *
    FROM ca_par_categorie
    ORDER BY valeur_stock DESC
    LIMIT 3
)
SELECT *
FROM top3
ORDER BY valeur_stock DESC;

 --Q53 Créer une v_top_clients affichant les 10 clients avec le plus grand nombre de commandes

CREATE OR REPLACE VIEW v_top_clients AS
WITH nb_commandes AS (
    SELECT
        client_id,
        COUNT(*) AS total_commandes
    FROM commandes
    GROUP BY client_id
)
SELECT *
FROM nb_commandes
ORDER BY total_commandes DESC
LIMIT 10;

 -- Q54 Afficher les commandes dont le total est supérieur à la moyenne des commandes du même mois 

SELECT cmd.*
FROM commandes as cmd
WHERE cmd.total > (
    SELECT AVG(co.total)
    FROM commandes co
    WHERE extract(MONTH from co.date_commande) = extract(MONTH from cmd.date_commande)
      AND extract(YEAR from co.date_commande) = extract(year from cmd.date_commande)
);


 -- Q55 Avec une CTE récursive (optionnel avancé): générer une suite de nombres de 1 à 10

 WITH RECURSIVE pairs AS (
    SELECT 2 AS n
    UNION ALL
    SELECT n + 2
    FROM pairs
    WHERE n < 20
)
SELECT n FROM pairs;


-- Q56 Afficher les email des clients en majuscules

select UPPER(email)
from clients;

-- Q57 Afficher le nom du produit et le domaine de l'email du client dans la même requête(JOIN + SPLIT_PART)

SELECT p.nom AS produit, SPLIT_PART(c.email, '@', 2) AS domaine_email
FROM commandes cmd
JOIN clients c ON cmd.client_id = c.client_id
JOIN lignes_commandes lc ON lc.commande_id = cmd.commande_id
JOIN produits p ON p.produit_id = lc.produit_id
ORDER BY p.nom;


-- Q58 Afficher les commandes passées un lundi

select extract(dow from date_commande)
from commandes;

-- Q59 Catégoriser les produits en 'Pas cher'(>20), 'Raisonnable'(<100), 'Cher' avec CASE WHEN

select categorie, prix,
case
	when prix < 20 then 'Pas cher'
	when prix <100 then 'Raisonable'
	else 'cher'
end as price_produit
from produits
order by prix desc;

-- Q60 Afficher les clients avec leur ville, en remplaçant les NULL par 'Ville inconnue'

SELECT 
    nom,
    COALESCE(ville, 'Ville inconnue') AS ville
FROM clients c;

-- Q61 Afficher le CA par année et par mois sous le format 'YYYY_MM'
SELECT 
    EXTRACT(YEAR FROM date_commande) AS annee,
    EXTRACT(MONTH FROM date_commande) AS mois,
    SUM(total) AS chiffre_affaires
FROM commandes
GROUP BY annee, mois
ORDER BY annee, mois;

-- Q62 Afficher le nombre de jours ecoules depuis chaque commande

select current_date
	select date_commande from commandes
	group by date_commande
where current_date - date_commande) as days_interval;
--where current_date - date_commande

-- Q63 Afficher les produits dont le nom contient un chiffre
select produit_id, nom, categorie
from produits

-- Q64 Afficher le CA total pour les commandes du dernier trimestre

SELECT
    TO_CHAR(DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months', 'YYYY-MM-DD')
        || ' → ' ||
    TO_CHAR(DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 day', 'YYYY-MM-DD')
        AS periode,
    SUM(total) AS ca_total
FROM commandes
WHERE date_commande >= DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months'
  AND date_commande <  DATE_TRUNC('quarter', CURRENT_DATE);

-- 65 Afficher les initiales de chaque client (premiere lettre du prenom + premiere lettre du nom)
select nom,
	concat(left(split_part(nom, ' ', 2),1),
	'.', left(split_part(nom, ' ', 1),1))
from clients;

-- Chapitre 6

-- -- Q1 — Classer tous les produits par prix décroissant avec ROW_NUMBER().
--       Colonnes attendues : nom, categorie, prix, rang
select nom, categorie, prix, 
row_number() over (order by prix desc) as rang
from produits;

-- Q2 — Pour chaque catégorie, classer les produits par prix décroissant
--       avec RANK(). Le classement doit repartir à 1 pour chaque catégorie.
--       Colonnes attendues : nom, categorie, prix, rang_dans_categorie

select nom, categorie, prix,
rank() over(order by categorie desc) as rang_dans_categorie
from produits;

-- Q3 — Même chose qu'en Q2 mais avec DENSE_RANK() au lieu de RANK().
--       Observer la différence en cas d'ex-aequo.
--       Colonnes attendues : nom, categorie, prix, rang_dense

select nom, categorie, prix,
dense_rank() over(order by categorie desc) as rang_dens
from produits;

-- Q4 — Afficher uniquement le produit le plus cher de chaque catégorie.
--       Utiliser ROW_NUMBER() dans une CTE puis filtrer rang = 1.
--       Colonnes attendues : categorie, nom, prix
-- Indice : WITH cte AS (SELECT ..., ROW_NUMBER() ...) SELECT ... FROM cte WHERE rang = 1

--option 1 CTE
with price_category as (
select categorie, nom, prix,
        ROW_NUMBER() OVER (partition by categorie
            order by prix desc) AS categorie_rang
			from produits)
select nom, categorie, prix
from price_category
where categorie_rang = 1
order by categorie;

-- option 2 raquette 

select *
from (select categorie, nom, prix,
        ROW_NUMBER() OVER (partition by categorie
            order by prix desc) AS categorie_rang
			from produits) as cr
where categorie_rang = 1

-- Q5 — Classer les commandes par total décroissant avec les trois fonctions
--       ROW_NUMBER(), RANK() et DENSE_RANK() dans la même requête.
--       Observer les différences en cas d'ex-aequo.
--       Colonnes attendues : commande_id, total, rn, rk, dr

select commande_id, total,
	row_number() over(order by total desc) as rn,
	rank () over(order by total desc) as rk,
	dense_rank() over(order by total desc) as dr
from commandes;

-- Q6 — Pour chaque commande, afficher le total de la commande précédente
--       (dans l'ordre chronologique).
--       La première ligne doit afficher NULL pour le total précédent.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent

select commande_id, date_commande, total,
lag(total) over (order by date_commande) as total_precedent
from commandes
order by date_commande;

-- Q7 — Calculer l'évolution en euros entre chaque commande et la précédente.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent, evolution_euros
-- Indice : total - LAG(total) OVER (ORDER BY date_commande)

select commande_id, client_id, total,
lag(total) over (order by date_commande) as total_precedent, 
total - lag(total) over(order by date_commande) as evolution_euros
from commandes

-- Q8 — Pour chaque commande, afficher le total de la commande suivante.
--       La dernière ligne doit afficher NULL pour le total suivant.
--       Colonnes attendues : commande_id, date_commande, total, total_suivant

select commande_id, date_commande, total,
sum(total) over(order by date_commande rows between unbounded preceding and current row) as ca_cumule
from commandes
order by date_commande;


-- Q9 — Pour chaque client, afficher ses commandes avec le total de
--       SA commande précédente (pas celle d'un autre client).
--       Utiliser PARTITION BY client_id.
--       Colonnes attendues : client_id, commande_id, date_commande, total, commande_prec_client

select client_id, commande_id, date_commande, total,
sum(total) over(partition by client_id rows between unbounded preceding and current row) as commande_precedent
from commandes
order by date_commande;

-- Q10 — Calculer la variation en % entre chaque commande et la précédente.
--        Arrondir à 1 décimale. Remplacer NULL par 0 pour la première ligne.
--        Colonnes attendues : commande_id, date_commande, total, variation_pct
-- Indice : ROUND((total - LAG(total)...) / NULLIF(LAG(total)..., 0) * 100, 1)
--          LAG(total, 1, total) OVER (...) pour éviter le NULL

SELECT
    commande_id, date_commande, total,
    LAG(total) OVER (ORDER BY date_commande) AS montant_precedent,
    CASE 
        WHEN LAG(total) OVER (ORDER BY date_commande) IS NULL THEN NULL
        WHEN LAG(total) OVER (ORDER BY date_commande) = 0 THEN NULL
        ELSE ROUND(
            ((total - LAG(total) OVER (ORDER BY date_commande)) 
             / LAG(total) OVER (ORDER BY date_commande)) * 100, 2)
    END AS variation_pourcent
FROM commandes
ORDER BY date_commande;


-- Q11 — Afficher pour chaque commande son total ET le CA global de toutes
--        les commandes sur la même ligne.
--        Colonnes attendues : commande_id, total, ca_global

select commande_id, client_id, total,
sum(total) over (partition by client_id) as ca_global
from commandes;

-- Q12 — Calculer le pourcentage que représente chaque commande
--        dans le CA total. Arrondir à 2 décimales.
--        Colonnes attendues : commande_id, total, ca_global, pct_du_total

select commande_id, client_id, total,
sum(total) over (partition by client_id) as ca_global,
ROUND(((total)/ sum(total) OVER(partition by client_id
ORDER BY date_commande)) * 100, 2) as pourcentage_du_client
from commandes
order by client_id, total desc;


-- Q13 — Pour chaque client, afficher chaque commande avec le CA total
--        de CE client (PARTITION BY client_id).
--        Colonnes attendues : client_id, commande_id, total, ca_total_client

SELECT client_id, commande_id, total,
    SUM(total) OVER (PARTITION BY client_id) AS ca_total_client
FROM commandes
ORDER BY client_id, commande_id;

-- Q14 — Pour chaque commande d'un client, calculer le pourcentage
--        qu'elle représente dans le CA total de ce client.
--        Colonnes attendues : client_id, commande_id, total, ca_total_client, pct_du_client

select client_id, commande_id, total,
    SUM(total) OVER (PARTITION BY client_id) AS ca_total_client,
   round(total / SUM(total) OVER (PARTITION BY client_id), 2)*100 AS pct_commande
FROM commandes
ORDER BY client_id, commande_id;


-- Q15 — Calculer le CA cumulé de toutes les commandes par ordre chronologique.
--        Chaque ligne doit afficher la somme de toutes les commandes
--        depuis la première jusqu'à elle-même.
--        Colonnes attendues : commande_id, date_commande, total, ca_cumule

select commande_id, date_commande, total,
sum(total) over (order by date_commande) as ca_cumulr
from commandes
order by client_id, date_commande;

-- Q16 — Calculer le CA cumulé PAR CLIENT et par date.
--        Le cumul repart à 0 pour chaque nouveau client.
--        Colonnes attendues : client_id, commande_id, date_commande, total, ca_cumule_client
-- Indice : SUM(total) OVER (PARTITION BY client_id ORDER BY date_commande)

select commande_id, client_id, date_commande, total,
		sum(total) over (partition by client_id
		order by date_commande  
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ca_cumule_client
from commandes
order by client_id, date_commande;

-- Q17 — Pour chaque commande, afficher aussi la date de la toute première
--        commande passée (tous clients confondus).
--        Colonnes attendues : commande_id, date_commande, total, premiere_commande_globale

select client_id, commande_id, date_commande, total,
    MIN(date_commande) OVER () AS premiere_commande_globale,
    MIN(date_commande) OVER (PARTITION BY client_id) AS premiere_commande_client
FROM commandes;


-- Q18 — Pour chaque client, afficher sur chaque commande
--        la date de sa première commande et la date de sa dernière commande.
--        Colonnes attendues : client_id, commande_id, date_commande, premiere, derniere
-- Indice : LAST_VALUE nécessite ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

select client_id, commande_id, date_commande, total,
    MIN(date_commande) OVER () AS premiere_commande_globale,
    MAX(date_commande) OVER (PARTITION BY client_id) AS derniere_commande_client
FROM commandes;

-- Q19 — Diviser les produits en 4 quartiles selon leur prix.
--        Quartile 1 = produits les moins chers, 4 = les plus chers.
--        Colonnes attendues : nom, categorie, prix, quartile

SELECT produit_id, nom, prix,
    NTILE(4) OVER (ORDER BY prix) AS quartile_prix
FROM produits
ORDER BY prix;


-- Q20 — Diviser les commandes en 3 groupes égaux selon leur total.
--        Groupe 1 = commandes les moins élevées, 3 = les plus élevées.
--        Colonnes attendues : commande_id, total, groupe

WITH groupes AS (SELECT commande_id, total,
        NTILE(3) OVER (ORDER BY total) AS groupe
    FROM commandes)
SELECT
    groupe,
    MIN(total) AS moins_chere,
	round(AVg(total),2) as moyen,
    MAX(total) as les_plus_chere
FROM groupes
GROUP BY groupe
ORDER BY groupe;

-- Q21 — Classer les clients par CA total décroissant avec DENSE_RANK().
--        Utiliser une CTE pour calculer d'abord le CA par client.
--        Colonnes attendues : nom, ca_total, rang

WITH ca_par_client AS (SELECT client_id,
        SUM(total) AS ca_total
    FROM commandes
    GROUP BY client_id)
SELECT
    client_id,
    ca_total,
    DENSE_RANK() OVER (ORDER BY ca_total DESC) AS rang_ca
FROM ca_par_client
ORDER BY rang_ca, client_id;

-- Q22 — Calculer le CA mensuel et la variation en % par rapport
--        au mois précédent. Utiliser une CTE + LAG.
--        Colonnes attendues : mois, ca_mensuel, ca_precedent, variation_pct
-- Indice : DATE_TRUNC('month', date_commande) pour grouper par mois


WITH ca_mois AS (
	SELECT DATE_TRUNC('month', date_commande) AS mois,
	        SUM(total) AS ca_mensuel
	    FROM commandes
	    GROUP BY DATE_TRUNC('month', date_commande)
)
SELECT mois, ca_mensuel,
    LAG(ca_mensuel) OVER (ORDER BY mois) AS ca_precedent,
    ROUND(100.0 * (ca_mensuel - LAG(ca_mensuel) OVER (ORDER BY mois))
        / NULLIF(LAG(ca_mensuel) OVER (ORDER BY mois), 0), 2) AS variation_pct
FROM ca_mois
ORDER BY mois;

-- Q23 — Pour chaque produit vendu, afficher la quantité commandée
--        et la quantité cumulée depuis le début (par produit).
--        Jointure lignes_commande + produits + commandes nécessaire.
--        Colonnes attendues : produit, date_commande, quantite, quantite_cumulee


SELECT p.nom AS produit, c.client_id, c.date_commande, lc.quantite,
	    SUM(lc.quantite) OVER (PARTITION BY p.produit_id
	        ORDER BY c.date_commande ) AS quantite_cumulee
FROM lignes_commandes lc
JOIN produits p ON lc.produit_id = p.produit_id
JOIN commandes c ON lc.commande_id = c.commande_id;

-- Q24 — Identifier la première et la dernière commande de chaque client
--        en une seule requête. Afficher une ligne par client.
--        Colonnes attendues : nom, premiere_commande, derniere_commande, nb_commandes
-- Indice : DISTINCT + FIRST_VALUE + LAST_VALUE + COUNT OVER (PARTITION BY)

WITH stats AS (
	SELECT  client_id,
		MIN(date_commande) AS premiere_commande,
        MAX(date_commande) AS derniere_commande,
        COUNT(*) AS nb_commandes,
        SUM(total) AS ca_total
    FROM commandes
    GROUP BY client_id)
SELECT
    c.nom,
    s.premiere_commande,
    s.derniere_commande,
    s.nb_commandes,
    s.ca_total
FROM stats s
JOIN clients c ON c.client_id = s.client_id;

-- Q25 — Pour chaque commande, afficher :
--        - son total
--        - le total de la commande précédente (LAG)
--        - le CA cumulé jusqu'à cette commande (SUM OVER ORDER BY)
--        - son rang parmi toutes les commandes (RANK par total décroissant)
--        Colonnes attendues : commande_id, date_commande, total,
--                             total_prec, ca_cumule, rang_total

SELECT commande_id, date_commande, total,
    LAG(total) OVER (ORDER BY date_commande) AS total_precedent,
    SUM(total) OVER (ORDER BY date_commande) AS ca_cumule,
    RANK() OVER (ORDER BY total DESC) AS rang_total
FROM commandes
ORDER BY date_commande;

FROM commandes cmd
JOIN clients c ON cmd.client_id = c.client_id
JOIN lignes_commandes lc ON lc.commande_id = cmd.commande_id
JOIN produits p ON p.produit_id = lc.produit_id
ORDER BY p.nom;


-- Q58 Afficher les commandes passées un lundi

select extract(dow from date_commande)
from commandes;

-- Q59 Catégoriser les produits en 'Pas cher'(>20), 'Raisonnable'(<100), 'Cher' avec CASE WHEN

select categorie, prix,
case
	when prix < 20 then 'Pas cher'
	when prix <100 then 'Raisonable'
	else 'cher'
end as price_produit
from produits
order by prix desc;

-- Q60 Afficher les clients avec leur ville, en remplaçant les NULL par 'Ville inconnue'

SELECT 
    nom,
    COALESCE(ville, 'Ville inconnue') AS ville
FROM clients c;

-- Q61 Afficher le CA par année et par mois sous le format 'YYYY_MM'
SELECT 
    EXTRACT(YEAR FROM date_commande) AS annee,
    EXTRACT(MONTH FROM date_commande) AS mois,
    SUM(total) AS chiffre_affaires
FROM commandes
GROUP BY annee, mois
ORDER BY annee, mois;

-- Q62 Afficher le nombre de jours ecoules depuis chaque commande

select current_date
	select date_commande from commandes
	group by date_commande
where current_date - date_commande) as days_interval;
--where current_date - date_commande

-- Q63 Afficher les produits dont le nom contient un chiffre
select produit_id, nom, categorie
from produits

-- Q64 Afficher le CA total pour les commandes du dernier trimestre

SELECT
    TO_CHAR(DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months', 'YYYY-MM-DD')
        || ' → ' ||
    TO_CHAR(DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 day', 'YYYY-MM-DD')
        AS periode,
    SUM(total) AS ca_total
FROM commandes
WHERE date_commande >= DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months'
  AND date_commande <  DATE_TRUNC('quarter', CURRENT_DATE);

-- 65 Afficher les initiales de chaque client (premiere lettre du prenom + premiere lettre du nom)
select nom,
	concat(left(split_part(nom, ' ', 2),1),
	'.', left(split_part(nom, ' ', 1),1))
from clients;

-- Chapitre 6

-- -- Q1 — Classer tous les produits par prix décroissant avec ROW_NUMBER().
--       Colonnes attendues : nom, categorie, prix, rang
select nom, categorie, prix, 
row_number() over (order by prix desc) as rang
from produits;

-- Q2 — Pour chaque catégorie, classer les produits par prix décroissant
--       avec RANK(). Le classement doit repartir à 1 pour chaque catégorie.
--       Colonnes attendues : nom, categorie, prix, rang_dans_categorie

select nom, categorie, prix,
rank() over(order by categorie desc) as rang_dans_categorie
from produits;

-- Q3 — Même chose qu'en Q2 mais avec DENSE_RANK() au lieu de RANK().
--       Observer la différence en cas d'ex-aequo.
--       Colonnes attendues : nom, categorie, prix, rang_dense

select nom, categorie, prix,
dense_rank() over(order by categorie desc) as rang_dens
from produits;

-- Q4 — Afficher uniquement le produit le plus cher de chaque catégorie.
--       Utiliser ROW_NUMBER() dans une CTE puis filtrer rang = 1.
--       Colonnes attendues : categorie, nom, prix
-- Indice : WITH cte AS (SELECT ..., ROW_NUMBER() ...) SELECT ... FROM cte WHERE rang = 1

--option 1 CTE
with price_category as (
select categorie, nom, prix,
        ROW_NUMBER() OVER (partition by categorie
            order by prix desc) AS categorie_rang
			from produits)
select nom, categorie, prix
from price_category
where categorie_rang = 1
order by categorie;

-- option 2 raquette 

select *
from (select categorie, nom, prix,
        ROW_NUMBER() OVER (partition by categorie
            order by prix desc) AS categorie_rang
			from produits) as cr
where categorie_rang = 1

-- Q5 — Classer les commandes par total décroissant avec les trois fonctions
--       ROW_NUMBER(), RANK() et DENSE_RANK() dans la même requête.
--       Observer les différences en cas d'ex-aequo.
--       Colonnes attendues : commande_id, total, rn, rk, dr

select commande_id, total,
	row_number() over(order by total desc) as rn,
	rank () over(order by total desc) as rk,
	dense_rank() over(order by total desc) as dr
from commandes;

-- Q6 — Pour chaque commande, afficher le total de la commande précédente
--       (dans l'ordre chronologique).
--       La première ligne doit afficher NULL pour le total précédent.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent

select commande_id, date_commande, total,
lag(total) over (order by date_commande) as total_precedent
from commandes
order by date_commande;

-- Q7 — Calculer l'évolution en euros entre chaque commande et la précédente.
--       Colonnes attendues : commande_id, date_commande, total, total_precedent, evolution_euros
-- Indice : total - LAG(total) OVER (ORDER BY date_commande)

select commande_id, client_id, total,
lag(total) over (order by date_commande) as total_precedent, 
total - lag(total) over(order by date_commande) as evolution_euros
from commandes

-- Q8 — Pour chaque commande, afficher le total de la commande suivante.
--       La dernière ligne doit afficher NULL pour le total suivant.
--       Colonnes attendues : commande_id, date_commande, total, total_suivant

select commande_id, date_commande, total,
sum(total) over(order by date_commande rows between unbounded preceding and current row) as ca_cumule
from commandes
order by date_commande;


-- Q9 — Pour chaque client, afficher ses commandes avec le total de
--       SA commande précédente (pas celle d'un autre client).
--       Utiliser PARTITION BY client_id.
--       Colonnes attendues : client_id, commande_id, date_commande, total, commande_prec_client

select client_id, commande_id, date_commande, total,
sum(total) over(partition by client_id rows between unbounded preceding and current row) as commande_precedent
from commandes
order by date_commande;

-- Q10 — Calculer la variation en % entre chaque commande et la précédente.
--        Arrondir à 1 décimale. Remplacer NULL par 0 pour la première ligne.
--        Colonnes attendues : commande_id, date_commande, total, variation_pct
-- Indice : ROUND((total - LAG(total)...) / NULLIF(LAG(total)..., 0) * 100, 1)
--          LAG(total, 1, total) OVER (...) pour éviter le NULL

SELECT
    commande_id, date_commande, total,
    LAG(total) OVER (ORDER BY date_commande) AS montant_precedent,
    CASE 
        WHEN LAG(total) OVER (ORDER BY date_commande) IS NULL THEN NULL
        WHEN LAG(total) OVER (ORDER BY date_commande) = 0 THEN NULL
        ELSE ROUND(
            ((total - LAG(total) OVER (ORDER BY date_commande)) 
             / LAG(total) OVER (ORDER BY date_commande)) * 100, 2)
    END AS variation_pourcent
FROM commandes
ORDER BY date_commande;


-- Q11 — Afficher pour chaque commande son total ET le CA global de toutes
--        les commandes sur la même ligne.
--        Colonnes attendues : commande_id, total, ca_global

select commande_id, client_id, total,
sum(total) over (partition by client_id) as ca_global
from commandes;

-- Q12 — Calculer le pourcentage que représente chaque commande
--        dans le CA total. Arrondir à 2 décimales.
--        Colonnes attendues : commande_id, total, ca_global, pct_du_total

select commande_id, client_id, total,
sum(total) over (partition by client_id) as ca_global,
ROUND(((total)/ sum(total) OVER(partition by client_id
ORDER BY date_commande)) * 100, 2) as pourcentage_du_client
from commandes
order by client_id, total desc;


-- Q13 — Pour chaque client, afficher chaque commande avec le CA total
--        de CE client (PARTITION BY client_id).
--        Colonnes attendues : client_id, commande_id, total, ca_total_client

SELECT client_id, commande_id, total,
    SUM(total) OVER (PARTITION BY client_id) AS ca_total_client
FROM commandes
ORDER BY client_id, commande_id;

-- Q14 — Pour chaque commande d'un client, calculer le pourcentage
--        qu'elle représente dans le CA total de ce client.
--        Colonnes attendues : client_id, commande_id, total, ca_total_client, pct_du_client

select client_id, commande_id, total,
    SUM(total) OVER (PARTITION BY client_id) AS ca_total_client,
   round(total / SUM(total) OVER (PARTITION BY client_id), 2)*100 AS pct_commande
FROM commandes
ORDER BY client_id, commande_id;


-- Q15 — Calculer le CA cumulé de toutes les commandes par ordre chronologique.
--        Chaque ligne doit afficher la somme de toutes les commandes
--        depuis la première jusqu'à elle-même.
--        Colonnes attendues : commande_id, date_commande, total, ca_cumule

select commande_id, date_commande, total,
sum(total) over (order by date_commande) as ca_cumulr
from commandes
order by client_id, date_commande;

-- Q16 — Calculer le CA cumulé PAR CLIENT et par date.
--        Le cumul repart à 0 pour chaque nouveau client.
--        Colonnes attendues : client_id, commande_id, date_commande, total, ca_cumule_client
-- Indice : SUM(total) OVER (PARTITION BY client_id ORDER BY date_commande)

select commande_id, client_id, date_commande, total,
		sum(total) over (partition by client_id
		order by date_commande  
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ca_cumule_client
from commandes
order by client_id, date_commande;

-- Q17 — Pour chaque commande, afficher aussi la date de la toute première
--        commande passée (tous clients confondus).
--        Colonnes attendues : commande_id, date_commande, total, premiere_commande_globale

select client_id, commande_id, date_commande, total,
    MIN(date_commande) OVER () AS premiere_commande_globale,
    MIN(date_commande) OVER (PARTITION BY client_id) AS premiere_commande_client
FROM commandes;


-- Q18 — Pour chaque client, afficher sur chaque commande
--        la date de sa première commande et la date de sa dernière commande.
--        Colonnes attendues : client_id, commande_id, date_commande, premiere, derniere
-- Indice : LAST_VALUE nécessite ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

select client_id, commande_id, date_commande, total,
    MIN(date_commande) OVER () AS premiere_commande_globale,
    MAX(date_commande) OVER (PARTITION BY client_id) AS derniere_commande_client
FROM commandes;

-- Q19 — Diviser les produits en 4 quartiles selon leur prix.
--        Quartile 1 = produits les moins chers, 4 = les plus chers.
--        Colonnes attendues : nom, categorie, prix, quartile

SELECT produit_id, nom, prix,
    NTILE(4) OVER (ORDER BY prix) AS quartile_prix
FROM produits
ORDER BY prix;


-- Q20 — Diviser les commandes en 3 groupes égaux selon leur total.
--        Groupe 1 = commandes les moins élevées, 3 = les plus élevées.
--        Colonnes attendues : commande_id, total, groupe

WITH groupes AS (SELECT commande_id, total,
        NTILE(3) OVER (ORDER BY total) AS groupe
    FROM commandes)
SELECT
    groupe,
    MIN(total) AS moins_chere,
	round(AVg(total),2) as moyen,
    MAX(total) as les_plus_chere
FROM groupes
GROUP BY groupe
ORDER BY groupe;

-- Q21 — Classer les clients par CA total décroissant avec DENSE_RANK().
--        Utiliser une CTE pour calculer d'abord le CA par client.
--        Colonnes attendues : nom, ca_total, rang

WITH ca_par_client AS (SELECT client_id,
        SUM(total) AS ca_total
    FROM commandes
    GROUP BY client_id)
SELECT
    client_id,
    ca_total,
    DENSE_RANK() OVER (ORDER BY ca_total DESC) AS rang_ca
FROM ca_par_client
ORDER BY rang_ca, client_id;

-- Q22 — Calculer le CA mensuel et la variation en % par rapport
--        au mois précédent. Utiliser une CTE + LAG.
--        Colonnes attendues : mois, ca_mensuel, ca_precedent, variation_pct
-- Indice : DATE_TRUNC('month', date_commande) pour grouper par mois


WITH ca_mois AS (
	SELECT DATE_TRUNC('month', date_commande) AS mois,
	        SUM(total) AS ca_mensuel
	    FROM commandes
	    GROUP BY DATE_TRUNC('month', date_commande)
)
SELECT mois, ca_mensuel,
    LAG(ca_mensuel) OVER (ORDER BY mois) AS ca_precedent,
    ROUND(100.0 * (ca_mensuel - LAG(ca_mensuel) OVER (ORDER BY mois))
        / NULLIF(LAG(ca_mensuel) OVER (ORDER BY mois), 0), 2) AS variation_pct
FROM ca_mois
ORDER BY mois;

-- Q23 — Pour chaque produit vendu, afficher la quantité commandée
--        et la quantité cumulée depuis le début (par produit).
--        Jointure lignes_commande + produits + commandes nécessaire.
--        Colonnes attendues : produit, date_commande, quantite, quantite_cumulee


SELECT p.nom AS produit, c.client_id, c.date_commande, lc.quantite,
	    SUM(lc.quantite) OVER (PARTITION BY p.produit_id
	        ORDER BY c.date_commande ) AS quantite_cumulee
FROM lignes_commandes lc
JOIN produits p ON lc.produit_id = p.produit_id
JOIN commandes c ON lc.commande_id = c.commande_id;

-- Q24 — Identifier la première et la dernière commande de chaque client
--        en une seule requête. Afficher une ligne par client.
--        Colonnes attendues : nom, premiere_commande, derniere_commande, nb_commandes
-- Indice : DISTINCT + FIRST_VALUE + LAST_VALUE + COUNT OVER (PARTITION BY)

WITH stats AS (
	SELECT  client_id,
		MIN(date_commande) AS premiere_commande,
        MAX(date_commande) AS derniere_commande,
        COUNT(*) AS nb_commandes,
        SUM(total) AS ca_total
    FROM commandes
    GROUP BY client_id)
SELECT
    c.nom,
    s.premiere_commande,
    s.derniere_commande,
    s.nb_commandes,
    s.ca_total
FROM stats s
JOIN clients c ON c.client_id = s.client_id;

-- Q25 — Pour chaque commande, afficher :
--        - son total
--        - le total de la commande précédente (LAG)
--        - le CA cumulé jusqu'à cette commande (SUM OVER ORDER BY)
--        - son rang parmi toutes les commandes (RANK par total décroissant)
--        Colonnes attendues : commande_id, date_commande, total,
--                             total_prec, ca_cumule, rang_total

SELECT commande_id, date_commande, total,
    LAG(total) OVER (ORDER BY date_commande) AS total_precedent,
    SUM(total) OVER (ORDER BY date_commande) AS ca_cumule,
    RANK() OVER (ORDER BY total DESC) AS rang_total
FROM commandes
ORDER BY date_commande;
