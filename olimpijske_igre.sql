--
-- PostgreSQL database dump
--

\restrict fQWRqAzfc2kJ10h2LYR7Pp9oyvTyWRs3OHaj1fXAuPJZQ1rb8Cmjji4idu0Wcc6

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-31 17:53:44 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 16910)
-- Name: discipline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discipline (
    id integer NOT NULL,
    sport text NOT NULL,
    naziv text NOT NULL
);


ALTER TABLE public.discipline OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16909)
-- Name: discipline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.discipline ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.discipline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16895)
-- Name: igre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.igre (
    id integer NOT NULL,
    godina integer NOT NULL,
    grad text NOT NULL,
    sezona text NOT NULL,
    CONSTRAINT igre_sezona_check CHECK ((sezona = ANY (ARRAY['ljetne'::text, 'zimske'::text])))
);


ALTER TABLE public.igre OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16894)
-- Name: igre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.igre ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.igre_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16938)
-- Name: medalje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medalje (
    id integer NOT NULL,
    sportas_id integer NOT NULL,
    disciplina_id integer NOT NULL,
    igre_id integer NOT NULL,
    vrsta text NOT NULL,
    CONSTRAINT medalje_vrsta_check CHECK ((vrsta = ANY (ARRAY['zlato'::text, 'srebro'::text, 'bronca'::text])))
);


ALTER TABLE public.medalje OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16937)
-- Name: medalje_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.medalje ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.medalje_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16923)
-- Name: sportasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sportasi (
    id integer NOT NULL,
    ime text NOT NULL,
    prezime text NOT NULL,
    datum_rodenja date NOT NULL,
    spol character(1) NOT NULL,
    drzava text NOT NULL,
    CONSTRAINT sportasi_spol_check CHECK ((spol = ANY (ARRAY['M'::bpchar, 'Ž'::bpchar])))
);


ALTER TABLE public.sportasi OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16922)
-- Name: sportasi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sportasi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sportasi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3519 (class 0 OID 16910)
-- Dependencies: 226
-- Data for Name: discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline (id, sport, naziv) FROM stdin;
1	Gimnastika	Višeboj
2	Gimnastika	Preskok
3	Gimnastika	Parter
4	Gimnastika	Greda
5	Atletika	Skok s motkom
6	Atletika	1500 m
7	Atletika	5000 m
8	Atletika	Bacanje diska
9	Tenis	Pojedinačno
10	Veslanje	Dvojac na pariće
11	Veslanje	Dvojac bez kormilara
12	Judo	do 70 kg
13	Skijaško trčanje	Sprint
14	Skijaško trčanje	Skijatlon
15	Skijaško trčanje	Štafeta
16	Alpsko skijanje	Spust
17	Alpsko skijanje	Superveleslalom
18	Alpsko skijanje	Veleslalom
19	Alpsko skijanje	Slalom
20	Alpsko skijanje	Ekipna kombinacija
21	Slobodno skijanje	Halfpipe
\.


--
-- TOC entry 3517 (class 0 OID 16895)
-- Dependencies: 224
-- Data for Name: igre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.igre (id, godina, grad, sezona) FROM stdin;
1	2014	Soči	zimske
2	2016	Rio de Janeiro	ljetne
3	2020	Tokio	ljetne
4	2022	Peking	zimske
5	2024	Pariz	ljetne
6	2026	Milano i Cortina d'Ampezzo	zimske
\.


--
-- TOC entry 3523 (class 0 OID 16938)
-- Dependencies: 230
-- Data for Name: medalje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medalje (id, sportas_id, disciplina_id, igre_id, vrsta) FROM stdin;
1	1	3	5	srebro
2	1	2	5	zlato
3	1	1	5	zlato
4	1	4	3	bronca
5	1	4	2	bronca
6	1	3	2	zlato
7	1	2	2	zlato
8	1	1	2	zlato
9	2	5	5	zlato
10	2	5	3	zlato
11	3	7	5	srebro
12	3	6	5	zlato
13	3	6	3	zlato
14	3	6	2	zlato
15	4	9	5	zlato
16	5	9	5	srebro
17	6	11	5	zlato
18	6	11	3	zlato
19	6	10	2	zlato
20	7	11	5	zlato
21	7	11	3	zlato
22	7	10	2	zlato
23	8	12	5	zlato
24	9	8	5	bronca
25	9	8	2	zlato
26	10	15	6	zlato
27	10	13	6	zlato
28	10	14	6	zlato
29	10	15	4	srebro
30	10	13	4	zlato
31	11	21	6	zlato
32	11	21	4	zlato
33	12	19	6	zlato
34	12	19	1	zlato
35	13	20	6	srebro
36	13	18	6	srebro
37	13	17	6	bronca
38	13	18	4	zlato
39	14	20	6	zlato
40	14	17	6	zlato
41	14	16	6	zlato
42	15	18	4	bronca
43	15	17	4	zlato
44	15	16	1	bronca
\.


--
-- TOC entry 3521 (class 0 OID 16923)
-- Dependencies: 228
-- Data for Name: sportasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sportasi (id, ime, prezime, datum_rodenja, spol, drzava) FROM stdin;
1	Simone	Biles	1997-03-14	Ž	Sjedinjene Američke Države
2	Armand	Duplantis	1999-11-10	M	Švedska
3	Faith	Kipyegon	1994-01-10	Ž	Kenija
4	Novak	Đoković	1987-05-22	M	Srbija
5	Donna	Vekić	1996-06-28	Ž	Hrvatska
6	Valent	Sinković	1988-08-02	M	Hrvatska
7	Martin	Sinković	1989-11-10	M	Hrvatska
8	Barbara	Matić	1994-12-03	Ž	Hrvatska
9	Sandra	Elkasević	1990-06-21	Ž	Hrvatska
10	Johannes Høsflot	Klæbo	1996-10-22	M	Norveška
11	Eileen	Gu	2003-09-03	Ž	Kina
12	Mikaela	Shiffrin	1995-03-13	Ž	Sjedinjene Američke Države
13	Marco	Odermatt	1997-10-08	M	Švicarska
14	Franjo	von Allmen	2001-07-24	M	Švicarska
15	Lara	Gut-Behrami	1991-04-27	Ž	Švicarska
\.


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 225
-- Name: discipline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discipline_id_seq', 21, true);


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 223
-- Name: igre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.igre_id_seq', 6, true);


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 229
-- Name: medalje_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medalje_id_seq', 44, true);


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 227
-- Name: sportasi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sportasi_id_seq', 15, true);


--
-- TOC entry 3357 (class 2606 OID 16919)
-- Name: discipline discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT discipline_pkey PRIMARY KEY (id);


--
-- TOC entry 3359 (class 2606 OID 16921)
-- Name: discipline discipline_sport_naziv_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT discipline_sport_naziv_key UNIQUE (sport, naziv);


--
-- TOC entry 3353 (class 2606 OID 16908)
-- Name: igre igre_godina_sezona_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.igre
    ADD CONSTRAINT igre_godina_sezona_key UNIQUE (godina, sezona);


--
-- TOC entry 3355 (class 2606 OID 16906)
-- Name: igre igre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.igre
    ADD CONSTRAINT igre_pkey PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 16950)
-- Name: medalje medalje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medalje
    ADD CONSTRAINT medalje_pkey PRIMARY KEY (id);


--
-- TOC entry 3365 (class 2606 OID 16952)
-- Name: medalje medalje_sportas_id_disciplina_id_igre_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medalje
    ADD CONSTRAINT medalje_sportas_id_disciplina_id_igre_id_key UNIQUE (sportas_id, disciplina_id, igre_id);


--
-- TOC entry 3361 (class 2606 OID 16936)
-- Name: sportasi sportasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sportasi
    ADD CONSTRAINT sportasi_pkey PRIMARY KEY (id);


--
-- TOC entry 3366 (class 2606 OID 16958)
-- Name: medalje medalje_disciplina_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medalje
    ADD CONSTRAINT medalje_disciplina_id_fkey FOREIGN KEY (disciplina_id) REFERENCES public.discipline(id);


--
-- TOC entry 3367 (class 2606 OID 16963)
-- Name: medalje medalje_igre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medalje
    ADD CONSTRAINT medalje_igre_id_fkey FOREIGN KEY (igre_id) REFERENCES public.igre(id);


--
-- TOC entry 3368 (class 2606 OID 16953)
-- Name: medalje medalje_sportas_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medalje
    ADD CONSTRAINT medalje_sportas_id_fkey FOREIGN KEY (sportas_id) REFERENCES public.sportasi(id) ON DELETE CASCADE;


-- Completed on 2026-10-31 17:53:44 CET

--
-- PostgreSQL database dump complete
--

\unrestrict fQWRqAzfc2kJ10h2LYR7Pp9oyvTyWRs3OHaj1fXAuPJZQ1rb8Cmjji4idu0Wcc6

