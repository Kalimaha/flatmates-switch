--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: feature_toggle_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feature_toggle_rules (
    id bigint NOT NULL,
    feature_toggle_id bigint NOT NULL,
    attribute_name character varying(255),
    attribute_value double precision,
    attribute_operation character varying(255),
    threshold double precision,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(255) DEFAULT 'simple'::character varying NOT NULL
);


--
-- Name: feature_toggle_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feature_toggle_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feature_toggle_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feature_toggle_rules_id_seq OWNED BY public.feature_toggle_rules.id;


--
-- Name: feature_toggles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feature_toggles (
    id bigint NOT NULL,
    external_id character varying(255),
    env character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(255),
    label character varying(255),
    active boolean
);


--
-- Name: feature_toggles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feature_toggles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feature_toggles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feature_toggles_id_seq OWNED BY public.feature_toggles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: switches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.switches (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    feature_toggle_name character varying(255),
    value boolean,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: switches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.switches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: switches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.switches_id_seq OWNED BY public.switches.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    external_id character varying(255),
    source character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: feature_toggle_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_toggle_rules ALTER COLUMN id SET DEFAULT nextval('public.feature_toggle_rules_id_seq'::regclass);


--
-- Name: feature_toggles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_toggles ALTER COLUMN id SET DEFAULT nextval('public.feature_toggles_id_seq'::regclass);


--
-- Name: switches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.switches ALTER COLUMN id SET DEFAULT nextval('public.switches_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: feature_toggle_rules feature_toggle_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_toggle_rules
    ADD CONSTRAINT feature_toggle_rules_pkey PRIMARY KEY (id);


--
-- Name: feature_toggles feature_toggles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_toggles
    ADD CONSTRAINT feature_toggles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: switches switches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.switches
    ADD CONSTRAINT switches_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: feature_toggle_rules feature_toggle_rules_feature_toggle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_toggle_rules
    ADD CONSTRAINT feature_toggle_rules_feature_toggle_id_fkey FOREIGN KEY (feature_toggle_id) REFERENCES public.feature_toggles(id);


--
-- Name: switches switches_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.switches
    ADD CONSTRAINT switches_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

<<<<<<< HEAD
INSERT INTO public."schema_migrations" (version) VALUES (20181030055927), (20181113215946), (20181113223921), (20181114022129), (20181115020724), (20181115222609);
=======
>>>>>>> Switch model
