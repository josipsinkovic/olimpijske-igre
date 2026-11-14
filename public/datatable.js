import DataTable from 'datatables.net-dt';

const STUPCI = [
    { data: 'sportas_id',    title: 'ID' },
    { data: 'ime',           title: 'Ime' },
    { data: 'prezime',       title: 'Prezime' },
    { data: 'datum_rodenja', title: 'Datum rođenja' },
    { data: 'spol',          title: 'Spol' },
    { data: 'drzava',        title: 'Država' },
    { data: 'igre_godina',   title: 'Godina' },
    { data: 'igre_sezona',   title: 'Sezona' },
    { data: 'igre_grad',     title: 'Grad' },
    { data: 'sport',         title: 'Sport' },
    { data: 'disciplina',    title: 'Disciplina' },
    { data: 'medalja',       title: 'Medalja' }
];

const obrazac = document.getElementById('filtar');
const poruka = document.getElementById('poruka');
const preuzmiCsv = document.getElementById('preuzmi-csv');
const preuzmiJson = document.getElementById('preuzmi-json');

const tablica = new DataTable('#tablica', {
    columns: STUPCI,
    columnDefs: [{ targets: '_all', className: 'dt-left' }],
    data: [],
    searching: false,
    order: [],
    pageLength: 25,
    language: {
        emptyTable: 'Nema zapisa.',
        zeroRecords: 'Nema zapisa koji odgovaraju filtru.',
        info: 'Prikazani zapisi _START_-_END_ od ukupno _TOTAL_',
        infoEmpty: 'Nema zapisa',
        lengthMenu: 'Prikaži _MENU_ zapisa po stranici',
        loadingRecords: 'Učitavanje…',
        paginate: { first: '<<', previous: '<', next: '>', last: '>>' }
    }
});

function parametriFiltra() {
    const parametri = new URLSearchParams();
    const tekst = obrazac.tekst.value.trim();
    if (tekst) {
        parametri.set('tekst', tekst);
    }
    if (obrazac.atribut.value) {
        parametri.set('atribut', obrazac.atribut.value);
    }
    return parametri;
}

// Dohvaća medalje s poslužitelja asinkrono i osvježava tablicu i poveznice za preuzimanje.
async function osvjezi() {
    const parametri = parametriFiltra();

    try {
        const odgovor = await fetch('/api/medalje?' + parametri);
        const tijelo = await odgovor.json();
        if (!odgovor.ok) {
            throw new Error(tijelo.message);
        }

        tablica.clear().rows.add(tijelo.response).draw();
        poruka.textContent = `Pronađeno medalja: ${tijelo.response.length}`;
    } catch (err) {
        tablica.clear().draw();
        poruka.textContent = 'Dohvaćanje podataka nije uspjelo: ' + err.message;
    }

    for (const [poveznica, format] of [[preuzmiCsv, 'csv'], [preuzmiJson, 'json']]) {
        const izvoz = new URLSearchParams(parametri);
        izvoz.set('format', format);
        poveznica.href = '/api/medalje/izvoz?' + izvoz;
    }
}

obrazac.addEventListener('submit', (e) => {
    e.preventDefault();
    osvjezi();
});

obrazac.addEventListener('reset', () => {
    setTimeout(osvjezi);
});

osvjezi();
