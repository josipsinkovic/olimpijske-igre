DROP TABLE IF EXISTS medalje;
DROP TABLE IF EXISTS sportasi;
DROP TABLE IF EXISTS discipline;
DROP TABLE IF EXISTS igre;

CREATE TABLE igre (
    id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    godina INTEGER NOT NULL,
    grad   TEXT NOT NULL,
    sezona TEXT NOT NULL CHECK (sezona IN ('ljetne', 'zimske')),
    UNIQUE (godina, sezona)
);

CREATE TABLE discipline (
    id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sport TEXT NOT NULL,
    naziv TEXT NOT NULL,
    UNIQUE (sport, naziv)
);

CREATE TABLE sportasi (
    id             INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ime            TEXT NOT NULL,
    prezime        TEXT NOT NULL,
    datum_rodenja  DATE NOT NULL,
    spol           CHAR(1) NOT NULL CHECK (spol IN ('M', 'Ž')),
    drzava         TEXT NOT NULL
);

CREATE TABLE medalje (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sportas_id    INTEGER NOT NULL REFERENCES sportasi(id) ON DELETE CASCADE,
    disciplina_id INTEGER NOT NULL REFERENCES discipline(id),
    igre_id       INTEGER NOT NULL REFERENCES igre(id),
    vrsta         TEXT NOT NULL CHECK (vrsta IN ('zlato', 'srebro', 'bronca')),
    UNIQUE (sportas_id, disciplina_id, igre_id)
);
