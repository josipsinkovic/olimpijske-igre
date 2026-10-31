# Osvajači olimpijskih medalja

Otvoreni skup podataka o osvajačima medalja na olimpijskim igrama od 2014. do 2026. godine. Obuhvaća troje ljetnih igara (Rio de Janeiro 2016, Tokio 2020, Pariz 2024) i troje zimskih igara (Soči 2014, Peking 2022, Milano Cortina 2026). Za svakog sportaša navedeni su osobni podaci i popis medalja koje je osvojio u disciplinama uključenima u skup. Uz poznate svjetske sportaše u skupu su i hrvatski osvajači medalja: braća Sinković, Donna Vekić, Barbara Matić i Sandra Elkasević.

Skup je izrađen u sklopu laboratorijske vježbe iz predmeta Otvoreno računarstvo (FER, 2026./2027.).

## Metapodaci

| Metapodatak | Vrijednost |
|---|---|
| Naziv skupa | Osvajači olimpijskih medalja (`olimpijske_igre`) |
| Autor | Josip Sinković |
| Verzija | 1.0 |
| Datum objave | 31. 10. 2026. |
| Licencija | Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0) |
| Jezik podataka | hrvatski |
| Broj sportaša (instanci) | 15 |
| Broj medalja | 44 (32 zlatne, 6 srebrnih, 6 brončanih) |
| Broj igara | 6 (3 ljetne, 3 zimske) |
| Broj sportova / disciplina | 8 / 21 |
| Formati | CSV, JSON, SQL (dump PostgreSQL baze) |
| Kodna stranica | UTF-8 |
| Baza podataka | PostgreSQL |

## Licencija

Skup podataka objavljen je pod licencijom [Creative Commons Imenovanje 4.0 međunarodna (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.hr). Podatke smijete slobodno dijeliti, prilagođavati i koristiti u bilo koje svrhe, uključujući komercijalne, uz uvjet da navedete autora i izvor. Puni tekst licencije nalazi se u datoteci [LICENSE](LICENSE).

## Opis atributa

Skup sadrži vezu roditelj–dijete: jedan **sportaš** (roditelj) može imati više **medalja** (djeca).

### CSV (`olimpijske_igre.csv`)

Svaki redak predstavlja jednu medalju. Podaci o sportašu ponavljaju se u svakom retku koji se odnosi na njegove medalje.

| Stupac | Tip | Opis |
|---|---|---|
| `sportas_id` | cijeli broj | Jedinstveni identifikator sportaša |
| `ime` | tekst | Ime sportaša |
| `prezime` | tekst | Prezime sportaša |
| `datum_rodenja` | datum (GGGG-MM-DD) | Datum rođenja sportaša |
| `spol` | tekst (`M` / `Ž`) | Spol sportaša |
| `drzava` | tekst | Država koju sportaš predstavlja |
| `igre_godina` | cijeli broj | Godina u kojoj su održane olimpijske igre |
| `igre_sezona` | tekst (`ljetne` / `zimske`) | Ljetne ili zimske igre |
| `igre_grad` | tekst | Grad domaćin igara |
| `sport` | tekst | Sport (npr. Atletika, Alpsko skijanje) |
| `disciplina` | tekst | Disciplina unutar sporta (npr. Skok s motkom, Slalom) |
| `medalja` | tekst (`zlato` / `srebro` / `bronca`) | Vrsta osvojene medalje |

### JSON (`olimpijske_igre.json`)

Polje objekata u kojem svaki objekt predstavlja jednog sportaša. Sportaš ima ugniježđeno polje `medalje`, a svaka medalja ima ugniježđeni objekt `igre`.

| Ključ | Tip | Opis |
|---|---|---|
| `id` | broj | Jedinstveni identifikator sportaša |
| `ime` | string | Ime sportaša |
| `prezime` | string | Prezime sportaša |
| `datum_rodenja` | string (GGGG-MM-DD) | Datum rođenja sportaša |
| `spol` | string (`M` / `Ž`) | Spol sportaša |
| `drzava` | string | Država koju sportaš predstavlja |
| `medalje` | polje objekata | Popis medalja sportaša |
| `medalje[].vrsta` | string | Vrsta medalje (`zlato`, `srebro`, `bronca`) |
| `medalje[].sport` | string | Sport |
| `medalje[].disciplina` | string | Disciplina |
| `medalje[].igre.godina` | broj | Godina održavanja igara |
| `medalje[].igre.sezona` | string | `ljetne` ili `zimske` |
| `medalje[].igre.grad` | string | Grad domaćin |

Primjer jednog objekta (skraćeno):

```json
{
  "id": 6,
  "ime": "Valent",
  "prezime": "Sinković",
  "datum_rodenja": "1988-08-02",
  "spol": "M",
  "drzava": "Hrvatska",
  "medalje": [
    {
      "vrsta": "zlato",
      "sport": "Veslanje",
      "disciplina": "Dvojac na pariće",
      "igre": { "godina": 2016, "sezona": "ljetne", "grad": "Rio de Janeiro" }
    },
    ...
  ]
}
```

## Model baze podataka

Podaci su spremljeni u normaliziranu PostgreSQL bazu s četiri tablice:

- **`igre`** (`id`, `godina`, `grad`, `sezona`): olimpijske igre. Par (godina, sezona) je jedinstven.
- **`discipline`** (`id`, `sport`, `naziv`): sportske discipline. Par (sport, naziv) je jedinstven.
- **`sportasi`** (`id`, `ime`, `prezime`, `datum_rodenja`, `spol`, `drzava`): sportaši.
- **`medalje`** (`id`, `sportas_id`, `disciplina_id`, `igre_id`, `vrsta`): povezuje sportaša, disciplinu i igre. Sportaš u istoj disciplini na istim igrama može imati najviše jednu medalju.

## Napomene

- Skup ne sadrži sve medalje navedenih sportaša, nego samo medalje osvojene u 21 disciplini uključenoj u skup i na šest obuhvaćenih igara.
- Igre u Tokiju vode se kao igre 2020. godine, iako su zbog pandemije bolesti COVID-19 održane 2021.
- Spol nije dio naziva discipline jer je atribut sportaša. Disciplina „Veleslalom” tako obuhvaća i mušku i žensku utrku.
- Kod ekipnih disciplina (štafeta, dvojac, ekipna kombinacija) navedeni su samo sportaši uključeni u skup, a ne svi članovi ekipe.
