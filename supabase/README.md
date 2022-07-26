# Supabase configs and set up

## Content table

- [Supabase configs and set up](#supabase-configs-and-set-up)
  - [Content table](#content-table)
  - [Tables](#tables)
    - [**favorites**](#favorites)
    - [**subscriptions**](#subscriptions)
    - [**users**](#users)
    - [**wish**](#wish)
  - [Authentication](#authentication)
    - [Authentication > Settings > General settings:](#authentication--settings--general-settings)
    - [Authentication > Settings > Auth Providers:](#authentication--settings--auth-providers)
  - [Storage](#storage)
    - [Policies](#policies)
  - [SQL Editor](#sql-editor)
    - [Functions (as backend api)](#functions-as-backend-api)
      - [**check_if_user_exist code**](#check_if_user_exist-code)
      - [**check_subscription**](#check_subscription)
      - [**count_of_favorites**](#count_of_favorites)
      - [**count_of_wish_in_subscriptions**](#count_of_wish_in_subscriptions)
      - [**get_added_favorite_wish**](#get_added_favorite_wish)
      - [**info_user**](#info_user)
      - [**search_ligth_user_list**](#search_ligth_user_list)
      - [**search_ligth_wish_list**](#search_ligth_wish_list)
      - [**select_favorite_wish_list**](#select_favorite_wish_list)
      - [**select_user_wish_list**](#select_user_wish_list)
      - [**select_wish_list**](#select_wish_list)
      - [**toggle_favorite**](#toggle_favorite)
      - [**toggle_subscription**](#toggle_subscription)
    - [Triggers](#triggers)
      - [**trigger_wish_delete_after**](#trigger_wish_delete_after)
    - [Views](#views)
      - [**wishes_view**](#wishes_view)

## Tables

### **favorites**

    CREATE TABLE public.favorites (
        "wishId" bigint NOT NULL,
        "userId" uuid NOT NULL,
        "wasAdded" timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc' :: text) NOT NULL
    );

    ALTER TABLE
    ONLY public.favorites
    ADD
    CONSTRAINT favorites_pkey PRIMARY KEY ("userId", "wishId");

### **subscriptions**

    CREATE TABLE public.subscriptions (
        id uuid NOT NULL,
        "subscriptionTo" uuid NOT NULL
    );

    ALTER TABLE
    ONLY public.subscriptions
    ADD
    CONSTRAINT subscriptions_pkey PRIMARY KEY (id, "subscriptionTo");

### **users**

    CREATE TABLE public.users (
        email text,
        login text NOT NULL,
        "createdAt" timestamp with time zone,
        id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
        "imageUrl" text,
        "userColor" text
    );

    ALTER TABLE
    ONLY public.users
    ADD
    CONSTRAINT users_pkey PRIMARY KEY (id);

### **wish**

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
    ONLY public.wish
    ADD
    CONSTRAINT wish_pkey PRIMARY KEY (id);


## Authentication


### Authentication > Settings > General settings:
- Switch on: User Signups

### Authentication > Settings > Auth Providers:
- Switch on: Email


## Storage
- Create bucket: wish.app.bucket

### Policies
- Other policies under storage.objects: create select, delete, update with expression "true" (Yes, no guard for MVP app). For all setexpression (role() = 'authenticated'::text)


## SQL Editor 

### Functions (as backend api)

#### **check_if_user_exist code**
    
    CREATE TYPE public.result_type_check_if_user_exist AS (
        result_login boolean,
        result_email boolean
    );

    CREATE FUNCTION public.check_if_user_exist(in_login text, in_email text) RETURNS public.result_type_check_if_user_exist LANGUAGE plpgsql AS $ $ DECLARE;
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



#### **check_subscription**
    
    CREATE TYPE public.result_check_subscription AS (
        has_subscribe boolean,
        has_subscription boolean
    );

    CREATE FUNCTION public.check_subscription(
        in_current_user_id text, 
        in_another_user_id text
    ) RETURNS public.result_check_subscription LANGUAGE plpgsql 
    AS $ $ 
    DECLARE result_record result_check_subscription;
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

#### **count_of_favorites**

    CREATE FUNCTION public.count_of_favorites(
    in_user_id character varying DEFAULT NULL :: character varying
    ) RETURNS integer LANGUAGE plpgsql 
    AS $ $ BEGIN IF in_user_id IS NOT NULL THEN RETURN (
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

#### **count_of_wish_in_subscriptions**

    CREATE FUNCTION public.count_of_wish_in_subscriptions(
    user_id character varying DEFAULT NULL :: character varying
    ) RETURNS integer LANGUAGE plpgsql AS $ $ 
    BEGIN IF user_id IS NOT NULL THEN RETURN (
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


#### **get_added_favorite_wish**

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

    CREATE FUNCTION public.get_added_favorite_wish(
        in_wish_id integer, 
        in_user_id text
    ) 
    RETURNS public._result_added_favorite_wish LANGUAGE plpgsql 
    AS $ $ DECLARE out_result _result_added_favorite_wish DEFAULT NULL;

    BEGIN
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
    ) into out_result
    FROM
    wish as W
    JOIN users AS U on W."createdBy" = U."id"
    JOIN favorites AS F ON F."wishId" = W."id"
    AND F."userId" = in_user_id :: uuid
    AND F."wishId" = in_wish_id;
    IF out_result IS NULL THEN RAISE EXCEPTION 'No data.';
    END IF;
    RETURN out_result;
    END;
    $ $;

#### **info_user**

    CREATE TYPE public.result_info_user AS (
        count_of_wishes integer,
        count_of_subscribers integer,
        count_of_subscribing integer
    );

    CREATE FUNCTION public.info_user(in_user_id text) 
    RETURNS public.result_info_user LANGUAGE plpgsql 
    AS $ $ 
    DECLARE result_record result_info_user;
    BEGIN
    SELECT
    (
        SELECT
        count(W."id")
        FROM
        wish as W
        WHERE
        W."createdBy" = in_user_id :: uuid
    ) INTO result_record.count_of_wishes;
    SELECT
    (
        SELECT
        count(S.id)
        FROM
        subscriptions as S
        WHERE
        S."id" = in_user_id :: uuid
        AND S."subscriptionTo" != in_user_id :: uuid
    ) INTO result_record.count_of_subscribing;

    SELECT
    (
        SELECT
        count(S.id)
        FROM
        subscriptions as S
        WHERE
        S."subscriptionTo" = in_user_id :: uuid
        AND S."id" != in_user_id :: uuid
    ) INTO result_record.count_of_subscribers;
    RETURN result_record;
    END;
    $ $;

#### **search_ligth_user_list**

    DROP FUNCTION IF EXISTS search_light_user_list;
    CREATE 
    OR replace FUNCTION 
    search_light_user_list( 
        "in_query" text, 
        "in_user_id" text DEFAULT NULL, 
        "in_limit" INT DEFAULT 10 
    ) 
    RETURNS TABLE( 
        "id" uuid, 
        "login" text, 
        "imageUrl" text, 
        "userColor" text 
    ) AS $$ 
    BEGIN
    IF "in_user_id" IS NOT NULL 
    THEN
    RETURN query 
    SELECT
        u."id",
        u."login",
        u."imageUrl",
        u."userColor" 
    FROM
        users AS u 
    WHERE
        LOWER(u."login") LIKE '%' || LOWER("in_query") || '%' 
        AND u.id NOT IN 
        (
            "in_user_id" :: uuid
        )
        LIMIT "in_limit";
    ELSE
    RETURN query 
    SELECT
        u."id",
        u."login",
        u."imageUrl",
        u."userColor" 
    FROM
        users AS u 
    WHERE
        u."login" LIKE '%' || "in_query" || '%' LIMIT "in_limit";
    END
    IF;
    END
    ;
    $$ language plpgsql volatile;

#### **search_ligth_wish_list**

    DROP FUNCTION IF EXISTS search_light_wish_list;
    CREATE 
    OR replace FUNCTION search_light_wish_list( 
        "in_query" text, 
        "in_limit" INT DEFAULT 10 
    ) 
    RETURNS TABLE( 
        "id" int8, 
        "title" VARCHAR, 
        "imageUrl" VARCHAR, 
        "userColor" text 
    ) AS $$ 
    BEGIN
    RETURN query 
    SELECT
        w."id",
        w."title",
        w."imageUrl",
        u."userColor" 
    FROM
        wish AS W 
        JOIN
            users AS U 
            ON W."createdBy" = U."id" 
    WHERE
        LOWER(W."title") LIKE '%' || LOWER("in_query") || '%' LIMIT "in_limit";
    END
    ;
    $$ language plpgsql volatile;

#### **select_favorite_wish_list**

    CREATE FUNCTION public.select_favorite_wish_list( 
        in_user_id CHARACTER VARYING DEFAULT NULL :: CHARACTER VARYING, 
        in_limit INTEGER DEFAULT 10, 
        in_offset INTEGER DEFAULT 0 
    ) RETURNS TABLE( 
        id BIGINT, 
        title CHARACTER VARYING, 
        description CHARACTER VARYING, 
        link CHARACTER VARYING, 
        "imageUrl" CHARACTER VARYING, 
        "createdAt" TIMESTAMP WITH TIME zone, 
        "isFulfilled" BOOLEAN, 
        "createdBy" jsonb, 
        "wasAdded" TIMESTAMP WITH TIME zone 
    ) LANGUAGE plpgsql AS $ $ 
    BEGIN
    RETURN query 
    SELECT
        W."id",
        W."title",
        W."description",
        W."link",
        W."imageUrl",
        W."createdAt",
        W."isFulfilled",
        jsonb_build_object( 'id', W."createdBy", 'login', U."login", 'imageUrl', U."imageUrl", 'userColor', U."userColor" ) AS createdBy,
        F."wasAdded" 
    FROM
        wish AS W 
        JOIN
            users AS U 
            ON W."createdBy" = U."id" 
        JOIN
            favorites AS F 
            ON F."wishId" = W."id" 
            AND F."userId" = in_user_id :: uuid 
    ORDER BY
        F."wasAdded" DESC LIMIT in_limit OFFSET in_offset;
    END
    ;
    $ $ ;

#### **select_user_wish_list**

    CREATE FUNCTION public.select_user_wish_list( 
        in_user_id CHARACTER VARYING DEFAULT NULL :: CHARACTER VARYING, 
        "LIMIT" INTEGER DEFAULT 10, 
        "OFFSET" INTEGER DEFAULT 0 
    ) 
    RETURNS TABLE( 
        id BIGINT, 
        title CHARACTER VARYING, 
        description CHARACTER VARYING, 
        link CHARACTER VARYING, 
        "imageUrl" CHARACTER VARYING, 
        "createdAt" TIMESTAMP WITH TIME zone, 
        "isFulfilled" BOOLEAN, 
        "createdBy" jsonb 
    ) LANGUAGE plpgsql AS $ $ 
    BEGIN
    RETURN query 
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
        ) AS "createdBy" 
    FROM
        wish AS W 
        JOIN
            users AS U 
            ON W."createdBy" = U."id" 
            AND W."createdBy" = in_user_id :: uuid 
    ORDER BY
        W."createdAt" DESC LIMIT "LIMIT" OFFSET "OFFSET";
    END
    ;
    $ $ ;

#### **select_wish_list**

    CREATE FUNCTION public.select_wish_list( 
        user_id CHARACTER VARYING DEFAULT NULL :: CHARACTER VARYING, 
        "LIMIT" INTEGER DEFAULT 10, 
        "OFFSET" INTEGER DEFAULT 0 
    ) 
    RETURNS TABLE( 
        id BIGINT, 
        title CHARACTER VARYING, 
        description CHARACTER VARYING, 
        link CHARACTER VARYING, 
        "imageUrl" CHARACTER VARYING, 
        "createdAt" TIMESTAMP WITH TIME zone, 
        "isFulfilled" BOOLEAN, 
        "createdBy" jsonb, 
        "isFavorite" BOOLEAN 
    ) LANGUAGE plpgsql AS $ $ 
    BEGIN
    IF user_id IS NOT NULL 
    THEN
    RETURN query 
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
        ) AS "createdBy",
        EXISTS
        (
            SELECT
                * 
            FROM
                favorites AS NF 
            WHERE
                NF."wishId" = W."id" 
                AND NF."userId" = user_id :: uuid 
        )
        AS "isFavorite" 
    FROM
        wish AS W 
        JOIN
            subscriptions AS S 
            ON W."createdBy" = S."subscriptionTo" 
            AND S."id" = user_id :: uuid 
        JOIN
            users AS U 
            ON W."createdBy" = U."id" 
    ORDER BY
        W."createdAt" DESC LIMIT "LIMIT" OFFSET "OFFSET";
    ELSE
    RETURN query 
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
        ) AS "createdBy",
        FALSE AS "isFavorite" 
    FROM
        wish AS W 
        JOIN
            users AS U 
            ON W."createdBy" = U."id" 
    ORDER BY
        W."createdAt" DESC LIMIT "LIMIT" OFFSET "OFFSET";
    END
    IF;
    END
    ;
    $ $ ;

#### **toggle_favorite**

    CREATE FUNCTION public.toggle_favorite(
        in_user_id text, 
        in_wish_id INTEGER
    ) 
    RETURNS BOOLEAN LANGUAGE plpgsql AS $ $ 
    DECLARE row_exists bool;
    BEGIN
    SELECT
        EXISTS
        (
            SELECT
            FROM
                favorites AS F 
            WHERE
                F."userId" = in_user_id :: uuid 
                AND F."wishId" = in_wish_id 
        )
        INTO row_exists;
    IF (row_exists) 
    THEN
    DELETE
    FROM
        favorites AS F 
    WHERE
        F."userId" = in_user_id :: uuid 
        AND F."wishId" = in_wish_id;
    RETURN FALSE;
    ELSE
    INSERT INTO
        favorites("userId", "wishId") 
    VALUES
        (
            in_user_id :: uuid, in_wish_id
        )
    ;
    RETURN TRUE;
    END
    IF;
    END
    ;
    $ $ ;


#### **toggle_subscription**

    CREATE FUNCTION public.toggle_subscription(
        in_current_user_id text, 
        in_another_user_id text
    ) 
    RETURNS BOOLEAN LANGUAGE plpgsql AS $ $ 
    DECLARE row_exists bool;
    BEGIN
    SELECT
        EXISTS
        (
            SELECT
            FROM
                subscriptions AS S 
            WHERE
                S."id" = in_current_user_id :: uuid 
                AND S."subscriptionTo" = in_another_user_id :: uuid 
        )
        INTO row_exists;
    IF (row_exists) 
    THEN
    DELETE
    FROM
        subscriptions AS S 
    WHERE
        S."id" = in_current_user_id :: uuid 
        AND S."subscriptionTo" = in_another_user_id :: uuid;
    RETURN FALSE;
    ELSE
    INSERT INTO
        subscriptions("id", "subscriptionTo") 
    VALUES
        (
            in_current_user_id :: uuid, in_another_user_id :: uuid 
        )
    ;
    RETURN TRUE;
    END
    IF;
    END
    ;
    $ $ ;


### Triggers

#### **trigger_wish_delete_after**

    CREATE FUNCTION trigger_wish_delete_after() RETURNS TRIGGER AS $$ 
      BEGIN
            DELETE
            FROM
                favorites AS F 
            WHERE
                F."wishId" = OLD."id";
            RETURN OLD;
        END
        ;
    $$ language plpgsql;

    CREATE TRIGGER trigger_wish_delete_after BEFORE DELETE
        ON wish FOR EACH ROW EXECUTE PROCEDURE trigger_wish_delete_after();



### Views

#### **wishes_view**

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