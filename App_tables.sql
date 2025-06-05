CREATE TABLE public.Users (
    user_avatar text,
    user_paring_code character varying,
    updated_at timestamp with time zone NOT NULL,
    user_id uuid NOT NULL,
    user_created_at timestamp with time zone NOT NULL,
    user_name character varying);

CREATE TABLE public.Links (
    status character varying(30) NOT NULL,
    link_id uuid NOT NULL,
    user1_id uuid NOT NULL,
    user2_id uuid NOT NULL,
    initiator_user_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL);

CREATE TABLE public.Messages (
    sender_id uuid,
    receiver_id uuid,
    updated_at timestamp with time zone NOT NULL,
    link_id uuid,
    message_id uuid NOT NULL,
    text text,
    created_at timestamp with time zone NOT NULL,
    is_read boolean);


CREATE TABLE public.Modules (
    updated_at timestamp with time zone NOT NULL,
    num_blocks bigint(64,0),
    created_at timestamp with time zone,
    module_id uuid NOT NULL,
    m_title character varying NOT NULL,
    description text,
    order_idx bigint(64,0) NOT NULL);

CREATE TABLE public.Questions (
    points integer(32,0),
    order_in_test integer(32,0) NOT NULL,
    correct_free_text_answer text,
    created_at timestamp with time zone NOT NULL,
    question_text text NOT NULL,
    test_id uuid NOT NULL,
    question_type character varying(50) NOT NULL,
    question_id uuid NOT NULL,
    updated_at timestamp with time zone NOT NULL);

CREATE TABLE public.Tests (
    test_id uuid NOT NULL,
    order_in_module integer(32,0),
    created_at timestamp with time zone NOT NULL,
    is_scored boolean NOT NULL,
    module_id uuid,
    updated_at timestamp with time zone NOT NULL,
    description text,
    title character varying(255) NOT NULL);

CREATE TABLE public.Answer_Options (
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    order_in_question integer(32,0) NOT NULL,
    is_correct boolean NOT NULL,
    question_id uuid NOT NULL,
    option_id uuid NOT NULL,
    option_text text NOT NULL);

CREATE TABLE public.TheoryBlocks (
    created_at timestamp with time zone,
    content text NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    theory_order integer(32,0) NOT NULL,
    module_id uuid NOT NULL,
    theory_title character varying NOT NULL,
    theory_description text,
    theory_id uuid NOT NULL);

CREATE TABLE public.User_Answers (
    is_correct boolean,
    created_at timestamp with time zone NOT NULL,
    points_awarded integer(32,0),
    selected_option_id uuid,
    question_id uuid NOT NULL,
    attempt_id uuid NOT NULL,
    user_answer_id uuid NOT NULL,
    free_text_answer text,
    updated_at timestamp with time zone NOT NULL);

CREATE TABLE public.User_TestAttempts (
    created_at timestamp with time zone NOT NULL,
    score integer(32,0),
    completed_at timestamp with time zone,
    updated_at timestamp with time zone NOT NULL,
    attempt_id uuid NOT NULL,
    user_id uuid NOT NULL,
    test_id uuid NOT NULL,
    started_at timestamp with time zone NOT NULL);

CREATE TABLE public.MediaFiles (
    file_url text NOT NULL,
    mime_type character varying(100),
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    size_bytes bigint(64,0),
    uploaded_by_user_id uuid,
    file_id uuid NOT NULL,
    file_name text);


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
