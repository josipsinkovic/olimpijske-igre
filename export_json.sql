\set ON_ERROR_STOP on
\encoding UTF8
\pset pager off

CREATE FUNCTION pg_temp.json_lijepo(j json, razina integer DEFAULT 0)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE
    uvlaka   text := repeat('  ', razina + 1);
    kraj     text := repeat('  ', razina);
    dijelovi text[];
BEGIN
    CASE json_typeof(j)
        WHEN 'object' THEN
            SELECT array_agg(uvlaka || to_json(t.kljuc)::text || ': '
                             || pg_temp.json_lijepo(t.vrijednost, razina + 1)
                             ORDER BY t.rb)
              INTO dijelovi
              FROM json_each(j) WITH ORDINALITY AS t(kljuc, vrijednost, rb);
            IF dijelovi IS NULL THEN RETURN '{}'; END IF;
            RETURN '{' || E'\n' || array_to_string(dijelovi, E',\n') || E'\n' || kraj || '}';
        WHEN 'array' THEN
            SELECT array_agg(uvlaka || pg_temp.json_lijepo(t.vrijednost, razina + 1)
                             ORDER BY t.rb)
              INTO dijelovi
              FROM json_array_elements(j) WITH ORDINALITY AS t(vrijednost, rb);
            IF dijelovi IS NULL THEN RETURN '[]'; END IF;
            RETURN '[' || E'\n' || array_to_string(dijelovi, E',\n') || E'\n' || kraj || ']';
        ELSE
            RETURN j::text;
    END CASE;
END $$;

\pset format unaligned
\pset tuples_only on
\o olimpijske_igre.json

SELECT pg_temp.json_lijepo(
    json_agg(
        json_build_object(
            'id',            s.id,
            'ime',           s.ime,
            'prezime',       s.prezime,
            'datum_rodenja', s.datum_rodenja,
            'spol',          s.spol,
            'drzava',        s.drzava,
            'medalje', (
                SELECT json_agg(
                           json_build_object(
                               'vrsta',      m.vrsta,
                               'sport',      d.sport,
                               'disciplina', d.naziv,
                               'igre', json_build_object(
                                   'godina', i.godina,
                                   'sezona', i.sezona,
                                   'grad',   i.grad
                               )
                           )
                           ORDER BY i.godina, d.sport, d.naziv
                       )
                FROM medalje m
                JOIN discipline d ON d.id = m.disciplina_id
                JOIN igre       i ON i.id = m.igre_id
                WHERE m.sportas_id = s.id
            )
        )
        ORDER BY s.prezime, s.ime
    )
)
FROM sportasi s;

\o
\pset format aligned
\pset tuples_only off

\echo 'Izvoz gotov: olimpijske_igre.json'
