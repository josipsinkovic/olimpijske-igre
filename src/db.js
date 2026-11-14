import path from 'node:path';
import { fileURLToPath } from 'node:url';
import dotenv from 'dotenv';
import pg from 'pg';

// Postavke spajanja (PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE) čitaju se iz .env.
dotenv.config({
    path: path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '.env'),
    quiet: true
});

// Tip DATE vraća se kao tekst GGGG-MM-DD, kao u izvozu iz baze, a ne kao JS Date
// (koji bi zbog vremenske zone mogao pomaknuti datum za jedan dan).
pg.types.setTypeParser(pg.types.builtins.DATE, (vrijednost) => vrijednost);

const pool = new pg.Pool({
    max: 10,
    idleTimeoutMillis: 30000
});

pool.on('error', (err) => {
    console.error('Neočekivana greška u konekciji s bazom: ' + err.message);
});

export function query(tekst, parametri) {
    return pool.query(tekst, parametri);
}

export default pool;
