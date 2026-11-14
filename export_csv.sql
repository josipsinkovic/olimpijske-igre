\set ON_ERROR_STOP on
\encoding UTF8
\pset pager off

CREATE TEMP VIEW izvoz_csv AS
SELECT s.id     AS sportas_id,
       s.ime,
       s.prezime,
       s.datum_rodenja,
       s.spol,
       s.drzava,
       i.godina AS igre_godina,
       i.sezona AS igre_sezona,
       i.grad   AS igre_grad,
       d.sport,
       d.naziv  AS disciplina,
       m.vrsta  AS medalja
FROM sportasi s
JOIN medalje    m ON m.sportas_id = s.id
JOIN discipline d ON d.id = m.disciplina_id
JOIN igre       i ON i.id = m.igre_id
ORDER BY s.prezime, s.ime, i.godina, d.sport, d.naziv;

\copy (SELECT * FROM izvoz_csv) TO 'olimpijske_igre.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')

\echo 'Izvoz gotov: olimpijske_igre.csv'
