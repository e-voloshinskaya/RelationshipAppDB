-- =============================
-- INDEXES
-- =============================
CREATE UNIQUE INDEX "Modules_order_idx_key" ON public."Modules" USING btree (order_idx)
CREATE UNIQUE INDEX "Modules_pkey" ON public."Modules" USING btree (module_id)
CREATE UNIQUE INDEX "Media_Files_file_url_key" ON public."MediaFiles" USING btree (file_url)
CREATE UNIQUE INDEX "Media_Files_pkey" ON public."MediaFiles" USING btree (file_id)
CREATE UNIQUE INDEX lovemap_sections_link_id_section_type_about_user_id_key ON public."LoveMap_Sections" USING btree (link_id, section_type, about_user_id)
CREATE UNIQUE INDEX lovemap_sections_pkey ON public."LoveMap_Sections" USING btree (section_id)
CREATE UNIQUE INDEX lovemap_items_pkey ON public."LoveMap_Items" USING btree (item_id)
CREATE INDEX idx_lovemap_items_topic_id ON public."LoveMap_Items" USING btree (topic_id)
CREATE INDEX idx_lovemap_items_updated_at ON public."LoveMap_Items" USING btree (updated_at)
CREATE UNIQUE INDEX emotional_bank_rating_requests_pkey ON public."EmotionalBank_RatingRequests" USING btree (request_id)
CREATE INDEX idx_emotional_bank_rating_requests_entry_id ON public."EmotionalBank_RatingRequests" USING btree (entry_id)
CREATE INDEX idx_emotional_bank_rating_requests_status ON public."EmotionalBank_RatingRequests" USING btree (status)
CREATE INDEX idx_emotional_bank_rating_requests_to_user_id ON public."EmotionalBank_RatingRequests" USING btree (to_user_id)
CREATE UNIQUE INDEX emotional_bank_entries_pkey ON public."EmotionalBank_Entries" USING btree (entry_id)
CREATE INDEX idx_emotional_bank_entries_event_datetime ON public."EmotionalBank_Entries" USING btree (event_datetime)
CREATE INDEX idx_emotional_bank_entries_is_shared ON public."EmotionalBank_Entries" USING btree (is_shared)
CREATE INDEX idx_emotional_bank_entries_link_id ON public."EmotionalBank_Entries" USING btree (link_id)
CREATE INDEX idx_emotional_bank_entries_user_id ON public."EmotionalBank_Entries" USING btree (user_id)
CREATE UNIQUE INDEX emotional_bank_partner_ratings_entry_id_user_id_key ON public."EmotionalBank_PartnerRatings" USING btree (entry_id, user_id)
CREATE UNIQUE INDEX emotional_bank_partner_ratings_pkey ON public."EmotionalBank_PartnerRatings" USING btree (rating_id)
CREATE INDEX idx_emotional_bank_partner_ratings_entry_id ON public."EmotionalBank_PartnerRatings" USING btree (entry_id)
CREATE INDEX idx_emotional_bank_partner_ratings_user_id ON public."EmotionalBank_PartnerRatings" USING btree (user_id)
CREATE UNIQUE INDEX "Tests_pkey" ON public."Tests" USING btree (test_id)
CREATE UNIQUE INDEX "User_Answers_attempt_id_question_id_selected_option_id_key" ON public."User_Answers" USING btree (attempt_id, question_id, selected_option_id)
CREATE UNIQUE INDEX "User_Answers_pkey" ON public."User_Answers" USING btree (user_answer_id)
CREATE UNIQUE INDEX "Users_pkey" ON public."Users" USING btree (user_id)
CREATE UNIQUE INDEX "Users_user_id_key" ON public."Users" USING btree (user_id)
CREATE UNIQUE INDEX "Answer_Options_pkey" ON public."Answer_Options" USING btree (option_id)
CREATE UNIQUE INDEX "Answer_Options_question_id_order_in_question_key" ON public."Answer_Options" USING btree (question_id, order_in_question)
CREATE UNIQUE INDEX lovemap_topics_pkey ON public."LoveMap_Topics" USING btree (topic_id)
CREATE INDEX idx_lovemap_topics_section_id ON public."LoveMap_Topics" USING btree (section_id)
CREATE UNIQUE INDEX "Messages_pkey" ON public."Messages" USING btree (message_id)
CREATE UNIQUE INDEX "Questions_pkey" ON public."Questions" USING btree (question_id)
CREATE UNIQUE INDEX "Questions_test_id_order_in_test_key" ON public."Questions" USING btree (test_id, order_in_test)
CREATE UNIQUE INDEX "Theory_Blocks_pkey" ON public."TheoryBlocks" USING btree (theory_id)
CREATE UNIQUE INDEX "Links_pkey1" ON public."Links" USING btree (link_id)
CREATE UNIQUE INDEX "User_Test_Attempts_pkey" ON public."User_TestAttempts" USING btree (attempt_id)
CREATE UNIQUE INDEX module_content_pkey ON public."Module_Content" USING btree (id)
CREATE UNIQUE INDEX module_content_module_id_order_key ON public."Module_Content" USING btree (module_id, "order")
CREATE INDEX idx_module_content_order ON public."Module_Content" USING btree (module_id, "order")
CREATE UNIQUE INDEX "User_Theory_Progress_pkey" ON public."User_Theory_Progress" USING btree (id)
CREATE UNIQUE INDEX "User_Theory_Progress_user_id_theory_id_key" ON public."User_Theory_Progress" USING btree (user_id, theory_id)
CREATE UNIQUE INDEX pairingcodes_pkey ON public."PairingCodes" USING btree (code_id)
CREATE UNIQUE INDEX pairingcodes_code_key ON public."PairingCodes" USING btree (code)
CREATE INDEX idx_pairing_codes_code ON public."PairingCodes" USING btree (code)
CREATE INDEX idx_pairing_codes_active ON public."PairingCodes" USING btree (user_id, is_used, expires_at)
CREATE UNIQUE INDEX "Notifications_pkey" ON public."Notifications" USING btree (id)
CREATE INDEX idx_notifications_recipient_id ON public."Notifications" USING btree (recipient_id)
CREATE INDEX idx_notifications_created_at ON public."Notifications" USING btree (created_at DESC)
CREATE INDEX idx_notifications_is_read ON public."Notifications" USING btree (is_read)


-- ===================================
-- CONSTRAINTS
-- ===================================
ALTER TABLE 'Links' ADD CONSTRAINT Links_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('active'::character varying)::text, ('blocked_by_user1'::character varying)::text, ('blocked_by_user2'::character varying)::text, ('declined'::character varying)::text])));
ALTER TABLE 'LoveMap_Sections' ADD CONSTRAINT lovemap_sections_section_type_check CHECK ((section_type = ANY (ARRAY['partner'::text, 'shared'::text])));
ALTER TABLE 'Questions' ADD CONSTRAINT Questions_question_type_check CHECK (((question_type)::text = ANY (ARRAY[('single_choice'::character varying)::text, ('multiple_choice'::character varying)::text, ('free_text'::character varying)::text])));
ALTER TABLE 'Answer_Options' ADD CONSTRAINT Answer_Options_pkey PRIMARY KEY (option_id);
ALTER TABLE 'Answer_Options' ADD CONSTRAINT Answer_Options_question_id_order_in_question_key UNIQUE (question_id, order_in_question);
ALTER TABLE 'Links' ADD CONSTRAINT Links_pkey1 PRIMARY KEY (link_id);
ALTER TABLE 'MediaFiles' ADD CONSTRAINT Media_Files_file_url_key UNIQUE (file_url);
ALTER TABLE 'MediaFiles' ADD CONSTRAINT Media_Files_pkey PRIMARY KEY (file_id);
ALTER TABLE 'Messages' ADD CONSTRAINT Messages_pkey PRIMARY KEY (message_id);
ALTER TABLE 'Modules' ADD CONSTRAINT Modules_order_idx_key UNIQUE (order_idx);
ALTER TABLE 'Modules' ADD CONSTRAINT Modules_pkey PRIMARY KEY (module_id);
ALTER TABLE 'Questions' ADD CONSTRAINT Questions_pkey PRIMARY KEY (question_id);
ALTER TABLE 'Questions' ADD CONSTRAINT Questions_test_id_order_in_test_key UNIQUE (test_id, order_in_test);
ALTER TABLE 'Tests' ADD CONSTRAINT Tests_pkey PRIMARY KEY (test_id);
ALTER TABLE 'TheoryBlocks' ADD CONSTRAINT Theory_Blocks_pkey PRIMARY KEY (theory_id);
ALTER TABLE 'User_Answers' ADD CONSTRAINT User_Answers_attempt_id_question_id_selected_option_id_key UNIQUE (attempt_id, question_id, selected_option_id);
ALTER TABLE 'User_Answers' ADD CONSTRAINT User_Answers_pkey PRIMARY KEY (user_answer_id);
ALTER TABLE 'User_TestAttempts' ADD CONSTRAINT User_Test_Attempts_pkey PRIMARY KEY (attempt_id);
ALTER TABLE 'Users' ADD CONSTRAINT Users_pkey PRIMARY KEY (user_id);
ALTER TABLE 'Users' ADD CONSTRAINT Users_user_id_key UNIQUE (user_id);
ALTER TABLE 'EmotionalBank_Entries' ADD CONSTRAINT emotional_bank_entries_pkey PRIMARY KEY (entry_id);
ALTER TABLE 'EmotionalBank_PartnerRatings' ADD CONSTRAINT emotional_bank_partner_ratings_entry_id_user_id_key UNIQUE (entry_id, user_id);
ALTER TABLE 'EmotionalBank_PartnerRatings' ADD CONSTRAINT emotional_bank_partner_ratings_pkey PRIMARY KEY (rating_id);
ALTER TABLE 'EmotionalBank_RatingRequests' ADD CONSTRAINT emotional_bank_rating_requests_pkey PRIMARY KEY (request_id);
ALTER TABLE 'LoveMap_Items' ADD CONSTRAINT lovemap_items_pkey PRIMARY KEY (item_id);
ALTER TABLE 'LoveMap_Sections' ADD CONSTRAINT lovemap_sections_link_id_section_type_about_user_id_key UNIQUE (link_id, section_type, about_user_id);
ALTER TABLE 'LoveMap_Sections' ADD CONSTRAINT lovemap_sections_pkey PRIMARY KEY (section_id);
ALTER TABLE 'LoveMap_Topics' ADD CONSTRAINT lovemap_topics_pkey PRIMARY KEY (topic_id);
ALTER TABLE 'Answer_Options' ADD CONSTRAINT Answer_Options_question_id_fkey FOREIGN KEY (question_id) REFERENCES 'Questions'(question_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'MediaFiles' ADD CONSTRAINT Media_Files_uploaded_by_user_id_fkey FOREIGN KEY (uploaded_by_user_id) REFERENCES 'Users'(user_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE 'Messages' ADD CONSTRAINT Messages_link_id_fkey FOREIGN KEY (link_id) REFERENCES 'Links'(link_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE 'Messages' ADD CONSTRAINT Messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES 'Users'(user_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE 'Messages' ADD CONSTRAINT Messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES 'Users'(user_id);
ALTER TABLE 'Questions' ADD CONSTRAINT Questions_test_id_fkey FOREIGN KEY (test_id) REFERENCES 'Tests'(test_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'Tests' ADD CONSTRAINT Tests_module_id_fkey FOREIGN KEY (module_id) REFERENCES 'Modules'(module_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE 'TheoryBlocks' ADD CONSTRAINT Theory_Blocks_module_id_fkey FOREIGN KEY (module_id) REFERENCES 'Modules'(module_id) ON DELETE CASCADE;
ALTER TABLE 'User_Answers' ADD CONSTRAINT User_Answers_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES 'User_TestAttempts'(attempt_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'User_Answers' ADD CONSTRAINT User_Answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES 'Questions'(question_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'User_Answers' ADD CONSTRAINT User_Answers_selected_option_id_fkey FOREIGN KEY (selected_option_id) REFERENCES 'Answer_Options'(option_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE 'User_TestAttempts' ADD CONSTRAINT User_Test_Attempts_test_id_fkey FOREIGN KEY (test_id) REFERENCES 'Tests'(test_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'User_TestAttempts' ADD CONSTRAINT User_Test_Attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES 'Users'(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_Entries' ADD CONSTRAINT fk_emotional_bank_entries_link_id FOREIGN KEY (link_id) REFERENCES 'Links'(link_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_Entries' ADD CONSTRAINT fk_emotional_bank_entries_user_id FOREIGN KEY (user_id) REFERENCES 'Users'(user_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_PartnerRatings' ADD CONSTRAINT fk_emotional_bank_partner_ratings_entry_id FOREIGN KEY (entry_id) REFERENCES 'EmotionalBank_Entries'(entry_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_PartnerRatings' ADD CONSTRAINT fk_emotional_bank_partner_ratings_request_id FOREIGN KEY (request_id) REFERENCES 'EmotionalBank_RatingRequests'(request_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_PartnerRatings' ADD CONSTRAINT fk_emotional_bank_partner_ratings_user_id FOREIGN KEY (user_id) REFERENCES 'Users'(user_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_RatingRequests' ADD CONSTRAINT fk_emotional_bank_rating_requests_entry_id FOREIGN KEY (entry_id) REFERENCES 'EmotionalBank_Entries'(entry_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_RatingRequests' ADD CONSTRAINT fk_emotional_bank_rating_requests_from_user_id FOREIGN KEY (from_user_id) REFERENCES 'Users'(user_id) ON DELETE CASCADE;
ALTER TABLE 'EmotionalBank_RatingRequests' ADD CONSTRAINT fk_emotional_bank_rating_requests_to_user_id FOREIGN KEY (to_user_id) REFERENCES 'Users'(user_id) ON DELETE CASCADE;
ALTER TABLE 'LoveMap_Items' ADD CONSTRAINT lovemap_items_last_updated_by_user_id_fkey FOREIGN KEY (last_updated_by_user_id) REFERENCES 'Users'(user_id) ON DELETE SET NULL;
ALTER TABLE 'LoveMap_Items' ADD CONSTRAINT lovemap_items_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES 'LoveMap_Topics'(topic_id) ON DELETE CASCADE;
ALTER TABLE 'LoveMap_Sections' ADD CONSTRAINT lovemap_sections_about_user_id_fkey FOREIGN KEY (about_user_id) REFERENCES 'Users'(user_id) ON DELETE CASCADE;
ALTER TABLE 'LoveMap_Sections' ADD CONSTRAINT lovemap_sections_link_id_fkey FOREIGN KEY (link_id) REFERENCES 'Links'(link_id) ON DELETE CASCADE;
ALTER TABLE 'LoveMap_Topics' ADD CONSTRAINT lovemap_topics_last_updated_by_user_id_fkey FOREIGN KEY (last_updated_by_user_id) REFERENCES 'Users'(user_id) ON DELETE SET NULL;
ALTER TABLE 'LoveMap_Topics' ADD CONSTRAINT lovemap_topics_section_id_fkey FOREIGN KEY (section_id) REFERENCES 'LoveMap_Sections'(section_id) ON DELETE CASCADE;
ALTER TABLE 'Users' ADD CONSTRAINT users_auth_users_fk FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE 'Module_Content' ADD CONSTRAINT module_content_content_type_check CHECK ((content_type = ANY (ARRAY['theory'::text, 'test'::text])));
ALTER TABLE 'Module_Content' ADD CONSTRAINT check_one_content_link CHECK ((((content_type = 'theory'::text) AND (theory_id IS NOT NULL) AND (test_id IS NULL)) OR ((content_type = 'test'::text) AND (test_id IS NOT NULL) AND (theory_id IS NULL))));
ALTER TABLE 'Module_Content' ADD CONSTRAINT module_content_pkey PRIMARY KEY (id);
ALTER TABLE 'Module_Content' ADD CONSTRAINT module_content_module_id_order_key UNIQUE (module_id, 'order');
ALTER TABLE 'Module_Content' ADD CONSTRAINT module_content_module_id_fkey FOREIGN KEY (module_id) REFERENCES 'Modules'(module_id) ON DELETE CASCADE;
ALTER TABLE 'Module_Content' ADD CONSTRAINT module_content_theory_id_fkey FOREIGN KEY (theory_id) REFERENCES 'TheoryBlocks'(theory_id) ON DELETE SET NULL;
ALTER TABLE 'Module_Content' ADD CONSTRAINT module_content_test_id_fkey FOREIGN KEY (test_id) REFERENCES 'Tests'(test_id) ON DELETE SET NULL;
ALTER TABLE 'User_Theory_Progress' ADD CONSTRAINT User_Theory_Progress_pkey PRIMARY KEY (id);
ALTER TABLE 'User_Theory_Progress' ADD CONSTRAINT User_Theory_Progress_user_id_theory_id_key UNIQUE (user_id, theory_id);
ALTER TABLE 'User_Theory_Progress' ADD CONSTRAINT User_Theory_Progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE 'User_Theory_Progress' ADD CONSTRAINT User_Theory_Progress_theory_id_fkey FOREIGN KEY (theory_id) REFERENCES 'TheoryBlocks'(theory_id) ON DELETE CASCADE;
ALTER TABLE 'PairingCodes' ADD CONSTRAINT pairingcodes_pkey PRIMARY KEY (code_id);
ALTER TABLE 'PairingCodes' ADD CONSTRAINT pairingcodes_code_key UNIQUE (code);
ALTER TABLE 'PairingCodes' ADD CONSTRAINT pairingcodes_user_id_fkey FOREIGN KEY (user_id) REFERENCES 'Users'(user_id) ON DELETE CASCADE;
ALTER TABLE 'PairingCodes' ADD CONSTRAINT pairingcodes_used_by_user_id_fkey FOREIGN KEY (used_by_user_id) REFERENCES 'Users'(user_id);
ALTER TABLE 'Links' ADD CONSTRAINT Links_pairing_code_id_fkey FOREIGN KEY (pairing_code_id) REFERENCES 'PairingCodes'(code_id);
ALTER TABLE 'Links' ADD CONSTRAINT Links_initiator_id_fkey FOREIGN KEY (initiator_id) REFERENCES 'Users'(user_id);
ALTER TABLE 'Links' ADD CONSTRAINT Links_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES 'Users'(user_id);
ALTER TABLE 'Notifications' ADD CONSTRAINT Notifications_pkey PRIMARY KEY (id);
ALTER TABLE 'Notifications' ADD CONSTRAINT Notifications_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE 'Notifications' ADD CONSTRAINT Notifications_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES auth.users(id) ON DELETE CASCADE;
