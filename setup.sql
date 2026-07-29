CREATE TABLE clients(

    client_id        SERIAL PRIMARY KEY,
    nom              VARCHAR(100) NOT NULL,
    email            VARCHAR(150) UNIQUE NOT NULL,
    ville            VARCHAR(100),
    pays             VARCHAR(50) DEFAULT 'France',
    date_inscription DATE
)

INSERT INTO clients (client_id, email, ville, pays, date_insription)
values (val1, val2, val3, val4,val5)
;

CREATE TABLE produits(

    produit_id SERIAL PRIMARY KEY,
    nom        VARCHAR(150) NOT NULL,
    categorie  VARCHAR(100),
    prix       DECIMAL(10,2) NOT NULL,
    stock      INTEGER DEFAULT 0
)

INSERT VALUES produits(produit_id, nom, categorie, prix, stock)
values(val1, val2, val3, val4, val5);

CREATE TABLE commandes(

    commande_id   SERIAL PRIMARY KEY,
    client_id     INTEGER ,
    date_commande DATE NOT NULL,
    statut        VARCHAR(50) DEFAULT 'en_attente',
    total         DECIMAL(10,2)
)

INSERT VALUES commandes(commande_id, client_id,
date_inscription, date_commande, statut, total)

VALUES(val1, val2, val3, val4, val5, val6)

;

CREATE TABLE lignes_commandes ((
    ligne_id      SERIAL PRIMARY KEY,
    commande_id   INTEGER ,
    produit_id    INTEGER ,
    quantite      INTEGER NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL
)
INSERT VALUES lignes_commandes(ligne_id, commande_id, produit_id,
quantite, prix_unitaire)
VALUES(val1, val2, val3, val4, val5)

;