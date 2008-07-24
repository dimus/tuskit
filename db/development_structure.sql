CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_groups_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=779710463 DEFAULT CHARSET=utf8;

CREATE TABLE `iterations` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `objectives` text,
  `start_date` date default '2008-07-23',
  `end_date` date default NULL,
  `work_units` float default '0',
  `report_sent` tinyint(1) default '0',
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `old_stories_added` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_iterations_project_id` (`project_id`),
  KEY `index_iterations_on_start_date` (`start_date`),
  CONSTRAINT `fk_iterations_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=782674376 DEFAULT CHARSET=utf8;

CREATE TABLE `meeting_participants` (
  `id` int(11) NOT NULL auto_increment,
  `meeting_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_meeting_participants_on_meeting_id_and_user_id` (`meeting_id`,`user_id`),
  KEY `fk_meeting_participants_user_id` (`user_id`),
  CONSTRAINT `fk_meeting_participants_meeting_id` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_meeting_participants_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=380072508 DEFAULT CHARSET=utf8;

CREATE TABLE `meetings` (
  `id` int(11) NOT NULL auto_increment,
  `iteration_id` int(11) NOT NULL,
  `meeting_date` date default NULL,
  `length` float default '1',
  `name` varchar(255) default 'Iteration Meeting',
  `notes` text,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_meetings_on_meeting_date` (`meeting_date`),
  KEY `index_meetings_on_iteration_id` (`iteration_id`),
  CONSTRAINT `fk_meetings_iteration_id` FOREIGN KEY (`iteration_id`) REFERENCES `iterations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=885441772 DEFAULT CHARSET=utf8;

CREATE TABLE `memberships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `group_id` int(11) default NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_memberships_on_user_id_and_group_id` (`user_id`,`group_id`),
  KEY `fk_memberships_group_id` (`group_id`),
  CONSTRAINT `fk_memberships_group_id` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_memberships_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=838754059 DEFAULT CHARSET=utf8;

CREATE TABLE `project_members` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `active` tinyint(1) default '1',
  `send_iteration_report` tinyint(1) default '1',
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_project_members_on_project_id_and_user_id` (`project_id`,`user_id`),
  KEY `fk_project_members_user_id` (`user_id`),
  CONSTRAINT `fk_project_members_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_project_members_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=644062688 DEFAULT CHARSET=utf8;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `tracker_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `tracker_project` varchar(255) default NULL,
  `start_date` datetime default NULL,
  `end_date` datetime default NULL,
  `iteration_length` int(11) default '14',
  `progress_reports` tinyint(1) default '1',
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_projects_on_name` (`name`),
  KEY `fk_projects_tracker_id` (`tracker_id`),
  KEY `fk_projects_parent_id` (`parent_id`),
  CONSTRAINT `fk_projects_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_projects_tracker_id` FOREIGN KEY (`tracker_id`) REFERENCES `trackers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=878919101 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `stories` (
  `id` int(11) NOT NULL auto_increment,
  `iteration_id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `work_units_est` float default '0',
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `completed` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_stories_iteration_id` (`iteration_id`),
  CONSTRAINT `fk_stories_iteration_id` FOREIGN KEY (`iteration_id`) REFERENCES `iterations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=337303993 DEFAULT CHARSET=utf8;

CREATE TABLE `task_owners` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `agile_task_id` int(11) default NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_task_owners_on_agile_task_id_and_user_id` (`agile_task_id`,`user_id`),
  KEY `fk_task_owners_user_id` (`user_id`),
  CONSTRAINT `fk_task_owners_agile_task_id` FOREIGN KEY (`agile_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_task_owners_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=996332878 DEFAULT CHARSET=utf8;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `tracker_ticket_id` int(11) default NULL,
  `tracker_ticket_submitter` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `notes` text,
  `completion_date` date default NULL,
  `bug` tinyint(1) default NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `tracker_id` int(11) default NULL,
  `project_id` int(11) default NULL,
  `story_id` int(11) default NULL,
  `task_units` float default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_tasks_on_tracker_ticket_id` (`tracker_ticket_id`),
  KEY `fk_tasks_project_id` (`project_id`),
  KEY `fk_tasks_story_id` (`story_id`),
  KEY `fk_tasks_tracker_id` (`tracker_id`),
  CONSTRAINT `fk_tasks_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tasks_story_id` FOREIGN KEY (`story_id`) REFERENCES `stories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tasks_tracker_id` FOREIGN KEY (`tracker_id`) REFERENCES `trackers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1021361447 DEFAULT CHARSET=utf8;

CREATE TABLE `trackers` (
  `id` int(11) NOT NULL auto_increment,
  `application` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `uri` varchar(255) default NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_trackers_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=878919101 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=1015383705 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20080715051943');

INSERT INTO schema_migrations (version) VALUES ('20080716234045');

INSERT INTO schema_migrations (version) VALUES ('20080719215202');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');