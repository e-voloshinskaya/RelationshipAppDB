-- =======================
-- USER LINKED TABLES
-- =======================

CREATE TABLE public.Users (
    user_id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_name character varying DEFAULT 'Stranger'::character varying,
    user_avatar text,
    user_created_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id));

CREATE TABLE public.Links (
    link_id uuid NOT NULL DEFAULT gen_random_uuid(),
    status character varying(30) NOT NULL DEFAULT 'pending'::character varying,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    pairing_code_id uuid,
    initiator_id uuid NOT NULL,
    partner_id uuid NOT NULL,
    PRIMARY KEY (link_id));

CREATE TABLE public.PairingCodes (
    code_id uuid NOT NULL DEFAULT gen_random_uuid(),
    code character varying(10) NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    expires_at timestamp with time zone NOT NULL,
    is_used boolean NOT NULL DEFAULT false,
    used_at timestamp with time zone,
    used_by_user_id uuid,
    PRIMARY KEY (code_id));

CREATE TABLE public.User_TestAttempts (
    attempt_id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    test_id uuid NOT NULL,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    score integer(32,0),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (attempt_id));

CREATE TABLE public.User_Answers (
    user_answer_id uuid NOT NULL DEFAULT gen_random_uuid(),
    attempt_id uuid NOT NULL,
    question_id uuid NOT NULL,
    selected_option_id uuid,
    free_text_answer text,
    is_correct boolean,
    points_awarded integer(32,0),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (user_answer_id));

CREATE TABLE public.User_Theory_Progress (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    theory_id uuid NOT NULL,
    is_completed boolean NOT NULL DEFAULT true,
    completed_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    PRIMARY KEY (id));

CREATE TABLE public.Messages (
    sender_id uuid,
    receiver_id uuid,
    updated_at timestamp with time zone NOT NULL,
    link_id uuid,
    message_id uuid NOT NULL,
    text text,
    created_at timestamp with time zone NOT NULL,
    is_read boolean);

CREATE TABLE public.MediaFiles (
    file_url text NOT NULL,
    mime_type character varying(100),
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    size_bytes bigint(64,0),
    uploaded_by_user_id uuid,
    file_id uuid NOT NULL,
    file_name text);

-- =======================
-- STATIC CONTENT TABLES
-- =======================
CREATE TABLE public.Modules (
    module_id uuid NOT NULL DEFAULT gen_random_uuid(),
    order_idx bigint(64,0) NOT NULL,
    m_title character varying NOT NULL DEFAULT 'Модуль'::character varying,
    description text,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    num_blocks bigint(64,0) DEFAULT '0'::bigint,
    PRIMARY KEY (module_id));

CREATE TABLE public.Module_Content (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    module_id uuid NOT NULL,
    content_type text NOT NULL,
    order integer(32,0) NOT NULL,
    theory_id uuid,
    test_id uuid,
    PRIMARY KEY (id));

CREATE TABLE public.Tests (
    test_id uuid NOT NULL DEFAULT gen_random_uuid(),
    module_id uuid,
    title character varying(255) NOT NULL,
    description text,
    is_scored boolean NOT NULL DEFAULT true,
    order_in_module integer(32,0),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    is_pair_activity boolean,
    PRIMARY KEY (test_id));

CREATE TABLE public.Questions (
    question_id uuid NOT NULL DEFAULT gen_random_uuid(),
    test_id uuid NOT NULL,
    question_text text NOT NULL,
    question_type character varying(50) NOT NULL,
    order_in_test integer(32,0) NOT NULL,
    points integer(32,0) DEFAULT 0,
    correct_free_text_answer text,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (question_id));

CREATE TABLE public.Answer_Options (
    option_id uuid NOT NULL DEFAULT gen_random_uuid(),
    question_id uuid NOT NULL,
    option_text text NOT NULL,
    is_correct boolean NOT NULL DEFAULT false,
    order_in_question integer(32,0) NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (option_id));

CREATE TABLE public.TheoryBlocks (
    theory_id uuid NOT NULL DEFAULT gen_random_uuid(),
    theory_order integer(32,0) NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    theory_title character varying NOT NULL,
    theory_description text,
    content text NOT NULL,
    module_id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
    PRIMARY KEY (theory_id));

-- =======================
-- DIARIES TABLES
-- =======================

CREATE TABLE public.EmotionalBank_Entries (
    user_id uuid NOT NULL,
    entry_id uuid NOT NULL,
    title character varying(255),
    category character varying(100),
    description text NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    is_shared boolean NOT NULL,
    is_positive boolean NOT NULL,
    user_rating smallint(16,0) NOT NULL,
    duration_minutes integer(32,0),
    event_datetime timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    link_id uuid NOT NULL);

CREATE TABLE public.EmotionalBank_PartnerRatings (
    comment text,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    rating smallint(16,0) NOT NULL,
    user_id uuid NOT NULL,
    request_id uuid NOT NULL,
    entry_id uuid NOT NULL,
    rating_id uuid NOT NULL);

CREATE TABLE public.EmotionalBank_RatingRequests (
    entry_id uuid NOT NULL,
    status character varying(20) NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    to_user_id uuid NOT NULL,
    from_user_id uuid NOT NULL,
    request_id uuid NOT NULL);


CREATE TABLE public.LoveMap_Items (
    created_at timestamp with time zone NOT NULL,
    title text NOT NULL,
    item_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    content text,
    last_updated_by_user_id uuid);

CREATE TABLE public.LoveMap_Sections (
    section_id uuid NOT NULL,
    order_in_map integer(32,0) NOT NULL,
    about_user_id uuid,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    link_id uuid NOT NULL,
    title text NOT NULL,
    section_type text NOT NULL);

CREATE TABLE public.LoveMap_Topics (
    topic_id uuid NOT NULL,
    section_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    title text NOT NULL,
    order_in_section integer(32,0) NOT NULL,
    last_updated_by_user_id uuid);
