-- =============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- =============================================

-- Функция, проверяющая, есть ли у текущего пользователя (auth.uid()) активная связь с partner_id
CREATE OR REPLACE FUNCTION is_linked_with(partner_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public."Links"
    WHERE
      status = 'linked' -- Статус активной связи
      AND (
        (user1_id = auth.uid() AND user2_id = partner_id) OR
        (user2_id = auth.uid() AND user1_id = partner_id)
      )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Функция для проверки по link_id, имеет ли текущий пользователь доступ к данной связи
CREATE OR REPLACE FUNCTION has_access_to_link(link_id_check uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public."Links"
    WHERE id = link_id_check
    AND (user1_id = auth.uid() OR user2_id = auth.uid())
    AND status = 'linked'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Предоставление прав на выполнение функций
GRANT EXECUTE ON FUNCTION is_linked_with(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION has_access_to_link(uuid) TO authenticated;

-- =============================================
-- ТАБЛИЦА USERS - профили пользователей
-- =============================================

-- Чтение своего профиля
CREATE POLICY "Users: read own profile"
ON public."Users" FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Чтение профиля партнера
CREATE POLICY "Users: read partner profile"
ON public."Users" FOR SELECT
TO authenticated
USING (is_linked_with(user_id));

-- NB Чтение профилей для поиска по pairing_code
CREATE POLICY "Users: read for search by pairing_code"
ON public."Users" FOR SELECT
TO authenticated
USING (
  user_id <> auth.uid() AND
  NOT is_linked_with(user_id)
);

-- Создание своего профиля
CREATE POLICY "Users: create own profile"
ON public."Users" FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Обновление своего профиля
CREATE POLICY "Users: update own profile"
ON public."Users" FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Удаление своего профиля
CREATE POLICY "Users: delete own profile"
ON public."Users" FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- =============================================
-- ТАБЛИЦА LINKS - связи между пользователями
-- =============================================

-- Чтение своих связей
CREATE POLICY "Links: read own links"
ON public."Links" FOR SELECT
TO authenticated
USING (user1_id = auth.uid() OR user2_id = auth.uid());

-- Создание связи (инициирование)
CREATE POLICY "Links: create link as initiator"
ON public."Links" FOR INSERT
TO authenticated
WITH CHECK (
  initiator_user_id = auth.uid() AND
  (user1_id = auth.uid() OR user2_id = auth.uid()) AND
  user1_id <> user2_id
);

-- Обновление статуса связи
CREATE POLICY "Links: update link status"
ON public."Links" FOR UPDATE
TO authenticated
USING (user1_id = auth.uid() OR user2_id = auth.uid())
WITH CHECK (user1_id = auth.uid() OR user2_id = auth.uid());

-- Удаление связи
CREATE POLICY "Links: delete link"
ON public."Links" FOR DELETE
TO authenticated
USING (user1_id = auth.uid() OR user2_id = auth.uid());

-- =============================================
-- ТАБЛИЦЫ КОНТЕНТА (статические) - доступны всем авторизованным
-- Modules, Tests, TheoryBlocks, Questions, Answer_Options
-- =============================================

-- Чтение модулей
CREATE POLICY "Modules: read for authenticated"
ON public."Modules" FOR SELECT
TO authenticated
USING (true);

-- Чтение блоков теории
CREATE POLICY "TheoryBlocks: read for authenticated"
ON public."TheoryBlocks" FOR SELECT
TO authenticated
USING (true);

-- Чтение тестов
CREATE POLICY "Tests: read for authenticated"
ON public."Tests" FOR SELECT
TO authenticated
USING (true);

-- Чтение вопросов
CREATE POLICY "Questions: read for authenticated"
ON public."Questions" FOR SELECT
TO authenticated
USING (true);

-- Чтение вариантов ответов
CREATE POLICY "AnswerOptions: read for authenticated"
ON public."AnswerOptions" FOR SELECT
TO authenticated
USING (true);

-- =============================================
-- ТАБЛИЦЫ ПРОГРЕССА - User_TestAttempts, User_Answers
-- =============================================

-- Чтение своих попыток прохождения тестов
CREATE POLICY "User_TestAttempts: read own attempts"
ON public."User_TestAttempts" FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Создание своих попыток
CREATE POLICY "User_TestAttempts: create own attempts"
ON public."User_TestAttempts" FOR INSERT
TO authenticated
WITH CHECK (user_id = auth.uid());

-- Обновление своих попыток
CREATE POLICY "User_TestAttempts: update own attempts"
ON public."User_TestAttempts" FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Чтение своих ответов
CREATE POLICY "User_Answers: read own answers"
ON public."User_Answers" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."User_TestAttempts"
    WHERE "User_TestAttempts".attempt_id = "User_Answers".attempt_id
    AND "User_TestAttempts".user_id = auth.uid()
  )
);

-- Создание своих ответов
CREATE POLICY "User_Answers: create own answers"
ON public."User_Answers" FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public."User_TestAttempts"
    WHERE "User_TestAttempts".attempt_id = "User_Answers".attempt_id
    AND "User_TestAttempts".user_id = auth.uid()
  )
);

-- Обновление своих ответов
CREATE POLICY "User_Answers: update own answers"
ON public."User_Answers" FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."User_TestAttempts"
    WHERE "User_TestAttempts".attempt_id = "User_Answers".attempt_id
    AND "User_TestAttempts".user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public."User_TestAttempts"
    WHERE "User_TestAttempts".attempt_id = "User_Answers".attempt_id
    AND "User_TestAttempts".user_id = auth.uid()
  )
);

-- Чтение прогресса партнера
CREATE POLICY "User_Answers: read partner's test attempts"
ON public."User_TestAttempts" FOR SELECT
TO authenticated
USING (is_linked_with(user_id));

-- NB Чтение ответов партнера
CREATE POLICY "User_Answers: read partner's answers"
ON public."User_Answers" FOR SELECT
TO authenticated
USING (is_linked_with(user_id));

-- DELETE: Удаление запрещено.
CREATE POLICY "Deny deletion of attempts"
ON public."User_TestAttempts" FOR DELETE
TO authenticated
USING (false);

CREATE POLICY "Deny deletion of answers"
ON public."User_Answers" FOR DELETE
TO authenticated
USING (false);


-- =============================================
-- ТАБЛИЦЫ КАРТЫ ЛЮБВИ - LoveMap_Sections, LoveMap_Topics, LoveMap_Items
-- =============================================

-- Чтение секций карты любви (для партнеров в паре)
CREATE POLICY "LoveMap_Sections: read sections"
ON public."LoveMap_Sections" FOR SELECT
TO authenticated
USING (has_access_to_link(link_id));

-- Создание секций карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Sections: create sections"
ON public."LoveMap_Sections" FOR INSERT
TO authenticated
WITH CHECK (has_access_to_link(link_id));

-- Обновление секций карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Sections: update sections"
ON public."LoveMap_Sections" FOR UPDATE
TO authenticated
USING (has_access_to_link(link_id))
WITH CHECK (has_access_to_link(link_id));

-- Удаление секций карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Sections: delete sections"
ON public."LoveMap_Sections" FOR DELETE
TO authenticated
USING (has_access_to_link(link_id));

-- Чтение топиков карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Topics: read topics"
ON public."LoveMap_Topics" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Sections"
    WHERE "LoveMap_Sections".section_id = "LoveMap_Topics".section_id
    AND has_access_to_link("LoveMap_Sections".link_id)
  )
);

-- Создание топиков карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Topics: create topics"
ON public."LoveMap_Topics" FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Sections"
    WHERE "LoveMap_Sections".section_id = "LoveMap_Topics".section_id
    AND has_access_to_link("LoveMap_Sections".link_id)
  )
);

-- Обновление топиков карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Topics: update topics"
ON public."LoveMap_Topics" FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Sections"
    WHERE "LoveMap_Sections".section_id = "LoveMap_Topics".section_id
    AND has_access_to_link("LoveMap_Sections".link_id)
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Sections"
    WHERE "LoveMap_Sections".section_id = "LoveMap_Topics".section_id
    AND has_access_to_link("LoveMap_Sections".link_id)
  )
);

-- Удаление топиков карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Topics: delete topics"
ON public."LoveMap_Topics" FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Sections"
    WHERE "LoveMap_Sections".section_id = "LoveMap_Topics".section_id
    AND has_access_to_link("LoveMap_Sections".link_id)
  )
);

-- Чтение элементов карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Items: read items"
ON public."LoveMap_Items" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Topics" t
    JOIN public."LoveMap_Sections" s ON s.section_id = t.section_id
    WHERE t.topic_id = "LoveMap_Items".topic_id
    AND has_access_to_link(s.link_id)
  )
);

-- Создание элементов карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Items: create items"
ON public."LoveMap_Items" FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Topics" t
    JOIN public."LoveMap_Sections" s ON s.section_id = t.section_id
    WHERE t.topic_id = "LoveMap_Items".topic_id
    AND has_access_to_link(s.link_id)
  )
);

-- Обновление элементов карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Items: update items"
ON public."LoveMap_Items" FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Topics" t
    JOIN public."LoveMap_Sections" s ON s.section_id = t.section_id
    WHERE t.topic_id = "LoveMap_Items".topic_id
    AND has_access_to_link(s.link_id)
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Topics" t
    JOIN public."LoveMap_Sections" s ON s.section_id = t.section_id
    WHERE t.topic_id = "LoveMap_Items".topic_id
    AND has_access_to_link(s.link_id)
  )
);

-- Удаление элементов карты любви, только для партнеров в паре
CREATE POLICY "LoveMap_Items: delete items"
ON public."LoveMap_Items" FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public."LoveMap_Topics" t
    JOIN public."LoveMap_Sections" s ON s.section_id = t.section_id
    WHERE t.topic_id = "LoveMap_Items".topic_id
    AND has_access_to_link(s.link_id)
  )
);

-- =============================================
-- ТАБЛИЦЫ БАНКА ЭМОЦИЙ - EmotionalBank_Entries, EmotionalBank_RatingRequests, EmotionalBank_PartnerRatings
-- =============================================

-- Чтение записей банка эмоций (свои записи и записи партнера, которыми он поделился)
CREATE POLICY "EmotionalBank_Entries: read entries"
ON public."EmotionalBank_Entries" FOR SELECT
TO authenticated
USING (
  user_id = auth.uid() OR
  (is_shared = TRUE AND has_access_to_link(link_id) AND user_id <> auth.uid())
);

-- Создание записей банка эмоций (только свои записи, только для партнеров в паре)
CREATE POLICY "EmotionalBank_Entries: create entries"
ON public."EmotionalBank_Entries" FOR INSERT
TO authenticated
WITH CHECK (
  user_id = auth.uid() AND
  has_access_to_link(link_id)
);

-- Обновление записей банка эмоций (только свои записи)
CREATE POLICY "EmotionalBank_Entries: update entries"
ON public."EmotionalBank_Entries" FOR UPDATE
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Удаление записей банка эмоций (только свои записи)
CREATE POLICY "EmotionalBank_Entries: delete entries"
ON public."EmotionalBank_Entries" FOR DELETE
TO authenticated
USING (user_id = auth.uid());

-- Чтение запросов на оценку от партнера из активной связи
CREATE POLICY "EmotionalBank_RatingRequests: read requests"
ON public."EmotionalBank_RatingRequests" FOR SELECT
TO authenticated
USING (
  from_user_id = auth.uid() OR
  (to_user_id = auth.uid() AND is_linked_with(from_user_id))
);

-- Создание запросов на оценку для партнеров в активной связи
CREATE POLICY "EmotionalBank_RatingRequests: create requests"
ON public."EmotionalBank_RatingRequests" FOR INSERT
TO authenticated
WITH CHECK (
  from_user_id = auth.uid() AND
  is_linked_with(to_user_id) AND
  EXISTS (
    SELECT 1
    FROM public."EmotionalBank_Entries"
    WHERE "EmotionalBank_Entries".entry_id = "EmotionalBank_RatingRequests".entry_id
    AND "EmotionalBank_Entries".user_id = auth.uid()
  )
);

-- Обновление запросов на оценку одним из партнеров в активной связи
CREATE POLICY "EmotionalBank_RatingRequests: update requests"
ON public."EmotionalBank_RatingRequests" FOR UPDATE
TO authenticated
USING (
  (from_user_id = auth.uid()) OR
  (to_user_id = auth.uid() AND is_linked_with(from_user_id)));

-- Оба партнера в паре могут видеть оценку (SELECT)
CREATE POLICY "Couple can read partner ratings"
ON public."EmotionalBank_PartnerRatings" FOR SELECT
TO authenticated
USING (
  -- Либо ты сам поставил эту оценку
  user_id = auth.uid()
  -- Либо ты связан с тем, кто поставил эту оценку (т.е. с твоим партнером)
  OR is_linked_with(user_id)
);

-- Только получатель запроса может дать оценку (INSERT/UPDATE/DELETE для EmotionalBank_PartnerRatings)
CREATE POLICY "Target user can create ratings"
ON public."EmotionalBank_PartnerRatings" FOR INSERT, UPDATE, DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 
    FROM public."EmotionalBank_RatingRequests" r
    WHERE r.request_id = "EmotionalBank_PartnerRatings".request_id AND
    r.to_user_id = auth.uid()));

-- =============================================
-- Таблица: Messages
-- =============================================
-- Пользователи могут читать свои сообщения и сообщения партнера
CREATE POLICY "Participants can read their messages"
ON public."Messages" FOR SELECT
TO authenticated
USING (auth.uid() IN (sender_id, receiver_id));

-- Пользователь может отправить сообщение своему партнеру (INSERT)
CREATE POLICY "User can send message to partner"
ON public."Messages" FOR INSERT
TO authenticated
WITH CHECK (
  sender_id = auth.uid() AND
  is_linked_with(receiver_id));

-- Получатель может обновить сообщение (например, пометить прочитанным)
CREATE POLICY "Receiver can update a message"
ON public."Messages" FOR UPDATE
TO authenticated
USING (receiver_id = auth.uid());

-- DELETE: Удаление запрещено.
CREATE POLICY "Deny message deletion"
ON public."Messages" FOR DELETE
USING (false);


-- =============================================
-- Таблица: MediaFiles
-- =============================================
-- Пользователь может управлять только своими файлами (CRUD)
CREATE POLICY "Users can manage their own media files"
ON public."MediaFiles" FOR ALL
TO authenticated
USING (uploaded_by_user_id = auth.uid())
WITH CHECK (uploaded_by_user_id = auth.uid());
