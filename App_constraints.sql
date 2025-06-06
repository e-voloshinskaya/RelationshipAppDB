ALTER TABLE Links ADD CONSTRAINT Links_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('active'::character varying)::text, ('blocked_by_user1'::character varying)::text, ('blocked_by_user2'::character varying)::text, ('declined'::character varying)::text])));
ALTER TABLE Links ADD CONSTRAINT link_initiator_must_be_participant CHECK (((initiator_user_id = user1_id) OR (initiator_user_id = user2_id)));
ALTER TABLE Links ADD CONSTRAINT users_must_be_different_in_link CHECK ((user1_id <> user2_id));
ALTER TABLE LoveMap_Sections ADD CONSTRAINT lovemap_sections_section_type_check CHECK ((section_type = ANY (ARRAY['partner'::text, 'shared'::text])));
ALTER TABLE Questions ADD CONSTRAINT Questions_question_type_check CHECK (((question_type)::text = ANY (ARRAY[('single_choice'::character varying)::text, ('multiple_choice'::character varying)::text, ('free_text'::character varying)::text])));
ALTER TABLE Answer_Options ADD CONSTRAINT Answer_Options_pkey PRIMARY KEY (option_id);
ALTER TABLE Answer_Options ADD CONSTRAINT Answer_Options_question_id_order_in_question_key UNIQUE (question_id, order_in_question);
ALTER TABLE Links ADD CONSTRAINT Links_pkey1 PRIMARY KEY (link_id);
ALTER TABLE MediaFiles ADD CONSTRAINT Media_Files_file_url_key UNIQUE (file_url);
ALTER TABLE MediaFiles ADD CONSTRAINT Media_Files_pkey PRIMARY KEY (file_id);
ALTER TABLE Messages ADD CONSTRAINT Messages_pkey PRIMARY KEY (message_id);
ALTER TABLE Modules ADD CONSTRAINT Modules_order_idx_key UNIQUE (order_idx);
ALTER TABLE Modules ADD CONSTRAINT Modules_pkey PRIMARY KEY (module_id);
ALTER TABLE Questions ADD CONSTRAINT Questions_pkey PRIMARY KEY (question_id);
ALTER TABLE Questions ADD CONSTRAINT Questions_test_id_order_in_test_key UNIQUE (test_id, order_in_test);
ALTER TABLE Tests ADD CONSTRAINT Tests_pkey PRIMARY KEY (test_id);
ALTER TABLE TheoryBlocks ADD CONSTRAINT Theory_Blocks_pkey PRIMARY KEY (theory_id);
ALTER TABLE TheoryBlocks ADD CONSTRAINT Theory_Blocks_theory_order_key UNIQUE (theory_order);
ALTER TABLE User_Answers ADD CONSTRAINT User_Answers_attempt_id_question_id_selected_option_id_key UNIQUE (attempt_id, question_id, selected_option_id);
ALTER TABLE User_Answers ADD CONSTRAINT User_Answers_pkey PRIMARY KEY (user_answer_id);
ALTER TABLE User_TestAttempts ADD CONSTRAINT User_Test_Attempts_pkey PRIMARY KEY (attempt_id);
ALTER TABLE Users ADD CONSTRAINT Users_pkey PRIMARY KEY (user_id);
ALTER TABLE Users ADD CONSTRAINT Users_user_id_key UNIQUE (user_id);
ALTER TABLE EmotionalBank_Entries ADD CONSTRAINT emotional_bank_entries_pkey PRIMARY KEY (entry_id);
ALTER TABLE EmotionalBank_PartnerRatings ADD CONSTRAINT emotional_bank_partner_ratings_entry_id_user_id_key UNIQUE (entry_id, user_id);
ALTER TABLE EmotionalBank_PartnerRatings ADD CONSTRAINT emotional_bank_partner_ratings_pkey PRIMARY KEY (rating_id);
ALTER TABLE EmotionalBank_RatingRequests ADD CONSTRAINT emotional_bank_rating_requests_pkey PRIMARY KEY (request_id);
ALTER TABLE LoveMap_Items ADD CONSTRAINT lovemap_items_pkey PRIMARY KEY (item_id);
ALTER TABLE LoveMap_Sections ADD CONSTRAINT lovemap_sections_link_id_section_type_about_user_id_key UNIQUE (link_id, section_type, about_user_id);
ALTER TABLE LoveMap_Sections ADD CONSTRAINT lovemap_sections_pkey PRIMARY KEY (section_id);
ALTER TABLE LoveMap_Topics ADD CONSTRAINT lovemap_topics_pkey PRIMARY KEY (topic_id);
ALTER TABLE Answer_Options ADD CONSTRAINT Answer_Options_question_id_fkey FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Links ADD CONSTRAINT Links_initiator_user_id_fkey FOREIGN KEY (initiator_user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Links ADD CONSTRAINT Links_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Links ADD CONSTRAINT Links_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE MediaFiles ADD CONSTRAINT Media_Files_uploaded_by_user_id_fkey FOREIGN KEY (uploaded_by_user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE Messages ADD CONSTRAINT Messages_link_id_fkey FOREIGN KEY (link_id) REFERENCES Links(link_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE Messages ADD CONSTRAINT Messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE Messages ADD CONSTRAINT Messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES Users(user_id);
ALTER TABLE Questions ADD CONSTRAINT Questions_test_id_fkey FOREIGN KEY (test_id) REFERENCES Tests(test_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Tests ADD CONSTRAINT Tests_module_id_fkey FOREIGN KEY (module_id) REFERENCES Modules(module_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE TheoryBlocks ADD CONSTRAINT Theory_Blocks_module_id_fkey FOREIGN KEY (module_id) REFERENCES Modules(module_id) ON DELETE CASCADE;
ALTER TABLE User_Answers ADD CONSTRAINT User_Answers_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES User_TestAttempts(attempt_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE User_Answers ADD CONSTRAINT User_Answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE User_Answers ADD CONSTRAINT User_Answers_selected_option_id_fkey FOREIGN KEY (selected_option_id) REFERENCES Answer_Options(option_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE User_TestAttempts ADD CONSTRAINT User_Test_Attempts_test_id_fkey FOREIGN KEY (test_id) REFERENCES Tests(test_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE User_TestAttempts ADD CONSTRAINT User_Test_Attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES Users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE EmotionalBank_Entries ADD CONSTRAINT fk_emotional_bank_entries_link_id FOREIGN KEY (link_id) REFERENCES Links(link_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_Entries ADD CONSTRAINT fk_emotional_bank_entries_user_id FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_PartnerRatings ADD CONSTRAINT fk_emotional_bank_partner_ratings_entry_id FOREIGN KEY (entry_id) REFERENCES EmotionalBank_Entries(entry_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_PartnerRatings ADD CONSTRAINT fk_emotional_bank_partner_ratings_request_id FOREIGN KEY (request_id) REFERENCES EmotionalBank_RatingRequests(request_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_PartnerRatings ADD CONSTRAINT fk_emotional_bank_partner_ratings_user_id FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_RatingRequests ADD CONSTRAINT fk_emotional_bank_rating_requests_entry_id FOREIGN KEY (entry_id) REFERENCES EmotionalBank_Entries(entry_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_RatingRequests ADD CONSTRAINT fk_emotional_bank_rating_requests_from_user_id FOREIGN KEY (from_user_id) REFERENCES Users(user_id) ON DELETE CASCADE;
ALTER TABLE EmotionalBank_RatingRequests ADD CONSTRAINT fk_emotional_bank_rating_requests_to_user_id FOREIGN KEY (to_user_id) REFERENCES Users(user_id) ON DELETE CASCADE;
ALTER TABLE LoveMap_Items ADD CONSTRAINT lovemap_items_last_updated_by_user_id_fkey FOREIGN KEY (last_updated_by_user_id) REFERENCES Users(user_id) ON DELETE SET NULL;
ALTER TABLE LoveMap_Items ADD CONSTRAINT lovemap_items_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES LoveMap_Topics(topic_id) ON DELETE CASCADE;
ALTER TABLE LoveMap_Sections ADD CONSTRAINT lovemap_sections_about_user_id_fkey FOREIGN KEY (about_user_id) REFERENCES Users(user_id) ON DELETE CASCADE;
ALTER TABLE LoveMap_Sections ADD CONSTRAINT lovemap_sections_link_id_fkey FOREIGN KEY (link_id) REFERENCES Links(link_id) ON DELETE CASCADE;
ALTER TABLE LoveMap_Topics ADD CONSTRAINT lovemap_topics_last_updated_by_user_id_fkey FOREIGN KEY (last_updated_by_user_id) REFERENCES Users(user_id) ON DELETE SET NULL;
ALTER TABLE LoveMap_Topics ADD CONSTRAINT lovemap_topics_section_id_fkey FOREIGN KEY (section_id) REFERENCES LoveMap_Sections(section_id) ON DELETE CASCADE;
ALTER TABLE Users ADD CONSTRAINT users_auth_users_fk FOREIGN KEY (user_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE;