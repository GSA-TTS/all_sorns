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
    agency_names_vector tsvector,
    action_vector tsvector,
    summary_vector tsvector,
    dates_vector tsvector,
    addresses_vector tsvector,
    further_info_vector tsvector,
    supplementary_info_vector tsvector,
    system_name_vector tsvector,
    system_number_vector tsvector,
    security_vector tsvector,
    location_vector tsvector,
    manager_vector tsvector,
    authority_vector tsvector,
    purpose_vector tsvector,
    categories_of_individuals_vector tsvector,
    categories_of_record_vector tsvector,
    source_vector tsvector,
    routine_uses_vector tsvector,
    storage_vector tsvector,
    retrieval_vector tsvector,
    retention_vector tsvector,
    safeguards_vector tsvector,
    access_vector tsvector,
    contesting_vector tsvector,
    notification_vector tsvector,
    exemptions_vector tsvector,
    history_vector tsvector
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
-- Name: access_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (access)::text));


--
-- Name: access_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX access_vector_idx ON public.sorns USING gin (access_vector);


--
-- Name: action_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX action_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (action)::text));


--
-- Name: action_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX action_vector_idx ON public.sorns USING gin (action_vector);


--
-- Name: addresses_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX addresses_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (addresses)::text));


--
-- Name: addresses_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX addresses_vector_idx ON public.sorns USING gin (addresses_vector);


--
-- Name: agency_names_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX agency_names_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (agency_names)::text));


--
-- Name: agency_names_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX agency_names_vector_idx ON public.sorns USING gin (agency_names_vector);


--
-- Name: authority_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authority_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (authority)::text));


--
-- Name: authority_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authority_vector_idx ON public.sorns USING gin (authority_vector);


--
-- Name: categories_of_individuals_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_of_individuals_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (categories_of_individuals)::text));


--
-- Name: categories_of_individuals_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_of_individuals_vector_idx ON public.sorns USING gin (categories_of_individuals_vector);


--
-- Name: categories_of_record_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_of_record_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (categories_of_record)::text));


--
-- Name: categories_of_record_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_of_record_vector_idx ON public.sorns USING gin (categories_of_record_vector);


--
-- Name: contesting_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contesting_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (contesting)::text));


--
-- Name: contesting_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX contesting_vector_idx ON public.sorns USING gin (contesting_vector);


--
-- Name: dates_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dates_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (dates)::text));


--
-- Name: dates_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dates_vector_idx ON public.sorns USING gin (dates_vector);


--
-- Name: exemptions_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exemptions_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (exemptions)::text));


--
-- Name: exemptions_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX exemptions_vector_idx ON public.sorns USING gin (exemptions_vector);


--
-- Name: further_info_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX further_info_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (further_info)::text));


--
-- Name: further_info_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX further_info_vector_idx ON public.sorns USING gin (further_info_vector);


--
-- Name: history_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX history_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (history)::text));


--
-- Name: history_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX history_vector_idx ON public.sorns USING gin (history_vector);


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
-- Name: index_sorns_on_citation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sorns_on_citation ON public.sorns USING btree (citation);


--
-- Name: location_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX location_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (location)::text));


--
-- Name: location_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX location_vector_idx ON public.sorns USING gin (location_vector);


--
-- Name: manager_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX manager_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (manager)::text));


--
-- Name: manager_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX manager_vector_idx ON public.sorns USING gin (manager_vector);


--
-- Name: notification_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (notification)::text));


--
-- Name: notification_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_vector_idx ON public.sorns USING gin (notification_vector);


--
-- Name: purpose_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purpose_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (purpose)::text));


--
-- Name: purpose_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purpose_vector_idx ON public.sorns USING gin (purpose_vector);


--
-- Name: retention_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX retention_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (retention)::text));


--
-- Name: retention_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX retention_vector_idx ON public.sorns USING gin (retention_vector);


--
-- Name: retrieval_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX retrieval_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (retrieval)::text));


--
-- Name: retrieval_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX retrieval_vector_idx ON public.sorns USING gin (retrieval_vector);


--
-- Name: routine_uses_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX routine_uses_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (routine_uses)::text));


--
-- Name: routine_uses_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX routine_uses_vector_idx ON public.sorns USING gin (routine_uses_vector);


--
-- Name: safeguards_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX safeguards_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (safeguards)::text));


--
-- Name: safeguards_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX safeguards_vector_idx ON public.sorns USING gin (safeguards_vector);


--
-- Name: security_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX security_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (security)::text));


--
-- Name: security_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX security_vector_idx ON public.sorns USING gin (security_vector);


--
-- Name: source_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX source_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (source)::text));


--
-- Name: source_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX source_vector_idx ON public.sorns USING gin (source_vector);


--
-- Name: storage_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (storage)::text));


--
-- Name: storage_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX storage_vector_idx ON public.sorns USING gin (storage_vector);


--
-- Name: summary_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX summary_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (summary)::text));


--
-- Name: summary_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX summary_vector_idx ON public.sorns USING gin (summary_vector);


--
-- Name: supplementary_info_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplementary_info_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (supplementary_info)::text));


--
-- Name: supplementary_info_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplementary_info_vector_idx ON public.sorns USING gin (supplementary_info_vector);


--
-- Name: system_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX system_name_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (system_name)::text));


--
-- Name: system_name_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX system_name_vector_idx ON public.sorns USING gin (system_name_vector);


--
-- Name: system_number_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX system_number_idx ON public.sorns USING gist (to_tsvector('english'::regconfig, (system_number)::text));


--
-- Name: system_number_vector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX system_number_vector_idx ON public.sorns USING gin (system_number_vector);


--
-- Name: sorns access_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER access_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('access_vector', 'pg_catalog.english', 'access');


--
-- Name: sorns action_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER action_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('action_vector', 'pg_catalog.english', 'action');


--
-- Name: sorns addresses_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER addresses_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('addresses_vector', 'pg_catalog.english', 'addresses');


--
-- Name: sorns agency_names_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER agency_names_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('agency_names_vector', 'pg_catalog.english', 'agency_names');


--
-- Name: sorns authority_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER authority_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('authority_vector', 'pg_catalog.english', 'authority');


--
-- Name: sorns categories_of_individuals_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_of_individuals_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('categories_of_individuals_vector', 'pg_catalog.english', 'categories_of_individuals');


--
-- Name: sorns categories_of_record_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER categories_of_record_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('categories_of_record_vector', 'pg_catalog.english', 'categories_of_record');


--
-- Name: sorns contesting_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER contesting_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('contesting_vector', 'pg_catalog.english', 'contesting');


--
-- Name: sorns dates_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dates_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('dates_vector', 'pg_catalog.english', 'dates');


--
-- Name: sorns exemptions_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER exemptions_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('exemptions_vector', 'pg_catalog.english', 'exemptions');


--
-- Name: sorns further_info_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER further_info_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('further_info_vector', 'pg_catalog.english', 'further_info');


--
-- Name: sorns history_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER history_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('history_vector', 'pg_catalog.english', 'history');


--
-- Name: sorns location_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER location_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('location_vector', 'pg_catalog.english', 'location');


--
-- Name: sorns manager_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER manager_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('manager_vector', 'pg_catalog.english', 'manager');


--
-- Name: sorns notification_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER notification_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('notification_vector', 'pg_catalog.english', 'notification');


--
-- Name: sorns purpose_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER purpose_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('purpose_vector', 'pg_catalog.english', 'purpose');


--
-- Name: sorns retention_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER retention_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('retention_vector', 'pg_catalog.english', 'retention');


--
-- Name: sorns retrieval_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER retrieval_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('retrieval_vector', 'pg_catalog.english', 'retrieval');


--
-- Name: sorns routine_uses_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER routine_uses_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('routine_uses_vector', 'pg_catalog.english', 'routine_uses');


--
-- Name: sorns safeguards_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER safeguards_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('safeguards_vector', 'pg_catalog.english', 'safeguards');


--
-- Name: sorns security_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER security_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('security_vector', 'pg_catalog.english', 'security');


--
-- Name: sorns source_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER source_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('source_vector', 'pg_catalog.english', 'source');


--
-- Name: sorns storage_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER storage_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('storage_vector', 'pg_catalog.english', 'storage');


--
-- Name: sorns summary_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER summary_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('summary_vector', 'pg_catalog.english', 'summary');


--
-- Name: sorns supplementary_info_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER supplementary_info_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('supplementary_info_vector', 'pg_catalog.english', 'supplementary_info');


--
-- Name: sorns system_name_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER system_name_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('system_name_vector', 'pg_catalog.english', 'system_name');


--
-- Name: sorns system_number_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER system_number_trigger BEFORE INSERT OR UPDATE ON public.sorns FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('system_number_vector', 'pg_catalog.english', 'system_number');


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
('20201230000228'),
('20201230173611');


