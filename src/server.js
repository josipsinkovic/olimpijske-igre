import { STATUS_CODES } from 'node:http';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import express from 'express';
import { query } from './db.js';
import { ATRIBUTI, dohvatiMedalje, dohvatiSportase, uCsv, uJson } from './medalje.js';

const KORIJEN = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const PORT = Number(process.env.PORT) || 3000;

// Datoteke skupa podataka koje se poslužuju izravno s datotečnog sustava.
const DATOTEKE = [
    'olimpijske_igre.csv',
    'olimpijske_igre.json',
    'olimpijske_igre.sql',
    'schema.json'
];

const app = express();

app.use(express.static(path.join(KORIJEN, 'public')));

for (const datoteka of DATOTEKE) {
    app.get('/' + datoteka, (req, res) => {
        res.sendFile(path.join(KORIJEN, datoteka));
    });
}

// Biblioteka DataTables za klijentsku tablicu.
app.use('/vendor/datatables.net', express.static(path.join(KORIJEN, 'node_modules/datatables.net/js')));
app.use('/vendor/datatables.net-dt', express.static(path.join(KORIJEN, 'node_modules/datatables.net-dt')));

class GreskaZahtjeva extends Error {
    constructor(status, poruka) {
        super(poruka);
        this.status = status;
    }
}

// Čita filtar iz parametara ?tekst=...&atribut=...; prazan atribut znači pretragu po svim atributima.
function procitajFiltar(req) {
    const tekst = typeof req.query.tekst === 'string' ? req.query.tekst.trim() : '';
    const atribut = typeof req.query.atribut === 'string' ? req.query.atribut : '';

    if (atribut && !Object.hasOwn(ATRIBUTI, atribut)) {
        throw new GreskaZahtjeva(400, `Nepoznat atribut za filtriranje: "${atribut}"`);
    }
    return { tekst, atribut };
}

app.get('/api/medalje', async (req, res) => {
    const medalje = await dohvatiMedalje(procitajFiltar(req));
    res.json({
        status: 'OK',
        message: `Dohvaćeno medalja: ${medalje.length}`,
        response: medalje
    });
});

// Preuzimanje trenutno filtriranog prikaza: ?format=csv|json uz iste parametre filtra.
app.get('/api/medalje/izvoz', async (req, res) => {
    const filtar = procitajFiltar(req);
    const format = req.query.format;

    if (format === 'csv') {
        const medalje = await dohvatiMedalje(filtar);
        res.attachment('olimpijske_igre_filtrirano.csv');
        res.type('text/csv; charset=utf-8').send(uCsv(medalje));
    } else if (format === 'json') {
        const sportasi = await dohvatiSportase(filtar);
        res.attachment('olimpijske_igre_filtrirano.json');
        res.type('application/json; charset=utf-8').send(uJson(sportasi));
    } else {
        throw new GreskaZahtjeva(400, 'Parametar format mora biti "csv" ili "json"');
    }
});

app.use('/api', (req, res) => {
    res.status(404).json({
        status: 'Not Found',
        message: `Krajnja točka ${req.method} ${req.originalUrl} ne postoji`,
        response: null
    });
});

app.use((req, res) => {
    res.status(404).type('text/plain; charset=utf-8').send('Stranica ne postoji.');
});

// Rukovanje pogreškama u ostalim middlewareima.
app.use((err, req, res, next) => {
    let status = 500;
    let poruka = 'Greška na poslužitelju';

    if (err instanceof GreskaZahtjeva) {
        status = err.status;
        poruka = err.message;
    } else if (err.status >= 400 && err.status < 500) {
        status = err.status;
        poruka = 'Neispravan zahtjev';
    } else {
        console.error(err);
    }

    res.status(status).json({
        status: STATUS_CODES[status],
        message: poruka,
        response: null
    });
});

try {
    await query('SELECT 1');
} catch (err) {
    console.error('Spajanje na bazu nije uspjelo: ' + err.message);
    process.exit(1);
}

app.listen(PORT, () => {
    console.log(`Poslužitelj radi na http://localhost:${PORT}`);
});
