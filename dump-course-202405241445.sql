--
-- PostgreSQL database cluster dump
--

-- Started on 2024-05-24 14:45:38

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

-- Started on 2024-05-24 14:45:38

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

-- Completed on 2024-05-24 14:45:38

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

-- Started on 2024-05-24 14:45:38

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

-- Completed on 2024-05-24 14:45:38

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

-- Started on 2024-05-24 14:45:38

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
-- TOC entry 4841 (class 1262 OID 16407)
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
    currency_out character(3)
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
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 215
-- Name: convert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.convert_id_seq OWNED BY public.convert.id;


--
-- TOC entry 4688 (class 2604 OID 16412)
-- Name: convert id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convert ALTER COLUMN id SET DEFAULT nextval('public.convert_id_seq'::regclass);


--
-- TOC entry 4835 (class 0 OID 16409)
-- Dependencies: 216
-- Data for Name: convert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.convert (id, conv_time, amount_in, amount_out, currency_in, currency_out) FROM stdin;
1	2024-05-24 13:28:40.715963	700	6.1	RUB	GBP
2	2024-05-24 13:37:30.251283	500	5.54	RUB	USD
3	2024-05-24 13:38:06.135682	500.54	5.55	RUB	USD
4	2024-05-24 14:06:25.191926	900	9.97	RUB	USD
5	2024-05-24 14:11:25.369658	600.89	10.44	RUB	JPY
6	2024-05-24 14:13:19.704006	600	6.13	RUB	EUR
7	2024-05-24 14:14:14.059466	4	0.04	RUB	USD
8	2024-05-24 14:16:49.535748	500	5.11	RUB	EUR
9	2024-05-24 14:36:37.235976	7	0.08	RUB	USD
\.


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 215
-- Name: convert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.convert_id_seq', 9, true);


--
-- TOC entry 4690 (class 2606 OID 16414)
-- Name: convert convert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.convert
    ADD CONSTRAINT convert_pkey PRIMARY KEY (id);


-- Completed on 2024-05-24 14:45:38

--
-- PostgreSQL database dump complete
--

-- Completed on 2024-05-24 14:45:38

--
-- PostgreSQL database cluster dump complete
--

