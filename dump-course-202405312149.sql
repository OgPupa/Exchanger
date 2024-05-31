--
-- PostgreSQL database cluster dump
--

-- Started on 2024-05-31 21:49:37

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE "Ilya";
ALTER ROLE "Ilya" WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS CONNECTION LIMIT 2;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-05-31 21:49:37

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2024-05-31 21:49:37

--
-- PostgreSQL database dump complete
--

--
-- Database "Exchanger" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-05-31 21:49:37

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4831 (class 1262 OID 16396)
-- Name: Exchanger; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Exchanger" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE "Exchanger" OWNER TO postgres;

\connect "Exchanger"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4832 (class 0 OID 0)
-- Name: Exchanger; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE "Exchanger" CONNECTION LIMIT = 10;


\connect "Exchanger"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2024-05-31 21:49:37

--
-- PostgreSQL database dump complete
--

--
-- Database "Podcast_Basement" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-05-31 21:49:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4851 (class 1262 OID 16416)
-- Name: Podcast_Basement; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Podcast_Basement" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE "Podcast_Basement" OWNER TO postgres;

\connect "Podcast_Basement"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4852 (class 0 OID 0)
-- Name: Podcast_Basement; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE "Podcast_Basement" CONNECTION LIMIT = 2;


\connect "Podcast_Basement"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- TOC entry 218 (class 1259 OID 16436)
-- Name: lk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lk (
    id integer NOT NULL,
    user_name character varying(50),
    user_surname character varying(50),
    user_middlename character varying(50),
    user_email character varying(256),
    male character(7),
    date_of_birth date,
    passport_data character varying(20),
    user_password character varying(256)
);


ALTER TABLE public.lk OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16435)
-- Name: lk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lk_id_seq OWNER TO postgres;

--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 217
-- Name: lk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lk_id_seq OWNED BY public.lk.id;


--
-- TOC entry 216 (class 1259 OID 16427)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_email character varying(255),
    user_password character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16426)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4694 (class 2604 OID 16439)
-- Name: lk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lk ALTER COLUMN id SET DEFAULT nextval('public.lk_id_seq'::regclass);


--
-- TOC entry 4693 (class 2604 OID 16430)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4845 (class 0 OID 16436)
-- Dependencies: 218
-- Data for Name: lk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lk (id, user_name, user_surname, user_middlename, user_email, male, date_of_birth, passport_data, user_password) FROM stdin;
\.


--
-- TOC entry 4843 (class 0 OID 16427)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, user_email, user_password) FROM stdin;
1	qwerty@mail.com	12345
\.


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 217
-- Name: lk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lk_id_seq', 1, false);


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- TOC entry 4698 (class 2606 OID 16443)
-- Name: lk lk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lk
    ADD CONSTRAINT lk_pkey PRIMARY KEY (id);


--
-- TOC entry 4696 (class 2606 OID 16434)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


-- Completed on 2024-05-31 21:49:38

--
-- PostgreSQL database dump complete
--

--
-- Database "course" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-05-31 21:49:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4854 (class 1262 OID 16407)
-- Name: course; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE course WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE course OWNER TO postgres;

\connect course

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- TOC entry 216 (class 1259 OID 16409)
-- Name: convert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.convert (
    id integer NOT NULL,
    conv_time timestamp without time zone,
    amount_in double precision,
    amount_out double precision,
    currency_in character(3),
    currency_out character(3),
    user_email character varying(255),
    lk_id integer
);


ALTER TABLE public.convert OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16408)
-- Name: convert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.convert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.convert_id_seq OWNER TO postgres;

--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 215
-- Name: convert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.convert_id_seq OWNED BY public.convert.id;


--
-- TOC entry 218 (class 1259 OID 16445)
-- Name: lk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lk (
    id integer NOT NULL,
    user_name character varying(50),
    user_surname character varying(50),
    user_middlename character varying(50),
    user_email character varying(256),
    male character(7),
    date_of_birth date,
    passport_data character varying(20),
    user_password character varying(256)
);


ALTER TABLE public.lk OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16444)
-- Name: lk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lk_id_seq OWNER TO postgres;

--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 217
-- Name: lk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lk_id_seq OWNED BY public.lk.id;


--
-- TOC entry 4693 (class 2604 OID 16412)
-- Name: convert id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convert ALTER COLUMN id SET DEFAULT nextval('public.convert_id_seq'::regclass);


--
-- TOC entry 4694 (class 2604 OID 16448)
-- Name: lk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lk ALTER COLUMN id SET DEFAULT nextval('public.lk_id_seq'::regclass);


--
-- TOC entry 4846 (class 0 OID 16409)
-- Dependencies: 216
-- Data for Name: convert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.convert (id, conv_time, amount_in, amount_out, currency_in, currency_out, user_email, lk_id) FROM stdin;
1	2024-05-24 13:28:40.715963	700	6.1	RUB	GBP	\N	\N
2	2024-05-24 13:37:30.251283	500	5.54	RUB	USD	\N	\N
3	2024-05-24 13:38:06.135682	500.54	5.55	RUB	USD	\N	\N
4	2024-05-24 14:06:25.191926	900	9.97	RUB	USD	\N	\N
5	2024-05-24 14:11:25.369658	600.89	10.44	RUB	JPY	\N	\N
6	2024-05-24 14:13:19.704006	600	6.13	RUB	EUR	\N	\N
7	2024-05-24 14:14:14.059466	4	0.04	RUB	USD	\N	\N
8	2024-05-24 14:16:49.535748	500	5.11	RUB	EUR	\N	\N
9	2024-05-24 14:36:37.235976	7	0.08	RUB	USD	\N	\N
10	2024-05-24 14:51:51.879027	569.77	45.85	RUB	CNY	\N	\N
11	2024-05-24 16:39:55.199344	1000	17.37	RUB	JPY	\N	\N
12	2024-05-24 20:03:18.274471	300	3.32	RUB	USD	\N	\N
13	2024-05-31 02:48:50.497974	700	6.13	RUB	GBP	\N	\N
15	2024-05-31 19:28:47.778122	500	5.54	RUB	USD	anton@anton.com	0
16	2024-05-31 19:51:49.862789	600	10.42	RUB	JPY	ilya@mail.com	1
17	2024-05-31 19:52:38.1786	1000	10.23	RUB	EUR	anton@anton.com	2
18	2024-05-31 20:28:33.834415	100	1.11	RUB	USD	ilya@mail.com	1
19	2024-05-31 20:40:17.824666	153	1.7	RUB	USD	ilya@mail.com	1
20	2024-05-31 20:51:39.893997	600	6.65	RUB	USD	ilya@mail.com	1
21	2024-05-31 21:45:08.334246	500	5.11	RUB	EUR	grisha@mail.com	3
\.


--
-- TOC entry 4848 (class 0 OID 16445)
-- Dependencies: 218
-- Data for Name: lk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lk (id, user_name, user_surname, user_middlename, user_email, male, date_of_birth, passport_data, user_password) FROM stdin;
1	Илья	Ильин	Ильич	ilya@mail.com	male   	1999-01-01	1111111111	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
2	Антон	Антонов	Антонович	anton@anton.com	male   	2002-02-02	2222222222	9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0
3	Григорий	Григорьев	Григорьевич	grisha@mail.com	male   	1993-07-08	0000000000	ce770667e5f9b0d8f55367bb79419689d90c48451bb33f079f3a9a72ae132de8
\.


--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 215
-- Name: convert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.convert_id_seq', 21, true);


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 217
-- Name: lk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lk_id_seq', 3, true);


--
-- TOC entry 4696 (class 2606 OID 16414)
-- Name: convert convert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convert
    ADD CONSTRAINT convert_pkey PRIMARY KEY (id);


--
-- TOC entry 4698 (class 2606 OID 16452)
-- Name: lk lk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lk
    ADD CONSTRAINT lk_pkey PRIMARY KEY (id);


--
-- TOC entry 4700 (class 2606 OID 16454)
-- Name: lk unique_user_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lk
    ADD CONSTRAINT unique_user_email UNIQUE (user_email);


--
-- TOC entry 4701 (class 2606 OID 16455)
-- Name: convert fk_useremail; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convert
    ADD CONSTRAINT fk_useremail FOREIGN KEY (user_email) REFERENCES public.lk(user_email) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-05-31 21:49:38

--
-- PostgreSQL database dump complete
--

-- Completed on 2024-05-31 21:49:38

--
-- PostgreSQL database cluster dump complete
--

