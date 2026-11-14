import { stringify } from 'csv-stringify/sync';
import { query } from './db.js';

export const ATRIBUTI = {
    sportas_id:    's.id::text',
    ime:           's.ime',
    prezime:       's.prezime',
    datum_rodenja: 's.datum_rodenja::text',
    spol:          's.spol',
    drzava:        's.drzava',
    igre_godina:   'i.godina::text',
    igre_sezona:   'i.sezona',
    igre_grad:     'i.grad',
    sport:         'd.sport',
    disciplina:    'd.naziv',
    medalja:       'm.vrsta'
};

const IZVOR = `
FROM sportasi s
JOIN medalje    m ON m.sportas_id = s.id
JOIN discipline d ON d.id = m.disciplina_id
JOIN igre       i ON i.id = m.igre_id`;

const MAKS_RIJECI = 10;

function podijeliNaRijeci(tekst) {
    const rijeci = [];
    for (const dio of tekst.split(' ')) {
        if (dio === '') {
            continue; // više razmaka zaredom
        }
        rijeci.push(dio);
        if (rijeci.length === MAKS_RIJECI) {
            break;
        }
    }
    return rijeci;
}

// U uzorku za ILIKE znak % znači "bilo koji niz znakova", a _ "bilo koji jedan znak".
// Da bi se ti znakovi u riječi tražili doslovno, ispred njih se stavlja \.
function pripremiZaIlike(rijec) {
    return rijec
        .replaceAll('\\', '\\\\')
        .replaceAll('%', '\\%')
        .replaceAll('_', '\\_');
}

function napraviUvjet(filtar) {
    if (!filtar.tekst) {
        return { sql: 'TRUE', parametri: [] };
    }

    const rijeci = podijeliNaRijeci(filtar.tekst);
    if (rijeci.length === 0) {
        return { sql: 'TRUE', parametri: [] };
    }

    let atributi;
    if (filtar.atribut) {
        atributi = [filtar.atribut];
    } else {
        atributi = Object.keys(ATRIBUTI);
    }

    const parametri = [];
    const uvjetiZaRijeci = [];

    for (const rijec of rijeci) {
        // Svaka riječ je jedan parametar: prva je $1, druga $2 itd.
        parametri.push(pripremiZaIlike(rijec));
        const oznaka = '$' + parametri.length;

        const usporedbe = [];
        for (const atribut of atributi) {
            if (atribut === 'sportas_id') {
                usporedbe.push(`${ATRIBUTI[atribut]} = ${oznaka}`);
            } else {
                usporedbe.push(`${ATRIBUTI[atribut]} ILIKE ('%' || ${oznaka} || '%')`);
            }
        }

        uvjetiZaRijeci.push('(' + usporedbe.join(' OR ') + ')');
    }

    return { sql: uvjetiZaRijeci.join(' AND '), parametri: parametri };
}

// Zapisi s istim stupcima i poretkom kao olimpijske_igre.csv.
export async function dohvatiMedalje(filtar = {}) {
    const uvjet = napraviUvjet(filtar);
    const rezultat = await query(`
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
        ${IZVOR}
        WHERE ${uvjet.sql}
        ORDER BY s.prezime, s.ime, i.godina, d.sport, d.naziv`, uvjet.parametri);
    return rezultat.rows;
}

// U istom obliku kao i olimpijske_igre.json.
export async function dohvatiSportase(filtar = {}) {
    const uvjet = napraviUvjet(filtar);
    const rezultat = await query(`
        SELECT s.id,
               s.ime,
               s.prezime,
               s.datum_rodenja,
               s.spol,
               s.drzava,
               json_agg(
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
               ) AS medalje
        ${IZVOR}
        WHERE ${uvjet.sql}
        GROUP BY s.id
        ORDER BY s.prezime, s.ime`, uvjet.parametri);
    return rezultat.rows;
}

// CSV u istom zapisu kao \copy ... (FORMAT csv, HEADER true), stupci redom kao u ATRIBUTI.
export function uCsv(medalje) {
    return stringify(medalje, {
        header: true,
        columns: Object.keys(ATRIBUTI)
    });
}

export function uJson(sportasi) {
    return JSON.stringify(sportasi, null, 2) + '\n';
}
