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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: agencies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agencies (
    id bigint NOT NULL,
    name character varying,
    api_id integer,
    parent_api_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    short_name character varying
);


--
-- Name: agencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agencies_id_seq OWNED BY public.agencies.id;


--
-- Name: agencies_sorns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agencies_sorns (
    id bigint NOT NULL,
    agency_id bigint,
    sorn_id bigint
);


--
-- Name: agencies_sorns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agencies_sorns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agencies_sorns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agencies_sorns_id_seq OWNED BY public.agencies_sorns.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: sorns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sorns (
    id bigint NOT NULL,
    system_name character varying,
    authority character varying,
    action character varying,
    categories_of_record character varying,
    html_url character varying,
    xml_url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    history character varying,
    purpose character varying,
    routine_uses character varying,
    retention character varying,
    exemptions character varying,
    summary character varying,
    dates character varying,
    addresses character varying,
    further_info character varying,
    supplementary_info character varying,
    security character varying,
    location character varying,
    manager character varying,
    categories_of_individuals character varying,
    source character varying,
    storage character varying,
    retrieval character varying,
    safeguards character varying,
    access character varying,
    contesting character varying,
    notification character varying,
    headers character varying,
    system_number character varying,
    data_source character varying,
    citation character varying,
    agency_names character varying,
    xml xml,
    pdf_url character varying,
    text_url character varying,
    publication_date character varying,
    title character varying,
    action_type character varying,
    agency_names_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(agency_names, ''::character varying))::text)) STORED,
    action_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(action, ''::character varying))::text)) STORED,
    summary_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(summary, ''::character varying))::text)) STORED,
    dates_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(dates, ''::character varying))::text)) STORED,
    addresses_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(addresses, ''::character varying))::text)) STORED,
    further_info_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(further_info, ''::character varying))::text)) STORED,
    supplementary_info_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(supplementary_info, ''::character varying))::text)) STORED,
    system_name_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(system_name, ''::character varying))::text)) STORED,
    system_number_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(system_number, ''::character varying))::text)) STORED,
    security_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(security, ''::character varying))::text)) STORED,
    location_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(location, ''::character varying))::text)) STORED,
    manager_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(manager, ''::character varying))::text)) STORED,
    authority_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(authority, ''::character varying))::text)) STORED,
    purpose_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(purpose, ''::character varying))::text)) STORED,
    categories_of_individuals_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(categories_of_individuals, ''::character varying))::text)) STORED,
    categories_of_record_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(categories_of_record, ''::character varying))::text)) STORED,
    source_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(source, ''::character varying))::text)) STORED,
    routine_uses_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(routine_uses, ''::character varying))::text)) STORED,
    storage_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(storage, ''::character varying))::text)) STORED,
    retrieval_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(retrieval, ''::character varying))::text)) STORED,
    retention_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(retention, ''::character varying))::text)) STORED,
    safeguards_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(safeguards, ''::character varying))::text)) STORED,
    access_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(access, ''::character varying))::text)) STORED,
    contesting_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(contesting, ''::character varying))::text)) STORED,
    notification_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(notification, ''::character varying))::text)) STORED,
    exemptions_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(exemptions, ''::character varying))::text)) STORED,
    history_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(history, ''::character varying))::text)) STORED
);


--
-- Name: full_sorn_searches; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.full_sorn_searches AS
 SELECT sorns.id AS sorn_id,
    ((((((((((((((((((((((((((to_tsvector('english'::regconfig, (COALESCE(sorns.agency_names, ''::character varying))::text) || to_tsvector('english'::regconfig, (COALESCE(sorns.action, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.summary, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.dates, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.addresses, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.further_info, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.supplementary_info, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.system_name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.system_number, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.security, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.location, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.manager, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.authority, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.purpose, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.categories_of_individuals, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.categories_of_record, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.source, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.routine_uses, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.storage, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.retrieval, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.retention, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.safeguards, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.access, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.contesting, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.notification, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.exemptions, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(sorns.history, ''::character varying))::text)) AS full_sorn_tsvector
   FROM public.sorns
  WITH NO DATA;


--
-- Name: good_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp without time zone,
    performed_at timestamp without time zone,
    finished_at timestamp without time zone,
    error text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: mentions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentions (
    sorn_id integer,
    mentioned_sorn_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sorns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sorns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sorns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sorns_id_seq OWNED BY public.sorns.id;


--
-- Name: agencies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agencies ALTER COLUMN id SET DEFAULT nextval('public.agencies_id_seq'::regclass);


--
-- Name: agencies_sorns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agencies_sorns ALTER COLUMN id SET DEFAULT nextval('public.agencies_sorns_id_seq'::regclass);


--
-- Name: sorns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sorns ALTER COLUMN id SET DEFAULT nextval('public.sorns_id_seq'::regclass);


--
-- Name: agencies agencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agencies
    ADD CONSTRAINT agencies_pkey PRIMARY KEY (id);


--
-- Name: agencies_sorns agencies_sorns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agencies_sorns
    ADD CONSTRAINT agencies_sorns_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sorns sorns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sorns
    ADD CONSTRAINT sorns_pkey PRIMARY KEY (id);


--
-- Name: index_agencies_on_api_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agencies_on_api_id ON public.agencies USING btree (api_id);


--
-- Name: index_agencies_on_parent_api_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agencies_on_parent_api_id ON public.agencies USING btree (parent_api_id);


--
-- Name: index_agencies_sorns_on_agency_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agencies_sorns_on_agency_id ON public.agencies_sorns USING btree (agency_id);


--
-- Name: index_agencies_sorns_on_sorn_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agencies_sorns_on_sorn_id ON public.agencies_sorns USING btree (sorn_id);


--
-- Name: index_full_sorn_searches_on_full_sorn_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_full_sorn_searches_on_full_sorn_tsvector ON public.full_sorn_searches USING gin (full_sorn_tsvector);


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON public.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_mentions_on_mentioned_sorn_id_and_sorn_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mentions_on_mentioned_sorn_id_and_sorn_id ON public.mentions USING btree (mentioned_sorn_id, sorn_id);


--
-- Name: index_mentions_on_sorn_id_and_mentioned_sorn_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mentions_on_sorn_id_and_mentioned_sorn_id ON public.mentions USING btree (sorn_id, mentioned_sorn_id);


--
-- Name: index_sorns_on_access_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_access_tsvector ON public.sorns USING gin (access_tsvector);


--
-- Name: index_sorns_on_action_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_action_tsvector ON public.sorns USING gin (action_tsvector);


--
-- Name: index_sorns_on_addresses_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_addresses_tsvector ON public.sorns USING gin (addresses_tsvector);


--
-- Name: index_sorns_on_agency_names_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_agency_names_tsvector ON public.sorns USING gin (agency_names_tsvector);


--
-- Name: index_sorns_on_authority_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_authority_tsvector ON public.sorns USING gin (authority_tsvector);


--
-- Name: index_sorns_on_categories_of_individuals_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_categories_of_individuals_tsvector ON public.sorns USING gin (categories_of_individuals_tsvector);


--
-- Name: index_sorns_on_categories_of_record_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_categories_of_record_tsvector ON public.sorns USING gin (categories_of_record_tsvector);


--
-- Name: index_sorns_on_citation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_citation ON public.sorns USING btree (citation);


--
-- Name: index_sorns_on_contesting_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_contesting_tsvector ON public.sorns USING gin (contesting_tsvector);


--
-- Name: index_sorns_on_dates_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_dates_tsvector ON public.sorns USING gin (dates_tsvector);


--
-- Name: index_sorns_on_exemptions_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_exemptions_tsvector ON public.sorns USING gin (exemptions_tsvector);


--
-- Name: index_sorns_on_further_info_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_further_info_tsvector ON public.sorns USING gin (further_info_tsvector);


--
-- Name: index_sorns_on_history_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_history_tsvector ON public.sorns USING gin (history_tsvector);


--
-- Name: index_sorns_on_location_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_location_tsvector ON public.sorns USING gin (location_tsvector);


--
-- Name: index_sorns_on_manager_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_manager_tsvector ON public.sorns USING gin (manager_tsvector);


--
-- Name: index_sorns_on_notification_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_notification_tsvector ON public.sorns USING gin (notification_tsvector);


--
-- Name: index_sorns_on_purpose_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_purpose_tsvector ON public.sorns USING gin (purpose_tsvector);


--
-- Name: index_sorns_on_retention_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_retention_tsvector ON public.sorns USING gin (retention_tsvector);


--
-- Name: index_sorns_on_retrieval_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_retrieval_tsvector ON public.sorns USING gin (retrieval_tsvector);


--
-- Name: index_sorns_on_routine_uses_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_routine_uses_tsvector ON public.sorns USING gin (routine_uses_tsvector);


--
-- Name: index_sorns_on_safeguards_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_safeguards_tsvector ON public.sorns USING gin (safeguards_tsvector);


--
-- Name: index_sorns_on_security_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_security_tsvector ON public.sorns USING gin (security_tsvector);


--
-- Name: index_sorns_on_source_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_source_tsvector ON public.sorns USING gin (source_tsvector);


--
-- Name: index_sorns_on_storage_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_storage_tsvector ON public.sorns USING gin (storage_tsvector);


--
-- Name: index_sorns_on_summary_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_summary_tsvector ON public.sorns USING gin (summary_tsvector);


--
-- Name: index_sorns_on_supplementary_info_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_supplementary_info_tsvector ON public.sorns USING gin (supplementary_info_tsvector);


--
-- Name: index_sorns_on_system_name_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_system_name_tsvector ON public.sorns USING gin (system_name_tsvector);


--
-- Name: index_sorns_on_system_number_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_system_number_tsvector ON public.sorns USING gin (system_number_tsvector);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200914224855'),
('20200914225155'),
('20200914230142'),
('20200921223917'),
('20200923212702'),
('20200924185945'),
('20200924190652'),
('20200925172818'),
('20200925213051'),
('20200930173010'),
('20201001222130'),
('20201001222141'),
('20201002165508'),
('20201008224246'),
('20201014234853'),
('20201016205652'),
('20201016220441'),
('20201021172347'),
('20201022000709'),
('20201022220018'),
('20201022232920'),
('20201022234350'),
('20201110215925'),
('20201113200542'),
('20201228232801'),
('20210105004619'),
('20210107230007'),
('20210107231530'),
('20210108002822');


