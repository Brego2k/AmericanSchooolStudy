-- Creo la tabella banned_items e importo i dati tramite il file csv

CREATE TABLE banned_items
(
	schoolname VARCHAR (55) NOT NULL,
	state VARCHAR (10) NOT NULL,
	item VARCHAR (200) NOT NULL,
	type VARCHAR (200)NOT NULL,
	proibited VARCHAR (55)
)

SELECT * FROM banned_items

-- Ora voglio trovare qual è lo stato maggiormente severo e quale invece è il più permissivo
-- Per prima cosa creo una nuova tabella con solo le due colonne state e proibited per visulaizzare meglio il problema

CREATE TABLE state_proibition AS
SELECT state, proibited
FROM banned_items

SELECT * FROM state_proibition

/*Per trovare lo stato più proibitivo e quello più permissivo creo una nuova tabella formata da una colonna "state" e 
una "proibitivo" dove uso la funzione COUNT() per contare i "male" (item proibiti ai maschi) e i "female" (item proibiti
alle femmine) e li divido per stato attraverso la funzione GROUP BY. Lo stato con il numero più alto sarà lo stato più 
proibitivo e uso la funzione MAX() per individuarlo, mentre lo stato con il numero più basso sarà lo stato più 
permissivo e uso la funzione MIN() per individuarlo*/

CREATE TABLE less_permessive AS
SELECT state, COUNT(state) AS proibitivo
FROM state_proibition
WHERE proibited IN ('male','female')
GROUP BY state
ORDER BY state

SELECT * FROM less_permessive

SELECT state, proibitivo
FROM less_permessive
WHERE proibitivo=(SELECT MAX(proibitivo)
				 FROM less_permessive)
				 
-- Texas(TX) è lo stato più proibitivo (258 item proibiti)

SELECT state, proibitivo
FROM less_permessive
WHERE proibitivo=(SELECT MIN(proibitivo)
				 FROM less_permessive)
				 
-- Delaware(DE), Michigan(MI), New York(NY) sono gli stati più permissivi (1 item proibito)

/*Ora voglio trovare quale istituto del Texas(TX) è il più proibitivo, creo quindi una tabella con solo i dati inerenti
al Texas(TX)*/

CREATE TABLE texas_tab AS
SELECT schoolname, state, item, type, proibited
FROM banned_items
WHERE state='TX'
ORDER BY schoolname

SELECT * FROM texas_tab

/*Uso lo stesso metodo di prima per trovare quanti item sono proibiti in ogni istituto. Uso la funzione MAX() per
trovare l'istituto in Texas più proibitivo*/

CREATE TABLE texas_moreproibited_school AS
SELECT schoolname, COUNT(schoolname) AS proibitivo
FROM texas_tab
WHERE proibited IN ('male','female')
GROUP BY schoolname
ORDER BY schoolname

SELECT * FROM texas_moreproibited_school

SELECT schoolname, proibitivo 
FROM texas_moreproibited_school
WHERE proibitivo=(SELECT MAX(proibitivo)
				 FROM texas_moreproibited_school)
				 
-- L'Hardin-Jefferson H S risulta essere l'istituto più proibitivo del Texas