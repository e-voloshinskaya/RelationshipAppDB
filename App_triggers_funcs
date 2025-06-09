-- ====================================
-- TRIGGERS
-- ====================================
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();
CREATE TRIGGER set_answer_options_updated_at BEFORE UPDATE ON public."Answer_Options" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_links_updated_at BEFORE UPDATE ON public."Links" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_media_files_updated_at BEFORE UPDATE ON public."MediaFiles" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_messages_updated_at BEFORE UPDATE ON public."Messages" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_modules_updated_at BEFORE UPDATE ON public."Modules" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_questions_updated_at BEFORE UPDATE ON public."Questions" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_tests_updated_at BEFORE UPDATE ON public."Tests" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_theory_blocks_updated_at BEFORE UPDATE ON public."TheoryBlocks" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_user_answers_updated_at BEFORE UPDATE ON public."User_Answers" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER on_test_completed AFTER UPDATE ON public."User_TestAttempts" FOR EACH ROW EXECUTE FUNCTION handle_test_completion_notification();
CREATE TRIGGER set_user_test_attempts_updated_at BEFORE UPDATE ON public."User_TestAttempts" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER set_users_updated_at BEFORE UPDATE ON public."Users" FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();
CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();
CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


-- ======================================
-- FUNCTIONS
-- ======================================

-- ===========================
-- get_modules_with_user_status
-- ============================
BEGIN
    RETURN QUERY
    SELECT
        m.module_id,
        m.m_title,
        -- Подсчитываем общее количество шагов в модуле
        (SELECT COUNT(*) FROM public."Module_Content" mc WHERE mc.module_id = m.module_id) as sections_count,
        -- Вычисляем статус для текущего пользователя
        CASE
            -- СТАТУС "ПРОЙДЕН"
            WHEN (SELECT COUNT(*) FROM public."Module_Content" mc WHERE mc.module_id = m.module_id) > 0 AND
                 (
                    (SELECT COUNT(*) FROM public."User_Theory_Progress" utp WHERE utp.theory_id IN (SELECT mc.theory_id FROM public."Module_Content" mc WHERE mc.module_id = m.module_id AND mc.theory_id IS NOT NULL) AND utp.user_id = auth.uid()) +
                    (SELECT COUNT(*) FROM public."User_TestAttempts" uta WHERE uta.test_id IN (SELECT mc.test_id FROM public."Module_Content" mc WHERE mc.module_id = m.module_id AND mc.test_id IS NOT NULL) AND uta.user_id = auth.uid() AND uta.completed_at IS NOT NULL)
                 ) = (SELECT COUNT(*) FROM public."Module_Content" mc WHERE mc.module_id = m.module_id)
            THEN 'completed'

            -- СТАТУС "В ПРОЦЕССЕ"
            WHEN (
                (SELECT COUNT(*) FROM public."User_Theory_Progress" utp WHERE utp.theory_id IN (SELECT mc.theory_id FROM public."Module_Content" mc WHERE mc.module_id = m.module_id AND mc.theory_id IS NOT NULL) AND utp.user_id = auth.uid()) +
                (SELECT COUNT(*) FROM public."User_TestAttempts" uta WHERE uta.test_id IN (SELECT mc.test_id FROM public."Module_Content" mc WHERE mc.module_id = m.module_id AND mc.test_id IS NOT NULL) AND uta.user_id = auth.uid())
            ) > 0
            THEN 'in_progress'

            -- СТАТУС "НЕ НАЧАТ"
            ELSE 'not_started'
        END AS status
    FROM
        public."Modules" m
    ORDER BY
        m.order_idx;
END;

-- =====================
-- get_user_history
-- =====================
DECLARE
    current_user_id uuid := auth.uid();
    active_partner_id uuid;
BEGIN
    -- Находим ID активного партнера для текущего пользователя, используя новые колонки
    SELECT
        CASE
            -- Если я - инициатор, то мой партнер - это partner_id
            WHEN l.initiator_id = current_user_id THEN l.partner_id
            -- Если я - партнер, то мой партнер - это initiator_id
            ELSE l.initiator_id
        END
    INTO active_partner_id
    FROM public."Links" l
    -- Ищем активную связь, где я являюсь либо инициатором, либо партнером
    WHERE (l.initiator_id = current_user_id OR l.partner_id = current_user_id)
      AND l.status = 'active'
    LIMIT 1;
    
    -- Возвращаем итоговую таблицу
    RETURN QUERY
    SELECT
        uta.attempt_id,
        uta.test_id,
        t.title as test_title,
        t.is_pair_activity,
        uta.completed_at as user_completed_at,
        active_partner_id as partner_id,
        (
            SELECT p_uta.completed_at
            FROM public."User_TestAttempts" p_uta
            WHERE p_uta.user_id = active_partner_id
              AND p_uta.test_id = uta.test_id
              AND p_uta.completed_at IS NOT NULL
            ORDER BY p_uta.completed_at DESC
            LIMIT 1
        ) as partner_completed_at
    FROM
        public."User_TestAttempts" uta
    JOIN public."Tests" t ON uta.test_id = t.test_id
    WHERE
        uta.user_id = current_user_id
    ORDER BY
        uta.created_at DESC;

END;

-- =======================
-- get_user_pairing_status
-- =========================
DECLARE
    current_user_id uuid := auth.uid();
    active_link "Links"%ROWTYPE;
BEGIN
    SELECT * INTO active_link FROM public."Links" AS l
    WHERE (l.initiator_id = current_user_id OR l.partner_id = current_user_id)
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN QUERY SELECT 'no_link'::text, NULL::uuid, NULL::character varying, NULL::text;
    ELSE
        IF active_link.status = 'active' THEN
            IF active_link.initiator_id = current_user_id THEN
                RETURN QUERY SELECT 'linked'::text, u.user_id, u.user_name, u.user_avatar
                FROM public."Users" u WHERE u.user_id = active_link.partner_id;
            ELSE
                RETURN QUERY SELECT 'linked'::text, u.user_id, u.user_name, u.user_avatar
                FROM public."Users" u WHERE u.user_id = active_link.initiator_id;
            END IF;
        ELSIF active_link.status = 'pending' THEN
            IF active_link.initiator_id = current_user_id THEN
                RETURN QUERY SELECT 'request_sent'::text, u.user_id, u.user_name, u.user_avatar
                FROM public."Users" u WHERE u.user_id = active_link.partner_id;
            ELSE
                RETURN QUERY SELECT 'request_received'::text, u.user_id, u.user_name, u.user_avatar
                FROM public."Users" u WHERE u.user_id = active_link.initiator_id;
            END IF;
        ELSE
             RETURN QUERY SELECT 'no_link'::text, NULL::uuid, NULL::character varying, NULL::text;
        END IF;
    END IF;
END;


-- ===================
-- handle_new_user
-- ==================
begin
  insert into public."Users" (user_id, user_created_at, updated_at)
  values (new.id, new.created_at, new.updated_at);
  return new;
end;


-- ====================
-- is_linked_with
-- ====================
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public."Links" as l
    WHERE
      l.status = 'active'
      AND (
        (l.initiator_id = auth.uid() AND l.partner_id = p_partner_id) OR
        (l.partner_id = auth.uid() AND l.initiator_id = p_partner_id)
      )
  );
END;


-- ==================
-- use_pairing_code
-- ===================


DECLARE
    current_user_id uuid := auth.uid(); -- Получаем ID текущего сеанса
    target_code "PairingCodes"%ROWTYPE;
    code_owner_id uuid;
    user_has_link boolean;
    partner_has_link boolean;
BEGIN
    -- 1. Найти код
    SELECT * INTO target_code FROM public."PairingCodes" WHERE code = partner_code;
    IF NOT FOUND THEN RETURN 'code_not_found'; END IF;
    IF target_code.is_used = true THEN RETURN 'code_used'; END IF;
    IF target_code.expires_at <= now() THEN RETURN 'code_expired'; END IF;

    code_owner_id := target_code.user_id;

    -- 2. Проверка на связывание с самим собой
    IF current_user_id = code_owner_id THEN
        RETURN 'self_pairing';
    END IF;

    -- 3. Проверка, что ни у одного из пользователей уже нет активной или ожидающей связи
    -- Здесь мы используем ID, которые ссылаются на public.Users
    SELECT EXISTS (SELECT 1 FROM public."Links" WHERE (initiator_id = current_user_id OR partner_id = current_user_id) AND status IN ('active', 'pending')) INTO user_has_link;
    SELECT EXISTS (SELECT 1 FROM public."Links" WHERE (initiator_id = code_owner_id OR partner_id = code_owner_id) AND status IN ('active', 'pending')) INTO partner_has_link;

    IF user_has_link OR partner_has_link THEN
        RETURN 'already_paired';
    END IF;

    -- 4. Все проверки пройдены. Создаем связь.
    INSERT INTO public."Links" (initiator_id, partner_id, pairing_code_id, status)
    VALUES (code_owner_id, current_user_id, target_code.code_id, 'pending');

    UPDATE public."PairingCodes" SET is_used = true, used_at = now(), used_by_user_id = current_user_id
    WHERE code_id = target_code.code_id;

    RETURN 'success';
END;


-- ===================
-- accept_link_request
-- ===================
BEGIN
  UPDATE public."Links"
  SET status = 'active', updated_at = now()
  WHERE partner_id = auth.uid() AND status = 'pending';
END;


-- =====================
-- delete_link
-- =====================
BEGIN
  DELETE FROM public."Links"
  WHERE (initiator_id = auth.uid() OR partner_id = auth.uid());
END;


-- ======================
-- handle_test_completion_notification
-- ======================

DECLARE
    partner_user_id uuid;
    test_title_text text;
    sender_name text;
BEGIN
    -- Проверяем, что тест только что был завершен
    IF NEW.completed_at IS NOT NULL AND OLD.completed_at IS NULL THEN
        
        -- Находим ID партнера
        SELECT 
            CASE 
                WHEN l.initiator_id = NEW.user_id THEN l.partner_id 
                ELSE l.initiator_id 
            END
        INTO partner_user_id
        FROM public."Links" l
        WHERE (l.initiator_id = NEW.user_id OR l.partner_id = NEW.user_id) 
        AND l.status = 'active'
        LIMIT 1;

        -- Если партнер найден
        IF partner_user_id IS NOT NULL THEN
            -- Получаем название теста
            SELECT t.title 
            INTO test_title_text 
            FROM public."Tests" t 
            WHERE t.test_id = NEW.test_id;
            
            -- Получаем имя отправителя
            SELECT u.user_name 
            INTO sender_name 
            FROM public."Users" u 
            WHERE u.user_id = NEW.user_id;

            -- Создаем уведомление
            INSERT INTO public."Notifications" (
                recipient_id, 
                sender_id, 
                type, 
                message, 
                related_item_id
            )
            VALUES (
                partner_user_id, 
                NEW.user_id, 
                'test_completed', 
                COALESCE(sender_name, 'Ваш партнер') || ' прошел(ла) тест: ' || COALESCE(test_title_text, 'Неизвестный тест'),
                NEW.test_id
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;


-- ================
-- create_partner_notification
-- ================

DECLARE
    v_partner_id uuid;
    v_sender_name text;
BEGIN
    -- Находим активного партнера
    SELECT 
        CASE 
            WHEN l.initiator_id = p_user_id THEN l.partner_id 
            ELSE l.initiator_id 
        END
    INTO v_partner_id
    FROM public."Links" l
    WHERE (l.initiator_id = p_user_id OR l.partner_id = p_user_id) 
    AND l.status = 'active'
    LIMIT 1;
    
    -- Если партнер найден, создаем уведомление
    IF v_partner_id IS NOT NULL THEN
        INSERT INTO public."Notifications" (
            recipient_id,
            sender_id,
            type,
            message,
            related_item_id
        )
        VALUES (
            v_partner_id,
            p_user_id,
            p_notification_type,
            p_message,
            p_related_item_id
        );
    END IF;
END;



