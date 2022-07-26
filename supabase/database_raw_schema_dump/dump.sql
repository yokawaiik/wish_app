--
-- PostgreSQL database dump
--
-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.4
SET
  statement_timeout = 0;

SET
  lock_timeout = 0;

SET
  idle_in_transaction_session_timeout = 0;

SET
  client_encoding = 'UTF8';

SET
  standard_conforming_strings = on;

SELECT
  pg_catalog.set_config('search_path', '', false);

SET
  check_function_bodies = false;

SET
  xmloption = content;

SET
  client_min_messages = warning;

SET
  row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--
CREATE SCHEMA auth;

ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--
CREATE SCHEMA extensions;

ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA extensions;

--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--
COMMENT ON EXTENSION pg_graphql IS 'GraphQL support';

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--
CREATE SCHEMA graphql_public;

ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--
COMMENT ON EXTENSION pg_net IS 'Async HTTP';

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--
CREATE SCHEMA pgbouncer;

ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--
CREATE SCHEMA realtime;

ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--
CREATE SCHEMA storage;

ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--
CREATE SCHEMA supabase_functions;

ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;

--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--
COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';

--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;

--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--
COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;

--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

--
-- Name: _result_added_favorite_wish; Type: TYPE; Schema: public; Owner: supabase_admin
--
CREATE TYPE public._result_added_favorite_wish AS (
  id integer,
  title character varying,
  description character varying,
  link character varying,
  "imageUrl" character varying,
  "createdAt" timestamp with time zone,
  "isFulfilled" boolean,
  "createdBy" jsonb
);

ALTER TYPE public._result_added_favorite_wish OWNER TO supabase_admin;

--
-- Name: result_check_subscription; Type: TYPE; Schema: public; Owner: supabase_admin
--
CREATE TYPE public.result_check_subscription AS (
  has_subscribe boolean,
  has_subscription boolean
);

ALTER TYPE public.result_check_subscription OWNER TO supabase_admin;

--
-- Name: result_info_user; Type: TYPE; Schema: public; Owner: supabase_admin
--
CREATE TYPE public.result_info_user AS (
  count_of_wishes integer,
  count_of_subscribers integer,
  count_of_subscribing integer
);

ALTER TYPE public.result_info_user OWNER TO supabase_admin;

--
-- Name: result_type_check_if_user_exist; Type: TYPE; Schema: public; Owner: supabase_admin
--
CREATE TYPE public.result_type_check_if_user_exist AS (result_login boolean, result_email boolean);

ALTER TYPE public.result_type_check_if_user_exist OWNER TO supabase_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--
CREATE TYPE realtime.action AS ENUM (
  'INSERT',
  'UPDATE',
  'DELETE',
  'TRUNCATE',
  'ERROR'
);

ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--
CREATE TYPE realtime.equality_op AS ENUM (
  'eq',
  'neq',
  'lt',
  'lte',
  'gt',
  'gte'
);

ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--
CREATE TYPE realtime.user_defined_filter AS (
  column_name text,
  op realtime.equality_op,
  value text
);

ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--
CREATE TYPE realtime.wal_column AS (
  name text,
  type_name text,
  type_oid oid,
  value jsonb,
  is_pkey boolean,
  is_selectable boolean
);

ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--
CREATE TYPE realtime.wal_rls AS (
  wal jsonb,
  is_rls_enabled boolean,
  subscription_ids uuid [],
  errors text []
);

ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--
CREATE FUNCTION auth.email() RETURNS text LANGUAGE sql STABLE AS $ $
select
  coalesce(
    nullif(
      current_setting('request.jwt.claim.email', true),
      ''
    ),
    (
      nullif(current_setting('request.jwt.claims', true), '') :: jsonb ->> 'email'
    )
  ) :: text $ $;

ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';

--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--
CREATE FUNCTION auth.jwt() RETURNS jsonb LANGUAGE sql STABLE AS $ $
select
  coalesce(
    nullif(current_setting('request.jwt.claim', true), ''),
    nullif(current_setting('request.jwt.claims', true), '')
  ) :: jsonb $ $;

ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--
CREATE FUNCTION auth.role() RETURNS text LANGUAGE sql STABLE AS $ $
select
  coalesce(
    nullif(
      current_setting('request.jwt.claim.role', true),
      ''
    ),
    (
      nullif(current_setting('request.jwt.claims', true), '') :: jsonb ->> 'role'
    )
  ) :: text $ $;

ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';

--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--
CREATE FUNCTION auth.uid() RETURNS uuid LANGUAGE sql STABLE AS $ $
select
  coalesce(
    nullif(
      current_setting('request.jwt.claim.sub', true),
      ''
    ),
    (
      nullif(current_setting('request.jwt.claims', true), '') :: jsonb ->> 'sub'
    )
  ) :: uuid $ $;

ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';

--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--
CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger LANGUAGE plpgsql AS $ $ DECLARE schema_is_cron bool;

BEGIN schema_is_cron = (
  SELECT
    n.nspname = 'cron'
  FROM
    pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n ON ev.objid = n.oid
);

IF schema_is_cron THEN grant usage on schema cron to postgres with grant option;

alter default privileges in schema cron grant all on tables to postgres with grant option;

alter default privileges in schema cron grant all on functions to postgres with grant option;

alter default privileges in schema cron grant all on sequences to postgres with grant option;

alter default privileges for user supabase_admin in schema cron grant all on sequences to postgres with grant option;

alter default privileges for user supabase_admin in schema cron grant all on tables to postgres with grant option;

alter default privileges for user supabase_admin in schema cron grant all on functions to postgres with grant option;

grant all privileges on all tables in schema cron to postgres with grant option;

END IF;

END;

$ $;

ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--
COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';

--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--
CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger LANGUAGE plpgsql AS $ _ $ DECLARE func_is_graphql_resolve bool;

BEGIN func_is_graphql_resolve = (
  SELECT
    n.proname = 'resolve'
  FROM
    pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_proc AS n ON ev.objid = n.oid
);

IF func_is_graphql_resolve THEN grant usage on schema graphql to postgres,
anon,
authenticated,
service_role;

grant all on function graphql.resolve to postgres,
anon,
authenticated,
service_role;

alter default privileges in schema graphql grant all on tables to postgres,
anon,
authenticated,
service_role;

alter default privileges in schema graphql grant all on functions to postgres,
anon,
authenticated,
service_role;

alter default privileges in schema graphql grant all on sequences to postgres,
anon,
authenticated,
service_role;

-- Update public wrapper to pass all arguments through to the pg_graphql resolve func
create
or replace function graphql_public.graphql(
  "operationName" text default null,
  query text default null,
  variables jsonb default null,
  extensions jsonb default null
) returns jsonb language sql as $ $ -- This changed
select
  graphql.resolve(
    query := query,
    variables := coalesce(variables, '{}'),
    "operationName" := "operationName",
    extensions := extensions
  );

$ $;

grant
select
  on graphql.field,
  graphql.type,
  graphql.enum_value to postgres,
  anon,
  authenticated,
  service_role;

grant execute on function graphql.resolve to postgres,
anon,
authenticated,
service_role;

END IF;

END;

$ _ $;

ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--
COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';

--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--
CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger LANGUAGE plpgsql AS $ $ BEGIN IF EXISTS (
  SELECT
    1
  FROM
    pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext ON ev.objid = ext.oid
  WHERE
    ext.extname = 'pg_net'
) THEN GRANT USAGE ON SCHEMA net TO supabase_functions_admin,
postgres,
anon,
authenticated,
service_role;

ALTER function net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) SECURITY DEFINER;

ALTER function net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) SECURITY DEFINER;

ALTER function net.http_collect_response(request_id bigint, async boolean) SECURITY DEFINER;

ALTER function net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
)
SET
  search_path = net;

ALTER function net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
)
SET
  search_path = net;

ALTER function net.http_collect_response(request_id bigint, async boolean)
SET
  search_path = net;

REVOKE ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
)
FROM
  PUBLIC;

REVOKE ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
)
FROM
  PUBLIC;

REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean)
FROM
  PUBLIC;

GRANT EXECUTE ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO supabase_functions_admin,
postgres,
anon,
authenticated,
service_role;

GRANT EXECUTE ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO supabase_functions_admin,
postgres,
anon,
authenticated,
service_role;

GRANT EXECUTE ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin,
postgres,
anon,
authenticated,
service_role;

END IF;

END;

$ $;

ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--
COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';

--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--
CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger LANGUAGE plpgsql AS $ $ DECLARE cmd record;

BEGIN FOR cmd IN
SELECT
  *
FROM
  pg_event_trigger_ddl_commands() LOOP IF cmd.command_tag IN (
    'CREATE SCHEMA',
    'ALTER SCHEMA',
    'CREATE TABLE',
    'CREATE TABLE AS',
    'SELECT INTO',
    'ALTER TABLE',
    'CREATE FOREIGN TABLE',
    'ALTER FOREIGN TABLE',
    'CREATE VIEW',
    'ALTER VIEW',
    'CREATE MATERIALIZED VIEW',
    'ALTER MATERIALIZED VIEW',
    'CREATE FUNCTION',
    'ALTER FUNCTION',
    'CREATE TRIGGER',
    'CREATE TYPE',
    'ALTER TYPE',
    'CREATE RULE',
    'COMMENT'
  ) -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
  AND cmd.schema_name is distinct
from
  'pg_temp' THEN NOTIFY pgrst,
  'reload schema';

END IF;

END LOOP;

END;

$ $;

ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--
CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger LANGUAGE plpgsql AS $ $ DECLARE obj record;

BEGIN FOR obj IN
SELECT
  *
FROM
  pg_event_trigger_dropped_objects() LOOP IF obj.object_type IN (
    'schema',
    'table',
    'foreign table',
    'view',
    'materialized view',
    'function',
    'trigger',
    'type',
    'rule'
  )
  AND obj.is_temporary IS false -- no pg_temp objects
  THEN NOTIFY pgrst,
  'reload schema';

END IF;

END LOOP;

END;

$ $;

ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--
CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger LANGUAGE plpgsql AS $ _ $ DECLARE graphql_is_dropped bool;

BEGIN graphql_is_dropped = (
  SELECT
    ev.schema_name = 'graphql_public'
  FROM
    pg_event_trigger_dropped_objects() AS ev
  WHERE
    ev.schema_name = 'graphql_public'
);

IF graphql_is_dropped THEN create
or replace function graphql_public.graphql(
  "operationName" text default null,
  query text default null,
  variables jsonb default null,
  extensions jsonb default null
) returns jsonb language plpgsql as $ $ DECLARE server_version float;

BEGIN server_version = (
  SELECT
    (
      SPLIT_PART(
        (
          select
            version()
        ),
        ' ',
        2
      )
    ) :: float
);

IF server_version >= 14 THEN RETURN jsonb_build_object(
  'errors',
  jsonb_build_array(
    jsonb_build_object(
      'message',
      'pg_graphql extension is not enabled.'
    )
  )
);

ELSE RETURN jsonb_build_object(
  'errors',
  jsonb_build_array(
    jsonb_build_object(
      'message',
      'pg_graphql is only available on projects running Postgres 14 onwards.'
    )
  )
);

END IF;

END;

$ $;

END IF;

END;

$ _ $;

ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--
COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--
CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text) LANGUAGE plpgsql SECURITY DEFINER AS $ $ BEGIN RAISE WARNING 'PgBouncer auth request: %',
p_usename;

RETURN QUERY
SELECT
  usename :: TEXT,
  passwd :: TEXT
FROM
  pg_catalog.pg_shadow
WHERE
  usename = p_usename;

END;

$ $;

ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: check_if_user_exist(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.check_if_user_exist(in_login text, in_email text) RETURNS public.result_type_check_if_user_exist LANGUAGE plpgsql AS $ $ DECLARE -- resultLogin boolean;
-- resultEmail boolean;
result_record result_type_check_if_user_exist;

BEGIN
SELECT
  EXISTS(
    SELECT
      u.login
    FROM
      users as u
    WHERE
      u.login = LOWER(in_login)
  ) into result_record.result_login;

SELECT
  EXISTS(
    SELECT
      u.email
    FROM
      users as u
    WHERE
      u.email = LOWER(in_email)
  ) into result_record.result_email;

RETURN result_record;

END;

$ $;

ALTER FUNCTION public.check_if_user_exist(in_login text, in_email text) OWNER TO supabase_admin;

--
-- Name: check_subscription(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.check_subscription(in_current_user_id text, in_another_user_id text) RETURNS public.result_check_subscription LANGUAGE plpgsql AS $ $ DECLARE result_record result_check_subscription;

BEGIN
SELECT
  (
    select
      exists(
        select
          *
        from
          subscriptions as S
        where
          S."id" = in_current_user_id :: uuid
          AND S."subscriptionTo" = in_another_user_id :: uuid
      )
  ) into result_record.has_subscribe;

SELECT
  (
    select
      exists(
        select
          *
        from
          subscriptions as S
        where
          S."id" = in_another_user_id :: uuid
          AND S."subscriptionTo" = in_current_user_id :: uuid
      )
  ) into result_record.has_subscription;

RETURN result_record;

END;

$ $;

ALTER FUNCTION public.check_subscription(in_current_user_id text, in_another_user_id text) OWNER TO supabase_admin;

--
-- Name: count_of_favorites(character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.count_of_favorites(
  in_user_id character varying DEFAULT NULL :: character varying
) RETURNS integer LANGUAGE plpgsql AS $ $ BEGIN IF in_user_id IS NOT NULL THEN RETURN (
  select
    count(F."userId")
  from
    favorites AS F
  where
    F."userId" = in_user_id :: uuid
);

ELSE RAISE EXCEPTION 'User id is not be null.';

END IF;

END;

$ $;

ALTER FUNCTION public.count_of_favorites(in_user_id character varying) OWNER TO supabase_admin;

--
-- Name: count_of_wish_in_subscriptions(character varying); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.count_of_wish_in_subscriptions(
  user_id character varying DEFAULT NULL :: character varying
) RETURNS integer LANGUAGE plpgsql AS $ $ BEGIN IF user_id IS NOT NULL THEN RETURN (
  SELECT
    count(W."id")
  FROM
    wish AS W
    JOIN subscriptions AS S ON W."createdBy" = S."subscriptionTo"
    AND S."id" = user_id :: uuid
);

ELSE RETURN (
  SELECT
    count(W."id")
  FROM
    wish AS W
    JOIN subscriptions AS S ON W."createdBy" = S."subscriptionTo"
);

END IF;

END;

$ $;

ALTER FUNCTION public.count_of_wish_in_subscriptions(user_id character varying) OWNER TO supabase_admin;

--
-- Name: get_added_favorite_wish(integer, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.get_added_favorite_wish(in_wish_id integer, in_user_id text) RETURNS public._result_added_favorite_wish LANGUAGE plpgsql AS $ $ declare out_result _result_added_favorite_wish default null;

begin
select
  W."id",
  W."title",
  W."description",
  W."link",
  W."imageUrl",
  W."createdAt",
  W."isFulfilled",
  jsonb_build_object(
    'id',
    W."createdBy",
    'login',
    U."login",
    'imageUrl',
    U."imageUrl",
    'userColor',
    U."userColor"
  ) into out_result
from
  wish as W
  join users as U on W."createdBy" = U."id"
  join favorites as F on F."wishId" = W."id"
  and F."userId" = in_user_id :: uuid
  and F."wishId" = in_wish_id;

if out_result is null then RAISE exception 'No data.';

end if;

return out_result;

end;

$ $;

ALTER FUNCTION public.get_added_favorite_wish(in_wish_id integer, in_user_id text) OWNER TO supabase_admin;

--
-- Name: info_user(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.info_user(in_user_id text) RETURNS public.result_info_user LANGUAGE plpgsql AS $ $ DECLARE result_record result_info_user;

BEGIN
SELECT
  (
    select
      count(W."id")
    from
      wish as W
    where
      W."createdBy" = in_user_id :: uuid
  ) into result_record.count_of_wishes;

SELECT
  (
    select
      count(S.id)
    from
      subscriptions as S
    where
      S."id" = in_user_id :: uuid
      AND S."subscriptionTo" != in_user_id :: uuid
  ) into result_record.count_of_subscribing;

SELECT
  (
    select
      count(S.id)
    from
      subscriptions as S
    where
      S."subscriptionTo" = in_user_id :: uuid
      AND S."id" != in_user_id :: uuid
  ) into result_record.count_of_subscribers;

RETURN result_record;

END;

$ $;

ALTER FUNCTION public.info_user(in_user_id text) OWNER TO supabase_admin;

--
-- Name: search_light_user_list(text, text, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.search_light_user_list(
  in_query text,
  in_user_id text DEFAULT NULL :: text,
  in_limit integer DEFAULT 10
) RETURNS TABLE(
  id uuid,
  login text,
  "imageUrl" text,
  "userColor" text
) LANGUAGE plpgsql AS $ $ BEGIN IF "in_user_id" IS NOT NULL THEN return query
select
  u."id",
  u."login",
  u."imageUrl",
  u."userColor"
from
  users as u
where
  lower(u."login") LIKE '%' || lower("in_query") || '%'
  and u.id not in ("in_user_id" :: uuid)
limit
  "in_limit";

else return query
select
  u."id",
  u."login",
  u."imageUrl",
  u."userColor"
from
  users as u
where
  u."login" LIKE '%' || "in_query" || '%'
limit
  "in_limit";

end if;

END;

$ $;

ALTER FUNCTION public.search_light_user_list(in_query text, in_user_id text, in_limit integer) OWNER TO supabase_admin;

--
-- Name: search_light_wish_list(text, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.search_light_wish_list(in_query text, in_limit integer DEFAULT 10) RETURNS TABLE(
  id bigint,
  title character varying,
  "imageUrl" character varying,
  "userColor" text
) LANGUAGE plpgsql AS $ $ begin return query
select
  w."id",
  w."title",
  w."imageUrl",
  u."userColor"
from
  wish as W
  join users as U on W."createdBy" = U."id"
where
  lower(W."title") LIKE '%' || lower("in_query") || '%'
limit
  "in_limit";

end;

$ $;

ALTER FUNCTION public.search_light_wish_list(in_query text, in_limit integer) OWNER TO supabase_admin;

--
-- Name: select_favorite_wish_list(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.select_favorite_wish_list(
  in_user_id character varying DEFAULT NULL :: character varying,
  in_limit integer DEFAULT 10,
  in_offset integer DEFAULT 0
) RETURNS TABLE(
  id bigint,
  title character varying,
  description character varying,
  link character varying,
  "imageUrl" character varying,
  "createdAt" timestamp with time zone,
  "isFulfilled" boolean,
  "createdBy" jsonb,
  "wasAdded" timestamp with time zone
) LANGUAGE plpgsql AS $ $ begin return query
select
  W."id",
  W."title",
  W."description",
  W."link",
  W."imageUrl",
  W."createdAt",
  W."isFulfilled",
  jsonb_build_object(
    'id',
    W."createdBy",
    'login',
    U."login",
    'imageUrl',
    U."imageUrl",
    'userColor',
    U."userColor"
  ) as createdBy,
  F."wasAdded"
from
  wish as W
  join users as U on W."createdBy" = U."id"
  join favorites as F on F."wishId" = W."id"
  and F."userId" = in_user_id :: uuid
order by
  F."wasAdded" desc
limit
  in_limit offset in_offset;

end;

$ $;

ALTER FUNCTION public.select_favorite_wish_list(
  in_user_id character varying,
  in_limit integer,
  in_offset integer
) OWNER TO supabase_admin;

--
-- Name: select_user_wish_list(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.select_user_wish_list(
  in_user_id character varying DEFAULT NULL :: character varying,
  "limit" integer DEFAULT 10,
  "offset" integer DEFAULT 0
) RETURNS TABLE(
  id bigint,
  title character varying,
  description character varying,
  link character varying,
  "imageUrl" character varying,
  "createdAt" timestamp with time zone,
  "isFulfilled" boolean,
  "createdBy" jsonb
) LANGUAGE plpgsql AS $ $ BEGIN RETURN query
SELECT
  W."id",
  W."title",
  W."description",
  W."link",
  W."imageUrl",
  W."createdAt",
  W."isFulfilled",
  jsonb_build_object(
    'id',
    W."createdBy",
    'login',
    U."login",
    'imageUrl',
    U."imageUrl",
    'userColor',
    U."userColor"
  ) as "createdBy"
FROM
  wish AS W
  JOIN users AS U ON W."createdBy" = U."id"
  AND W."createdBy" = in_user_id :: uuid
ORDER BY
  W."createdAt" DESC
LIMIT
  "limit" OFFSET "offset";

END;

$ $;

ALTER FUNCTION public.select_user_wish_list(
  in_user_id character varying,
  "limit" integer,
  "offset" integer
) OWNER TO supabase_admin;

--
-- Name: select_wish_list(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.select_wish_list(
  user_id character varying DEFAULT NULL :: character varying,
  "limit" integer DEFAULT 10,
  "offset" integer DEFAULT 0
) RETURNS TABLE(
  id bigint,
  title character varying,
  description character varying,
  link character varying,
  "imageUrl" character varying,
  "createdAt" timestamp with time zone,
  "isFulfilled" boolean,
  "createdBy" jsonb,
  "isFavorite" boolean
) LANGUAGE plpgsql AS $ $ BEGIN IF user_id IS NOT NULL THEN RETURN query
SELECT
  W."id",
  W."title",
  W."description",
  W."link",
  W."imageUrl",
  W."createdAt",
  W."isFulfilled",
  jsonb_build_object(
    'id',
    W."createdBy",
    'login',
    U."login",
    'imageUrl',
    U."imageUrl",
    'userColor',
    U."userColor"
  ) as "createdBy",
  exists(
    select
      *
    from
      favorites as NF
    where
      NF."wishId" = W."id"
      and NF."userId" = user_id :: uuid
  ) as "isFavorite"
FROM
  wish AS W
  JOIN subscriptions AS S ON W."createdBy" = S."subscriptionTo"
  AND S."id" = user_id :: uuid
  JOIN users AS U ON W."createdBy" = U."id"
ORDER BY
  W."createdAt" DESC
LIMIT
  "limit" OFFSET "offset";

ELSE RETURN query
SELECT
  W."id",
  W."title",
  W."description",
  W."link",
  W."imageUrl",
  W."createdAt",
  W."isFulfilled",
  jsonb_build_object(
    'id',
    W."createdBy",
    'login',
    U."login",
    'imageUrl',
    U."imageUrl",
    'userColor',
    U."userColor"
  ) as "createdBy",
  false as "isFavorite"
FROM
  wish AS W
  JOIN users AS U ON W."createdBy" = U."id"
ORDER BY
  W."createdAt" DESC
LIMIT
  "limit" OFFSET "offset";

END IF;

END;

$ $;

ALTER FUNCTION public.select_wish_list(
  user_id character varying,
  "limit" integer,
  "offset" integer
) OWNER TO supabase_admin;

--
-- Name: test_function_table(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.test_function_table() RETURNS TABLE(id bigint, title character varying) LANGUAGE plpgsql AS $ $ BEGIN RETURN query
SELECT
  W."id",
  W."title"
FROM
  wish as W;

END;

$ $;

ALTER FUNCTION public.test_function_table() OWNER TO supabase_admin;

--
-- Name: toggle_favorite(text, integer); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.toggle_favorite(in_user_id text, in_wish_id integer) RETURNS boolean LANGUAGE plpgsql AS $ $ DECLARE row_exists bool;

BEGIN
SELECT
  EXISTS(
    SELECT
    FROM
      favorites as F
    WHERE
      F."userId" = in_user_id :: uuid
      AND F."wishId" = in_wish_id
  ) INTO row_exists;

IF (row_exists) THEN
DELETE FROM
  favorites as F
WHERE
  F."userId" = in_user_id :: uuid
  AND F."wishId" = in_wish_id;

return false;

ELSE
INSERT INTO
  favorites("userId", "wishId")
VALUES
  (in_user_id :: uuid, in_wish_id);

return true;

END IF;

END;

$ $;

ALTER FUNCTION public.toggle_favorite(in_user_id text, in_wish_id integer) OWNER TO supabase_admin;

--
-- Name: toggle_subscription(text, text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.toggle_subscription(in_current_user_id text, in_another_user_id text) RETURNS boolean LANGUAGE plpgsql AS $ $ DECLARE row_exists bool;

BEGIN
SELECT
  EXISTS(
    SELECT
    FROM
      subscriptions as S
    WHERE
      S."id" = in_current_user_id :: uuid
      AND S."subscriptionTo" = in_another_user_id :: uuid
  ) INTO row_exists;

IF (row_exists) THEN
DELETE FROM
  subscriptions as S
WHERE
  S."id" = in_current_user_id :: uuid
  AND S."subscriptionTo" = in_another_user_id :: uuid;

RETURN false;

ELSE
INSERT INTO
  subscriptions("id", "subscriptionTo")
VALUES
  (
    in_current_user_id :: uuid,
    in_another_user_id :: uuid
  );

RETURN true;

END IF;

END;

$ $;

ALTER FUNCTION public.toggle_subscription(in_current_user_id text, in_another_user_id text) OWNER TO supabase_admin;

--
-- Name: trigger_wish_delete_after(); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.trigger_wish_delete_after() RETURNS trigger LANGUAGE plpgsql AS $ $ begin
delete from
  favorites as F
where
  F."wishId" = old."id";

return old;

end;

$ $;

ALTER FUNCTION public.trigger_wish_delete_after() OWNER TO supabase_admin;

--
-- Name: varchar_to_uuid(text); Type: FUNCTION; Schema: public; Owner: supabase_admin
--
CREATE FUNCTION public.varchar_to_uuid(value_varchar text) RETURNS uuid LANGUAGE plpgsql AS $ $ BEGIN return value_varchar :: uuid;

END;

$ $;

ALTER FUNCTION public.varchar_to_uuid(value_varchar text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--
CREATE FUNCTION realtime.apply_rls(
  wal jsonb,
  max_record_bytes integer DEFAULT (1024 * 1024)
) RETURNS SETOF realtime.wal_rls LANGUAGE plpgsql AS $ $ declare -- Regclass of the table e.g. public.notes
entity_ regclass = (
  quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table')
) :: regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
  case
    wal ->> 'action'
    when 'I' then 'INSERT'
    when 'U' then 'UPDATE'
    when 'D' then 'DELETE'
    else 'ERROR'
  end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity
from
  pg_class
where
  oid = entity_;

subscriptions realtime.subscription [] = array_agg(subs)
from
  realtime.subscription subs
where
  subs.entity = entity_;

-- Subscription vars
roles regrole [] = array_agg(distinct us.claims_role)
from
  unnest(subscriptions) us;

working_role regrole;

claimed_role regrole;

claims jsonb;

subscription_id uuid;

subscription_has_access bool;

visible_to_subscription_ids uuid [] = '{}';

-- structured info for wal's columns
columns realtime.wal_column [];

-- previous identity values for update/delete
old_columns realtime.wal_column [];

error_record_exceeds_max_size boolean = octet_length(wal :: text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin perform set_config('role', null, true);

columns = array_agg(
  (
    x ->> 'name',
    x ->> 'type',
    x ->> 'typeoid',
    realtime.cast(
      (x -> 'value') #>> '{}',
      coalesce(
        (x ->> 'typeoid') :: regtype,
        -- null when wal2json version <= 2.4
        (x ->> 'type') :: regtype
      )
    ),
    (pks ->> 'name') is not null,
    true
  ) :: realtime.wal_column
)
from
  jsonb_array_elements(wal -> 'columns') x
  left join jsonb_array_elements(wal -> 'pk') pks on (x ->> 'name') = (pks ->> 'name');

old_columns = array_agg(
  (
    x ->> 'name',
    x ->> 'type',
    x ->> 'typeoid',
    realtime.cast(
      (x -> 'value') #>> '{}',
      coalesce(
        (x ->> 'typeoid') :: regtype,
        -- null when wal2json version <= 2.4
        (x ->> 'type') :: regtype
      )
    ),
    (pks ->> 'name') is not null,
    true
  ) :: realtime.wal_column
)
from
  jsonb_array_elements(wal -> 'identity') x
  left join jsonb_array_elements(wal -> 'pk') pks on (x ->> 'name') = (pks ->> 'name');

for working_role in
select
  *
from
  unnest(roles) loop -- Update `is_selectable` for columns and old_columns
  columns = array_agg(
    (
      c.name,
      c.type_name,
      c.type_oid,
      c.value,
      c.is_pkey,
      pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
    ) :: realtime.wal_column
  )
from
  unnest(columns) c;

old_columns = array_agg(
  (
    c.name,
    c.type_name,
    c.type_oid,
    c.value,
    c.is_pkey,
    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
  ) :: realtime.wal_column
)
from
  unnest(old_columns) c;

if action <> 'DELETE'
and count(1) = 0
from
  unnest(columns) c
where
  c.is_pkey then return next (
    jsonb_build_object(
      'schema',
      wal ->> 'schema',
      'table',
      wal ->> 'table',
      'type',
      action
    ),
    is_rls_enabled,
    -- subscriptions is already filtered by entity
    (
      select
        array_agg(s.subscription_id)
      from
        unnest(subscriptions) as s
      where
        claims_role = working_role
    ),
    array ['Error 400: Bad Request, no primary key']
  ) :: realtime.wal_rls;

-- The claims role does not have SELECT permission to the primary key of entity
elsif action <> 'DELETE'
and sum(c.is_selectable :: int) <> count(1)
from
  unnest(columns) c
where
  c.is_pkey then return next (
    jsonb_build_object(
      'schema',
      wal ->> 'schema',
      'table',
      wal ->> 'table',
      'type',
      action
    ),
    is_rls_enabled,
    (
      select
        array_agg(s.subscription_id)
      from
        unnest(subscriptions) as s
      where
        claims_role = working_role
    ),
    array ['Error 401: Unauthorized']
  ) :: realtime.wal_rls;

else output = jsonb_build_object(
  'schema',
  wal ->> 'schema',
  'table',
  wal ->> 'table',
  'type',
  action,
  'commit_timestamp',
  to_char(
    (wal ->> 'timestamp') :: timestamptz,
    'YYYY-MM-DD"T"HH24:MI:SS"Z"'
  ),
  'columns',
  (
    select
      jsonb_agg(
        jsonb_build_object(
          'name',
          pa.attname,
          'type',
          pt.typname
        )
        order by
          pa.attnum asc
      )
    from
      pg_attribute pa
      join pg_type pt on pa.atttypid = pt.oid
    where
      attrelid = entity_
      and attnum > 0
      and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
  )
) -- Add "record" key for insert and update
|| case
  when action in ('INSERT', 'UPDATE') then case
    when error_record_exceeds_max_size then jsonb_build_object(
      'record',
      (
        select
          jsonb_object_agg((c).name, (c).value)
        from
          unnest(columns) c
        where
          (c).is_selectable
          and (octet_length((c).value :: text) <= 64)
      )
    )
    else jsonb_build_object(
      'record',
      (
        select
          jsonb_object_agg((c).name, (c).value)
        from
          unnest(columns) c
        where
          (c).is_selectable
      )
    )
  end
  else '{}' :: jsonb
end -- Add "old_record" key for update and delete
|| case
  when action in ('UPDATE', 'DELETE') then case
    when error_record_exceeds_max_size then jsonb_build_object(
      'old_record',
      (
        select
          jsonb_object_agg((c).name, (c).value)
        from
          unnest(old_columns) c
        where
          (c).is_selectable
          and (octet_length((c).value :: text) <= 64)
      )
    )
    else jsonb_build_object(
      'old_record',
      (
        select
          jsonb_object_agg((c).name, (c).value)
        from
          unnest(old_columns) c
        where
          (c).is_selectable
      )
    )
  end
  else '{}' :: jsonb
end;

-- Create the prepared statement
if is_rls_enabled
and action <> 'DELETE' then if (
  select
    1
  from
    pg_prepared_statements
  where
    name = 'walrus_rls_stmt'
  limit
    1
) > 0 then deallocate walrus_rls_stmt;

end if;

execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);

end if;

visible_to_subscription_ids = '{}';

for subscription_id,
claims in (
  select
    subs.subscription_id,
    subs.claims
  from
    unnest(subscriptions) subs
  where
    subs.entity = entity_
    and subs.claims_role = working_role
    and realtime.is_visible_through_filters(columns, subs.filters)
) loop if not is_rls_enabled
or action = 'DELETE' then visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;

else -- Check if RLS allows the role to see the record
perform set_config('role', working_role :: text, true),
set_config('request.jwt.claims', claims :: text, true);

execute 'execute walrus_rls_stmt' into subscription_has_access;

if subscription_has_access then visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;

end if;

end if;

end loop;

perform set_config('role', null, true);

return next (
  output,
  is_rls_enabled,
  visible_to_subscription_ids,
  case
    when error_record_exceeds_max_size then array ['Error 413: Payload Too Large']
    else '{}'
  end
) :: realtime.wal_rls;

end if;

end loop;

perform set_config('role', null, true);

end;

$ $;

ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--
CREATE FUNCTION realtime.build_prepared_statement_sql(
  prepared_statement_name text,
  entity regclass,
  columns realtime.wal_column []
) RETURNS text LANGUAGE sql AS $ $
/*
 Builds a sql string that, if executed, creates a prepared statement to
 tests retrive a row from *entity* by its primary key columns.
 Example
 select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
 */
select
  'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(
    quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
) '
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('
    select
      to_jsonb(% L :: '|| type_::text || ') ', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    /*
    Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
    */
    declare
      op_symbol text = (
        case
          when op = ' eq ' then ' = '
          when op = ' neq ' then ' != '
          when op = ' lt ' then ' < '
          when op = ' lte ' then ' <= '
          when op = ' gt ' then ' > '
          when op = ' gte ' then ' >= '
          else ' UNKNOWN OP '
        end
      );
      res boolean;
    begin
      execute format('
    select
      % L :: '|| type_::text || ' ' || op_symbol || ' % L :: '|| type_::text, val_1, val_2) into res;
      return res;
    end;
    $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
        /*
        Should the record be visible (true) or filtered out (false) after *filters* are applied
        */
            select
                -- Default to allowed when no filters present
                coalesce(
                    sum(
                        realtime.check_equality_op(
                            op:=f.op,
                            type_:=coalesce(
                                col.type_oid::regtype, -- null when wal2json version <= 2.4
                                col.type_name::regtype
                            ),
                            -- cast jsonb to text
                            val_1:=col.value #>> ' { } ',
                            val_2:=f.value
                        )::int
                    ) = count(1),
                    true
                )
            from
                unnest(filters) f
                join unnest(columns) col
                    on f.column_name = col.name;
        $$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = ' "')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '" '
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = ' "')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '" '
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
      col_names text[] = coalesce(
        array_agg(c.column_name order by c.ordinal_position),
        ' { } '::text[]
      )
      from
        information_schema.columns c
      where
        format(' % I.% I ', c.table_schema, c.table_name)::regclass = new.entity
        and pg_catalog.has_column_privilege(
          (new.claims ->> ' role '),
          format(' % I.% I ', c.table_schema, c.table_name)::regclass,
          c.column_name,
          '
    SELECT
      '
        );
      filter realtime.user_defined_filter;
      col_type regtype;
    begin
      for filter in select * from unnest(new.filters) loop
        -- Filtered column is valid
        if not filter.column_name = any(col_names) then
          raise exception ' invalid column for filter % ', filter.column_name;
        end if;

        -- Type is sanitized and safe for string interpolation
        col_type = (
          select atttypid::regtype
          from pg_catalog.pg_attribute
          where attrelid = new.entity
            and attname = filter.column_name
        );
        if col_type is null then
          raise exception ' failed to lookup type for column % ', filter.column_name;
        end if;
        -- raises an exception if value is not coercable to type
        perform realtime.cast(filter.value, col_type);
      end loop;

      -- Apply consistent order to filters so the unique constraint on
      -- (subscription_id, entity, filters) can' t be tricked by a different filter order new.filters = coalesce(
        array_agg(
          f
          order by
            f.column_name,
            f.op,
            f.value
        ),
        '{}'
      )
    from
      unnest(new.filters) f;

return new;

end;

$ $;

ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--
CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole LANGUAGE sql IMMUTABLE AS $ $
select
  role_name :: regrole $ $;

ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--
CREATE FUNCTION storage.extension(name text) RETURNS text LANGUAGE plpgsql AS $ $ DECLARE _parts text [];

_filename text;

BEGIN
select
  string_to_array(name, '/') into _parts;

select
  _parts [array_length(_parts,1)] into _filename;

-- @todo return the last part instead of 2
return split_part(_filename, '.', 2);

END $ $;

ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--
CREATE FUNCTION storage.filename(name text) RETURNS text LANGUAGE plpgsql AS $ $ DECLARE _parts text [];

BEGIN
select
  string_to_array(name, '/') into _parts;

return _parts [array_length(_parts,1)];

END $ $;

ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--
CREATE FUNCTION storage.foldername(name text) RETURNS text [] LANGUAGE plpgsql AS $ $ DECLARE _parts text [];

BEGIN
select
  string_to_array(name, '/') into _parts;

return _parts [1:array_length(_parts,1)-1];

END $ $;

ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--
CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text) LANGUAGE plpgsql AS $ $ BEGIN return query
select
  sum((metadata ->> 'size') :: int) as size,
  obj.bucket_id
from
  "storage".objects as obj
group by
  obj.bucket_id;

END $ $;

ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--
CREATE FUNCTION storage.search(
  prefix text,
  bucketname text,
  limits integer DEFAULT 100,
  levels integer DEFAULT 1,
  offsets integer DEFAULT 0,
  search text DEFAULT '' :: text,
  sortcolumn text DEFAULT 'name' :: text,
  sortorder text DEFAULT 'asc' :: text
) RETURNS TABLE(
  name text,
  id uuid,
  updated_at timestamp with time zone,
  created_at timestamp with time zone,
  last_accessed_at timestamp with time zone,
  metadata jsonb
) LANGUAGE plpgsql STABLE AS $ _ $ declare v_order_by text;

v_sort_order text;

begin case
  when sortcolumn = 'name' then v_order_by = 'name';

when sortcolumn = 'updated_at' then v_order_by = 'updated_at';

when sortcolumn = 'created_at' then v_order_by = 'created_at';

when sortcolumn = 'last_accessed_at' then v_order_by = 'last_accessed_at';

else v_order_by = 'name';

end case
;

case
  when sortorder = 'asc' then v_sort_order = 'asc';

when sortorder = 'desc' then v_sort_order = 'desc';

else v_sort_order = 'asc';

end case
;

v_order_by = v_order_by || ' ' || v_sort_order;

return query execute 'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels,
prefix,
search,
bucketname,
limits,
offsets;

end;

$ _ $;

ALTER FUNCTION storage.search(
  prefix text,
  bucketname text,
  limits integer,
  levels integer,
  offsets integer,
  search text,
  sortcolumn text,
  sortorder text
) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--
CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger LANGUAGE plpgsql AS $ $ BEGIN NEW.updated_at = now();

RETURN NEW;

END;

$ $;

ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--
CREATE FUNCTION supabase_functions.http_request() RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER
SET
  search_path TO 'supabase_functions' AS $ $ DECLARE request_id bigint;

payload jsonb;

url text := TG_ARGV [0] :: text;

method text := TG_ARGV [1] :: text;

headers jsonb DEFAULT '{}' :: jsonb;

params jsonb DEFAULT '{}' :: jsonb;

timeout_ms integer DEFAULT 1000;

BEGIN IF url IS NULL
OR url = 'null' THEN RAISE EXCEPTION 'url argument is missing';

END IF;

IF method IS NULL
OR method = 'null' THEN RAISE EXCEPTION 'method argument is missing';

END IF;

IF TG_ARGV [2] IS NULL
OR TG_ARGV [2] = 'null' THEN headers = '{"Content-Type": "application/json"}' :: jsonb;

ELSE headers = TG_ARGV [2] :: jsonb;

END IF;

IF TG_ARGV [3] IS NULL
OR TG_ARGV [3] = 'null' THEN params = '{}' :: jsonb;

ELSE params = TG_ARGV [3] :: jsonb;

END IF;

IF TG_ARGV [4] IS NULL
OR TG_ARGV [4] = 'null' THEN timeout_ms = 1000;

ELSE timeout_ms = TG_ARGV [4] :: integer;

END IF;

CASE
  WHEN method = 'GET' THEN
  SELECT
    http_get INTO request_id
  FROM
    net.http_get(
      url,
      params,
      headers,
      timeout_ms
    );

WHEN method = 'POST' THEN payload = jsonb_build_object(
  'old_record',
  OLD,
  'record',
  NEW,
  'type',
  TG_OP,
  'table',
  TG_TABLE_NAME,
  'schema',
  TG_TABLE_SCHEMA
);

SELECT
  http_post INTO request_id
FROM
  net.http_post(
    url,
    payload,
    params,
    headers,
    timeout_ms
  );

ELSE RAISE EXCEPTION 'method argument % is invalid',
method;

END CASE
;

INSERT INTO
  supabase_functions.hooks (hook_table_id, hook_name, request_id)
VALUES
  (TG_RELID, TG_NAME, request_id);

RETURN NEW;

END $ $;

ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET
  default_tablespace = '';

SET
  default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--
CREATE TABLE auth.audit_log_entries (
  instance_id uuid,
  id uuid NOT NULL,
  payload json,
  created_at timestamp with time zone,
  ip_address character varying(64) DEFAULT '' :: character varying NOT NULL
);

ALTER TABLE
  auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';

--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--
CREATE TABLE auth.identities (
  id text NOT NULL,
  user_id uuid NOT NULL,
  identity_data jsonb NOT NULL,
  provider text NOT NULL,
  last_sign_in_at timestamp with time zone,
  created_at timestamp with time zone,
  updated_at timestamp with time zone
);

ALTER TABLE
  auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';

--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--
CREATE TABLE auth.instances (
  id uuid NOT NULL,
  uuid uuid,
  raw_base_config text,
  created_at timestamp with time zone,
  updated_at timestamp with time zone
);

ALTER TABLE
  auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--
CREATE TABLE auth.refresh_tokens (
  instance_id uuid,
  id bigint NOT NULL,
  token character varying(255),
  user_id character varying(255),
  revoked boolean,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  parent character varying(255)
);

ALTER TABLE
  auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--
CREATE SEQUENCE auth.refresh_tokens_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE
  auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--
ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;

--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--
CREATE TABLE auth.schema_migrations (version character varying(255) NOT NULL);

ALTER TABLE
  auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';

--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--
CREATE TABLE auth.users (
  instance_id uuid,
  id uuid NOT NULL,
  aud character varying(255),
  role character varying(255),
  email character varying(255),
  encrypted_password character varying(255),
  email_confirmed_at timestamp with time zone,
  invited_at timestamp with time zone,
  confirmation_token character varying(255),
  confirmation_sent_at timestamp with time zone,
  recovery_token character varying(255),
  recovery_sent_at timestamp with time zone,
  email_change_token_new character varying(255),
  email_change character varying(255),
  email_change_sent_at timestamp with time zone,
  last_sign_in_at timestamp with time zone,
  raw_app_meta_data jsonb,
  raw_user_meta_data jsonb,
  is_super_admin boolean,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  phone character varying(15) DEFAULT NULL :: character varying,
  phone_confirmed_at timestamp with time zone,
  phone_change character varying(15) DEFAULT '' :: character varying,
  phone_change_token character varying(255) DEFAULT '' :: character varying,
  phone_change_sent_at timestamp with time zone,
  confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
  email_change_token_current character varying(255) DEFAULT '' :: character varying,
  email_change_confirm_status smallint DEFAULT 0,
  banned_until timestamp with time zone,
  reauthentication_token character varying(255) DEFAULT '' :: character varying,
  reauthentication_sent_at timestamp with time zone,
  CONSTRAINT users_email_change_confirm_status_check CHECK (
    (
      (email_change_confirm_status >= 0)
      AND (email_change_confirm_status <= 2)
    )
  )
);

ALTER TABLE
  auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--
COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';

--
-- Name: favorites; Type: TABLE; Schema: public; Owner: supabase_admin
--
CREATE TABLE public.favorites (
  "wishId" bigint NOT NULL,
  "userId" uuid NOT NULL,
  "wasAdded" timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc' :: text) NOT NULL
);

ALTER TABLE
  public.favorites OWNER TO supabase_admin;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: supabase_admin
--
CREATE TABLE public.subscriptions (
  id uuid NOT NULL,
  "subscriptionTo" uuid NOT NULL
);

ALTER TABLE
  public.subscriptions OWNER TO supabase_admin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: supabase_admin
--
CREATE TABLE public.users (
  email text,
  login text NOT NULL,
  "createdAt" timestamp with time zone,
  id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
  "imageUrl" text,
  "userColor" text
);

ALTER TABLE
  public.users OWNER TO supabase_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: supabase_admin
--
COMMENT ON TABLE public.users IS 'Table with users ';

--
-- Name: wish; Type: TABLE; Schema: public; Owner: supabase_admin
--
CREATE TABLE public.wish (
  id bigint NOT NULL,
  title character varying NOT NULL,
  description character varying,
  link character varying,
  "imageUrl" character varying,
  "createdAt" timestamp with time zone DEFAULT now(),
  "createdBy" uuid,
  "isFulfilled" boolean DEFAULT false
);

ALTER TABLE
  public.wish OWNER TO supabase_admin;

--
-- Name: wish_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  public.wish
ALTER COLUMN
  id
ADD
  GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.wish_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
  );

--
-- Name: wishes_view; Type: VIEW; Schema: public; Owner: supabase_admin
--
CREATE VIEW public.wishes_view AS
SELECT
  w.id,
  w.title,
  w.description,
  w.link,
  w."imageUrl",
  w."createdAt",
  w."isFulfilled",
  jsonb_build_object(
    'id',
    w."createdBy",
    'login',
    u.login,
    'imageUrl',
    u."imageUrl",
    'userColor',
    u."userColor"
  ) AS "createdBy"
FROM
  (
    public.wish w
    JOIN public.users u ON ((w."createdBy" = u.id))
  )
ORDER BY
  w."createdAt" DESC;

ALTER TABLE
  public.wishes_view OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--
CREATE TABLE realtime.schema_migrations (
  version bigint NOT NULL,
  inserted_at timestamp(0) without time zone
);

ALTER TABLE
  realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--
CREATE TABLE realtime.subscription (
  id bigint NOT NULL,
  subscription_id uuid NOT NULL,
  entity regclass NOT NULL,
  filters realtime.user_defined_filter [] DEFAULT '{}' :: realtime.user_defined_filter [] NOT NULL,
  claims jsonb NOT NULL,
  claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role' :: text))) STORED NOT NULL,
  created_at timestamp without time zone DEFAULT timezone('utc' :: text, now()) NOT NULL
);

ALTER TABLE
  realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--
ALTER TABLE
  realtime.subscription
ALTER COLUMN
  id
ADD
  GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
  );

--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--
CREATE TABLE storage.buckets (
  id text NOT NULL,
  name text NOT NULL,
  owner uuid,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  public boolean DEFAULT false
);

ALTER TABLE
  storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--
CREATE TABLE storage.migrations (
  id integer NOT NULL,
  name character varying(100) NOT NULL,
  hash character varying(40) NOT NULL,
  executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE
  storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--
CREATE TABLE storage.objects (
  id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
  bucket_id text,
  name text,
  owner uuid,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  last_accessed_at timestamp with time zone DEFAULT now(),
  metadata jsonb,
  path_tokens text [] GENERATED ALWAYS AS (string_to_array(name, '/' :: text)) STORED
);

ALTER TABLE
  storage.objects OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--
CREATE TABLE supabase_functions.hooks (
  id bigint NOT NULL,
  hook_table_id integer NOT NULL,
  hook_name text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  request_id bigint
);

ALTER TABLE
  supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--
COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';

--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--
CREATE SEQUENCE supabase_functions.hooks_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE
  supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--
ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;

--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--
CREATE TABLE supabase_functions.migrations (
  version text NOT NULL,
  inserted_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE
  supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.refresh_tokens
ALTER COLUMN
  id
SET
  DEFAULT nextval('auth.refresh_tokens_id_seq' :: regclass);

--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--
ALTER TABLE
  ONLY supabase_functions.hooks
ALTER COLUMN
  id
SET
  DEFAULT nextval('supabase_functions.hooks_id_seq' :: regclass);

--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.audit_log_entries
ADD
  CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);

--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.identities
ADD
  CONSTRAINT identities_pkey PRIMARY KEY (provider, id);

--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.instances
ADD
  CONSTRAINT instances_pkey PRIMARY KEY (id);

--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.refresh_tokens
ADD
  CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);

--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.refresh_tokens
ADD
  CONSTRAINT refresh_tokens_token_unique UNIQUE (token);

--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.schema_migrations
ADD
  CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.users
ADD
  CONSTRAINT users_email_key UNIQUE (email);

--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.users
ADD
  CONSTRAINT users_phone_key UNIQUE (phone);

--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.users
ADD
  CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.favorites
ADD
  CONSTRAINT favorites_pkey PRIMARY KEY ("userId", "wishId");

--
-- Name: favorites favorites_wishId_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.favorites
ADD
  CONSTRAINT "favorites_wishId_key" UNIQUE ("wishId");

--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.subscriptions
ADD
  CONSTRAINT subscriptions_pkey PRIMARY KEY (id, "subscriptionTo");

--
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.users
ADD
  CONSTRAINT users_login_key UNIQUE (login);

--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.users
ADD
  CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Name: wish wish_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.wish
ADD
  CONSTRAINT wish_pkey PRIMARY KEY (id);

--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--
ALTER TABLE
  ONLY realtime.subscription
ADD
  CONSTRAINT pk_subscription PRIMARY KEY (id);

--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--
ALTER TABLE
  ONLY realtime.schema_migrations
ADD
  CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.buckets
ADD
  CONSTRAINT buckets_pkey PRIMARY KEY (id);

--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.migrations
ADD
  CONSTRAINT migrations_name_key UNIQUE (name);

--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.migrations
ADD
  CONSTRAINT migrations_pkey PRIMARY KEY (id);

--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.objects
ADD
  CONSTRAINT objects_pkey PRIMARY KEY (id);

--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--
ALTER TABLE
  ONLY supabase_functions.hooks
ADD
  CONSTRAINT hooks_pkey PRIMARY KEY (id);

--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--
ALTER TABLE
  ONLY supabase_functions.migrations
ADD
  CONSTRAINT migrations_pkey PRIMARY KEY (version);

--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);

--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token)
WHERE
  (
    (confirmation_token) :: text !~ '^[0-9 ]*$' :: text
  );

--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current)
WHERE
  (
    (email_change_token_current) :: text !~ '^[0-9 ]*$' :: text
  );

--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new)
WHERE
  (
    (email_change_token_new) :: text !~ '^[0-9 ]*$' :: text
  );

--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);

--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token)
WHERE
  (
    (reauthentication_token) :: text !~ '^[0-9 ]*$' :: text
  );

--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token)
WHERE
  ((recovery_token) :: text !~ '^[0-9 ]*$' :: text);

--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);

--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);

--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);

--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);

--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email) :: text));

--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--
CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);

--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--
CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING hash (entity);

--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--
CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);

--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--
CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);

--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--
CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);

--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--
CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);

--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--
CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);

--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--
CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);

--
-- Name: wish trigger_wish_delete_after; Type: TRIGGER; Schema: public; Owner: supabase_admin
--
CREATE TRIGGER trigger_wish_delete_after BEFORE DELETE ON public.wish FOR EACH ROW EXECUTE FUNCTION public.trigger_wish_delete_after();

--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--
CREATE TRIGGER tr_check_filters BEFORE
INSERT
  OR
UPDATE
  ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();

--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--
CREATE TRIGGER update_objects_updated_at BEFORE
UPDATE
  ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();

--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.identities
ADD
  CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

--
-- Name: refresh_tokens refresh_tokens_parent_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--
ALTER TABLE
  ONLY auth.refresh_tokens
ADD
  CONSTRAINT refresh_tokens_parent_fkey FOREIGN KEY (parent) REFERENCES auth.refresh_tokens(token);

--
-- Name: subscriptions subscriptions_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.subscriptions
ADD
  CONSTRAINT subscriptions_id_fkey FOREIGN KEY (id) REFERENCES public.users(id);

--
-- Name: wish wish_createdBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
--
ALTER TABLE
  ONLY public.wish
ADD
  CONSTRAINT "wish_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES public.users(id);

--
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.buckets
ADD
  CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);

--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.objects
ADD
  CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);

--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  ONLY storage.objects
ADD
  CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);

--
-- Name: hooks hooks_request_id_fkey; Type: FK CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--
ALTER TABLE
  ONLY supabase_functions.hooks
ADD
  CONSTRAINT hooks_request_id_fkey FOREIGN KEY (request_id) REFERENCES net.http_request_queue(id) ON DELETE CASCADE;

--
-- Name: wish Enable access to all users; Type: POLICY; Schema: public; Owner: supabase_admin
--
CREATE POLICY "Enable access to all users" ON public.wish FOR
SELECT
  USING (true);

--
-- Name: users Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: supabase_admin
--
CREATE POLICY "Enable insert for authenticated users only" ON public.users FOR
INSERT
  WITH CHECK ((auth.role() = 'authenticated' :: text));

--
-- Name: users Enable update for users based on email; Type: POLICY; Schema: public; Owner: supabase_admin
--
CREATE POLICY "Enable update for users based on email" ON public.users FOR
INSERT
  WITH CHECK ((auth.email() = email));

--
-- Name: objects Enable access to all users; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--
CREATE POLICY "Enable access to all users" ON storage.objects FOR
SELECT
  USING (true);

--
-- Name: objects Enable delete for users; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--
CREATE POLICY "Enable delete for users" ON storage.objects FOR DELETE TO authenticated USING (true);

--
-- Name: objects Enable insert for authenticated users only; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--
CREATE POLICY "Enable insert for authenticated users only" ON storage.objects USING ((auth.role() = 'authenticated' :: text));

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--
ALTER TABLE
  storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: objects update; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--
CREATE POLICY
update
  ON storage.objects FOR
UPDATE
  TO authenticated USING (true) WITH CHECK (true);

--
-- Name: objects update wish.app.bucket z4fyta_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--
CREATE POLICY "update wish.app.bucket z4fyta_0" ON storage.objects FOR
UPDATE
  TO authenticated USING (true);

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--
CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');

ALTER PUBLICATION supabase_realtime OWNER TO supabase_admin;

--
-- Name: supabase_realtime favorites; Type: PUBLICATION TABLE; Schema: public; Owner: supabase_admin
--
ALTER PUBLICATION supabase_realtime
ADD
  TABLE ONLY public.favorites;

--
-- Name: supabase_realtime wish; Type: PUBLICATION TABLE; Schema: public; Owner: supabase_admin
--
ALTER PUBLICATION supabase_realtime
ADD
  TABLE ONLY public.wish;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--
GRANT USAGE ON SCHEMA auth TO anon;

GRANT USAGE ON SCHEMA auth TO authenticated;

GRANT USAGE ON SCHEMA auth TO service_role;

GRANT ALL ON SCHEMA auth TO supabase_auth_admin;

GRANT ALL ON SCHEMA auth TO dashboard_user;

GRANT ALL ON SCHEMA auth TO postgres;

--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--
GRANT USAGE ON SCHEMA extensions TO anon;

GRANT USAGE ON SCHEMA extensions TO authenticated;

GRANT USAGE ON SCHEMA extensions TO service_role;

GRANT ALL ON SCHEMA extensions TO dashboard_user;

--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--
GRANT USAGE ON SCHEMA graphql_public TO postgres;

GRANT USAGE ON SCHEMA graphql_public TO anon;

GRANT USAGE ON SCHEMA graphql_public TO authenticated;

GRANT USAGE ON SCHEMA graphql_public TO service_role;

--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--
GRANT USAGE ON SCHEMA net TO supabase_functions_admin;

GRANT USAGE ON SCHEMA net TO anon;

GRANT USAGE ON SCHEMA net TO authenticated;

GRANT USAGE ON SCHEMA net TO service_role;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--
GRANT USAGE ON SCHEMA public TO anon;

GRANT USAGE ON SCHEMA public TO authenticated;

GRANT USAGE ON SCHEMA public TO service_role;

--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--
GRANT USAGE ON SCHEMA realtime TO postgres;

--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--
GRANT ALL ON SCHEMA storage TO postgres;

GRANT USAGE ON SCHEMA storage TO anon;

GRANT USAGE ON SCHEMA storage TO authenticated;

GRANT USAGE ON SCHEMA storage TO service_role;

GRANT ALL ON SCHEMA storage TO supabase_storage_admin;

GRANT ALL ON SCHEMA storage TO dashboard_user;

--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;

GRANT USAGE ON SCHEMA supabase_functions TO postgres;

GRANT USAGE ON SCHEMA supabase_functions TO anon;

GRANT USAGE ON SCHEMA supabase_functions TO authenticated;

GRANT USAGE ON SCHEMA supabase_functions TO service_role;

--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON FUNCTION auth.email() TO dashboard_user;

GRANT ALL ON FUNCTION auth.email() TO postgres;

--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON FUNCTION auth.jwt() TO postgres;

GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;

--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON FUNCTION auth.role() TO dashboard_user;

GRANT ALL ON FUNCTION auth.role() TO postgres;

--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;

GRANT ALL ON FUNCTION auth.uid() TO postgres;

--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;

--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;

--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.armor(bytea, text [], text []) TO dashboard_user;

--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;

--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;

--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;

--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;

--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;

--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;

--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;

--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;

--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;

--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;

--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pg_stat_statements(
  showtext boolean,
  OUT userid oid,
  OUT dbid oid,
  OUT toplevel boolean,
  OUT queryid bigint,
  OUT query text,
  OUT plans bigint,
  OUT total_plan_time double precision,
  OUT min_plan_time double precision,
  OUT max_plan_time double precision,
  OUT mean_plan_time double precision,
  OUT stddev_plan_time double precision,
  OUT calls bigint,
  OUT total_exec_time double precision,
  OUT min_exec_time double precision,
  OUT max_exec_time double precision,
  OUT mean_exec_time double precision,
  OUT stddev_exec_time double precision,
  OUT rows bigint,
  OUT shared_blks_hit bigint,
  OUT shared_blks_read bigint,
  OUT shared_blks_dirtied bigint,
  OUT shared_blks_written bigint,
  OUT local_blks_hit bigint,
  OUT local_blks_read bigint,
  OUT local_blks_dirtied bigint,
  OUT local_blks_written bigint,
  OUT temp_blks_read bigint,
  OUT temp_blks_written bigint,
  OUT blk_read_time double precision,
  OUT blk_write_time double precision,
  OUT wal_records bigint,
  OUT wal_fpi bigint,
  OUT wal_bytes numeric
) TO dashboard_user;

--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(
  OUT dealloc bigint,
  OUT stats_reset timestamp with time zone
) TO dashboard_user;

--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;

--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;

--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;

--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;

--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;

--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;

--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;

--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;

--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;

--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;

--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;

--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;

--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;

--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;

--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;

--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;

--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;

--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;

--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;

--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;

--
-- Name: FUNCTION get_built_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO postgres;

GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO anon;

GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO authenticated;

GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO service_role;

--
-- Name: FUNCTION rebuild_on_ddl(); Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO postgres;

GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO anon;

GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO authenticated;

GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO service_role;

--
-- Name: FUNCTION rebuild_on_drop(); Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO postgres;

GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO anon;

GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO authenticated;

GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO service_role;

--
-- Name: FUNCTION rebuild_schema(); Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON FUNCTION graphql.rebuild_schema() TO postgres;

GRANT ALL ON FUNCTION graphql.rebuild_schema() TO anon;

GRANT ALL ON FUNCTION graphql.rebuild_schema() TO authenticated;

GRANT ALL ON FUNCTION graphql.rebuild_schema() TO service_role;

--
-- Name: FUNCTION variable_definitions_sort(variable_definitions jsonb); Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO postgres;

GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO anon;

GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO authenticated;

GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO service_role;

--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION graphql_public.graphql(
  "operationName" text,
  query text,
  variables jsonb,
  extensions jsonb
) TO postgres;

GRANT ALL ON FUNCTION graphql_public.graphql(
  "operationName" text,
  query text,
  variables jsonb,
  extensions jsonb
) TO anon;

GRANT ALL ON FUNCTION graphql_public.graphql(
  "operationName" text,
  query text,
  variables jsonb,
  extensions jsonb
) TO authenticated;

GRANT ALL ON FUNCTION graphql_public.graphql(
  "operationName" text,
  query text,
  variables jsonb,
  extensions jsonb
) TO service_role;

--
-- Name: FUNCTION http_collect_response(request_id bigint, async boolean); Type: ACL; Schema: net; Owner: supabase_admin
--
REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean)
FROM
  PUBLIC;

GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin;

GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO postgres;

GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO anon;

GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO authenticated;

GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO service_role;

--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--
REVOKE ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
)
FROM
  PUBLIC;

GRANT ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO supabase_functions_admin;

GRANT ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO postgres;

GRANT ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO anon;

GRANT ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO authenticated;

GRANT ALL ON FUNCTION net.http_get(
  url text,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO service_role;

--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--
REVOKE ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
)
FROM
  PUBLIC;

GRANT ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO supabase_functions_admin;

GRANT ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO postgres;

GRANT ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO anon;

GRANT ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO authenticated;

GRANT ALL ON FUNCTION net.http_post(
  url text,
  body jsonb,
  params jsonb,
  headers jsonb,
  timeout_milliseconds integer
) TO service_role;

--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--
REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text)
FROM
  PUBLIC;

GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;

--
-- Name: FUNCTION check_if_user_exist(in_login text, in_email text); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO postgres;

GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO anon;

GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO authenticated;

GRANT ALL ON FUNCTION public.check_if_user_exist(in_login text, in_email text) TO service_role;

--
-- Name: FUNCTION check_subscription(in_current_user_id text, in_another_user_id text); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.check_subscription(in_current_user_id text, in_another_user_id text) TO postgres;

GRANT ALL ON FUNCTION public.check_subscription(in_current_user_id text, in_another_user_id text) TO anon;

GRANT ALL ON FUNCTION public.check_subscription(in_current_user_id text, in_another_user_id text) TO authenticated;

GRANT ALL ON FUNCTION public.check_subscription(in_current_user_id text, in_another_user_id text) TO service_role;

--
-- Name: FUNCTION count_of_favorites(in_user_id character varying); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.count_of_favorites(in_user_id character varying) TO postgres;

GRANT ALL ON FUNCTION public.count_of_favorites(in_user_id character varying) TO anon;

GRANT ALL ON FUNCTION public.count_of_favorites(in_user_id character varying) TO authenticated;

GRANT ALL ON FUNCTION public.count_of_favorites(in_user_id character varying) TO service_role;

--
-- Name: FUNCTION count_of_wish_in_subscriptions(user_id character varying); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.count_of_wish_in_subscriptions(user_id character varying) TO postgres;

GRANT ALL ON FUNCTION public.count_of_wish_in_subscriptions(user_id character varying) TO anon;

GRANT ALL ON FUNCTION public.count_of_wish_in_subscriptions(user_id character varying) TO authenticated;

GRANT ALL ON FUNCTION public.count_of_wish_in_subscriptions(user_id character varying) TO service_role;

--
-- Name: FUNCTION get_added_favorite_wish(in_wish_id integer, in_user_id text); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.get_added_favorite_wish(in_wish_id integer, in_user_id text) TO postgres;

GRANT ALL ON FUNCTION public.get_added_favorite_wish(in_wish_id integer, in_user_id text) TO anon;

GRANT ALL ON FUNCTION public.get_added_favorite_wish(in_wish_id integer, in_user_id text) TO authenticated;

GRANT ALL ON FUNCTION public.get_added_favorite_wish(in_wish_id integer, in_user_id text) TO service_role;

--
-- Name: FUNCTION info_user(in_user_id text); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.info_user(in_user_id text) TO postgres;

GRANT ALL ON FUNCTION public.info_user(in_user_id text) TO anon;

GRANT ALL ON FUNCTION public.info_user(in_user_id text) TO authenticated;

GRANT ALL ON FUNCTION public.info_user(in_user_id text) TO service_role;

--
-- Name: FUNCTION search_light_user_list(in_query text, in_user_id text, in_limit integer); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.search_light_user_list(in_query text, in_user_id text, in_limit integer) TO postgres;

GRANT ALL ON FUNCTION public.search_light_user_list(in_query text, in_user_id text, in_limit integer) TO anon;

GRANT ALL ON FUNCTION public.search_light_user_list(in_query text, in_user_id text, in_limit integer) TO authenticated;

GRANT ALL ON FUNCTION public.search_light_user_list(in_query text, in_user_id text, in_limit integer) TO service_role;

--
-- Name: FUNCTION search_light_wish_list(in_query text, in_limit integer); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.search_light_wish_list(in_query text, in_limit integer) TO postgres;

GRANT ALL ON FUNCTION public.search_light_wish_list(in_query text, in_limit integer) TO anon;

GRANT ALL ON FUNCTION public.search_light_wish_list(in_query text, in_limit integer) TO authenticated;

GRANT ALL ON FUNCTION public.search_light_wish_list(in_query text, in_limit integer) TO service_role;

--
-- Name: FUNCTION select_favorite_wish_list(in_user_id character varying, in_limit integer, in_offset integer); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.select_favorite_wish_list(
  in_user_id character varying,
  in_limit integer,
  in_offset integer
) TO postgres;

GRANT ALL ON FUNCTION public.select_favorite_wish_list(
  in_user_id character varying,
  in_limit integer,
  in_offset integer
) TO anon;

GRANT ALL ON FUNCTION public.select_favorite_wish_list(
  in_user_id character varying,
  in_limit integer,
  in_offset integer
) TO authenticated;

GRANT ALL ON FUNCTION public.select_favorite_wish_list(
  in_user_id character varying,
  in_limit integer,
  in_offset integer
) TO service_role;

--
-- Name: FUNCTION select_user_wish_list(in_user_id character varying, "limit" integer, "offset" integer); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.select_user_wish_list(
  in_user_id character varying,
  "limit" integer,
  "offset" integer
) TO postgres;

GRANT ALL ON FUNCTION public.select_user_wish_list(
  in_user_id character varying,
  "limit" integer,
  "offset" integer
) TO anon;

GRANT ALL ON FUNCTION public.select_user_wish_list(
  in_user_id character varying,
  "limit" integer,
  "offset" integer
) TO authenticated;

GRANT ALL ON FUNCTION public.select_user_wish_list(
  in_user_id character varying,
  "limit" integer,
  "offset" integer
) TO service_role;

--
-- Name: FUNCTION select_wish_list(user_id character varying, "limit" integer, "offset" integer); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.select_wish_list(
  user_id character varying,
  "limit" integer,
  "offset" integer
) TO postgres;

GRANT ALL ON FUNCTION public.select_wish_list(
  user_id character varying,
  "limit" integer,
  "offset" integer
) TO anon;

GRANT ALL ON FUNCTION public.select_wish_list(
  user_id character varying,
  "limit" integer,
  "offset" integer
) TO authenticated;

GRANT ALL ON FUNCTION public.select_wish_list(
  user_id character varying,
  "limit" integer,
  "offset" integer
) TO service_role;

--
-- Name: FUNCTION test_function_table(); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.test_function_table() TO postgres;

GRANT ALL ON FUNCTION public.test_function_table() TO anon;

GRANT ALL ON FUNCTION public.test_function_table() TO authenticated;

GRANT ALL ON FUNCTION public.test_function_table() TO service_role;

--
-- Name: FUNCTION toggle_favorite(in_user_id text, in_wish_id integer); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.toggle_favorite(in_user_id text, in_wish_id integer) TO postgres;

GRANT ALL ON FUNCTION public.toggle_favorite(in_user_id text, in_wish_id integer) TO anon;

GRANT ALL ON FUNCTION public.toggle_favorite(in_user_id text, in_wish_id integer) TO authenticated;

GRANT ALL ON FUNCTION public.toggle_favorite(in_user_id text, in_wish_id integer) TO service_role;

--
-- Name: FUNCTION toggle_subscription(in_current_user_id text, in_another_user_id text); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.toggle_subscription(in_current_user_id text, in_another_user_id text) TO postgres;

GRANT ALL ON FUNCTION public.toggle_subscription(in_current_user_id text, in_another_user_id text) TO anon;

GRANT ALL ON FUNCTION public.toggle_subscription(in_current_user_id text, in_another_user_id text) TO authenticated;

GRANT ALL ON FUNCTION public.toggle_subscription(in_current_user_id text, in_another_user_id text) TO service_role;

--
-- Name: FUNCTION trigger_wish_delete_after(); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.trigger_wish_delete_after() TO postgres;

GRANT ALL ON FUNCTION public.trigger_wish_delete_after() TO anon;

GRANT ALL ON FUNCTION public.trigger_wish_delete_after() TO authenticated;

GRANT ALL ON FUNCTION public.trigger_wish_delete_after() TO service_role;

--
-- Name: FUNCTION varchar_to_uuid(value_varchar text); Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON FUNCTION public.varchar_to_uuid(value_varchar text) TO postgres;

GRANT ALL ON FUNCTION public.varchar_to_uuid(value_varchar text) TO anon;

GRANT ALL ON FUNCTION public.varchar_to_uuid(value_varchar text) TO authenticated;

GRANT ALL ON FUNCTION public.varchar_to_uuid(value_varchar text) TO service_role;

--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;

--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(
  prepared_statement_name text,
  entity regclass,
  columns realtime.wal_column []
) TO postgres;

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(
  prepared_statement_name text,
  entity regclass,
  columns realtime.wal_column []
) TO dashboard_user;

--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;

--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.check_equality_op(
  op realtime.equality_op,
  type_ regtype,
  val_1 text,
  val_2 text
) TO postgres;

GRANT ALL ON FUNCTION realtime.check_equality_op(
  op realtime.equality_op,
  type_ regtype,
  val_1 text,
  val_2 text
) TO dashboard_user;

--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(
  columns realtime.wal_column [],
  filters realtime.user_defined_filter []
) TO postgres;

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(
  columns realtime.wal_column [],
  filters realtime.user_defined_filter []
) TO dashboard_user;

--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;

--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;

--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;

--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--
GRANT ALL ON FUNCTION storage.extension(name text) TO anon;

GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;

GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;

GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;

GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;

--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--
GRANT ALL ON FUNCTION storage.filename(name text) TO anon;

GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;

GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;

GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;

GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;

--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--
GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;

GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;

GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;

GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;

GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;

--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--
REVOKE ALL ON FUNCTION supabase_functions.http_request()
FROM
  PUBLIC;

GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;

GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;

GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;

GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;

--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;

GRANT ALL ON TABLE auth.audit_log_entries TO postgres;

--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON TABLE auth.identities TO postgres;

GRANT ALL ON TABLE auth.identities TO dashboard_user;

--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON TABLE auth.instances TO dashboard_user;

GRANT ALL ON TABLE auth.instances TO postgres;

--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;

GRANT ALL ON TABLE auth.refresh_tokens TO postgres;

--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;

--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;

GRANT ALL ON TABLE auth.schema_migrations TO postgres;

--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--
GRANT ALL ON TABLE auth.users TO dashboard_user;

GRANT ALL ON TABLE auth.users TO postgres;

--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;

--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;

--
-- Name: TABLE schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON TABLE graphql.schema_version TO postgres;

GRANT ALL ON TABLE graphql.schema_version TO anon;

GRANT ALL ON TABLE graphql.schema_version TO authenticated;

GRANT ALL ON TABLE graphql.schema_version TO service_role;

--
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;

--
-- Name: TABLE favorites; Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON TABLE public.favorites TO postgres;

GRANT ALL ON TABLE public.favorites TO anon;

GRANT ALL ON TABLE public.favorites TO authenticated;

GRANT ALL ON TABLE public.favorites TO service_role;

--
-- Name: TABLE subscriptions; Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON TABLE public.subscriptions TO postgres;

GRANT ALL ON TABLE public.subscriptions TO anon;

GRANT ALL ON TABLE public.subscriptions TO authenticated;

GRANT ALL ON TABLE public.subscriptions TO service_role;

--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON TABLE public.users TO postgres;

GRANT ALL ON TABLE public.users TO anon;

GRANT ALL ON TABLE public.users TO authenticated;

GRANT ALL ON TABLE public.users TO service_role;

--
-- Name: TABLE wish; Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON TABLE public.wish TO postgres;

GRANT ALL ON TABLE public.wish TO anon;

GRANT ALL ON TABLE public.wish TO authenticated;

GRANT ALL ON TABLE public.wish TO service_role;

--
-- Name: SEQUENCE wish_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON SEQUENCE public.wish_id_seq TO postgres;

GRANT ALL ON SEQUENCE public.wish_id_seq TO anon;

GRANT ALL ON SEQUENCE public.wish_id_seq TO authenticated;

GRANT ALL ON SEQUENCE public.wish_id_seq TO service_role;

--
-- Name: TABLE wishes_view; Type: ACL; Schema: public; Owner: supabase_admin
--
GRANT ALL ON TABLE public.wishes_view TO postgres;

GRANT ALL ON TABLE public.wishes_view TO anon;

GRANT ALL ON TABLE public.wishes_view TO authenticated;

GRANT ALL ON TABLE public.wishes_view TO service_role;

--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON TABLE realtime.schema_migrations TO postgres;

GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;

--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON TABLE realtime.subscription TO postgres;

GRANT ALL ON TABLE realtime.subscription TO dashboard_user;

--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;

--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--
GRANT ALL ON TABLE storage.buckets TO anon;

GRANT ALL ON TABLE storage.buckets TO authenticated;

GRANT ALL ON TABLE storage.buckets TO service_role;

GRANT ALL ON TABLE storage.buckets TO postgres;

--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--
GRANT ALL ON TABLE storage.migrations TO anon;

GRANT ALL ON TABLE storage.migrations TO authenticated;

GRANT ALL ON TABLE storage.migrations TO service_role;

GRANT ALL ON TABLE storage.migrations TO postgres;

--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--
GRANT ALL ON TABLE storage.objects TO anon;

GRANT ALL ON TABLE storage.objects TO authenticated;

GRANT ALL ON TABLE storage.objects TO service_role;

GRANT ALL ON TABLE storage.objects TO postgres;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;

--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--
CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
WHEN TAG IN ('DROP EXTENSION') EXECUTE FUNCTION extensions.set_graphql_placeholder();

ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--
CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
WHEN TAG IN ('CREATE SCHEMA') EXECUTE FUNCTION extensions.grant_pg_cron_access();

ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--
CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
WHEN TAG IN ('CREATE FUNCTION') EXECUTE FUNCTION extensions.grant_pg_graphql_access();

ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--
CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
WHEN TAG IN ('CREATE EXTENSION') EXECUTE FUNCTION extensions.grant_pg_net_access();

ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--
CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end EXECUTE FUNCTION extensions.pgrst_ddl_watch();

ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--
CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop EXECUTE FUNCTION extensions.pgrst_drop_watch();

ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--