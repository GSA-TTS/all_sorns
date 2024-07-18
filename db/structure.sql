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
-- Name: good_job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description text,
    serialized_properties jsonb,
    on_finish text,
    on_success text,
    on_discard text,
    callback_queue_name text,
    callback_priority integer,
    enqueued_at timestamp without time zone,
    discarded_at timestamp without time zone,
    finished_at timestamp without time zone
);


--
-- Name: good_job_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_executions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid NOT NULL,
    job_class text,
    queue_name text,
    serialized_params jsonb,
    scheduled_at timestamp without time zone,
    finished_at timestamp without time zone,
    error text,
    error_event smallint
);


--
-- Name: good_job_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state jsonb
);


--
-- Name: good_job_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    key text,
    value jsonb
);


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
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text,
    retried_good_job_id uuid,
    cron_at timestamp without time zone,
    batch_id uuid,
    batch_callback_id uuid,
    is_discrete boolean,
    executions_count integer,
    job_class text,
    error_event smallint
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
    system_number character varying,
    citation character varying,
    agency_names character varying,
    xml character varying,
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
    history_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(history, ''::character varying))::text)) STORED,
    xml_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, (COALESCE(xml, ''::character varying))::text)) STORED
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
-- Name: good_job_batches good_job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_batches
    ADD CONSTRAINT good_job_batches_pkey PRIMARY KEY (id);


--
-- Name: good_job_executions good_job_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_executions
    ADD CONSTRAINT good_job_executions_pkey PRIMARY KEY (id);


--
-- Name: good_job_processes good_job_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);


--
-- Name: good_job_settings good_job_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_settings
    ADD CONSTRAINT good_job_settings_pkey PRIMARY KEY (id);


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
-- Name: index_good_job_executions_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_active_job_id_and_created_at ON public.good_job_executions USING btree (active_job_id, created_at);


--
-- Name: index_good_job_settings_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_job_settings_on_key ON public.good_job_settings USING btree (key);


--
-- Name: index_good_jobs_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at ON public.good_jobs USING btree (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL));


--
-- Name: index_good_jobs_jobs_on_priority_created_at_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_priority_created_at_when_unfinished ON public.good_jobs USING btree (priority DESC NULLS LAST, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_active_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id ON public.good_jobs USING btree (active_job_id);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON public.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_batch_callback_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_callback_id ON public.good_jobs USING btree (batch_callback_id) WHERE (batch_callback_id IS NOT NULL);


--
-- Name: index_good_jobs_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_id ON public.good_jobs USING btree (batch_id) WHERE (batch_id IS NOT NULL);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON public.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_cron_key_and_created_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON public.good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON public.good_jobs USING btree (cron_key, cron_at) WHERE (cron_key IS NOT NULL);


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
-- Name: index_sorns_on_xml_tsvector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_xml_tsvector ON public.sorns USING gin (xml_tsvector);


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
('20210107230007'),
('20210107231530'),
('20210108002822'),
('20210129220248'),
('20210204202244'),
('20210303173553'),
('20210303182701'),
('20240717224231'),
('20240717224232'),
('20240717224233'),
('20240717225931'),
('20240717225932'),
('20240717225933'),
('20240717225934'),
('20240718000130'),
('20240718000400'),
('20240718000608'),
('20240718000910'),
('20240718001115'),
('20240718001330');


