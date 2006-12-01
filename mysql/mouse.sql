# MySQL-Front Dump 2.5
#
# Host: 127.0.0.1   Database: mouse
# --------------------------------------------------------
# Server version 4.1.16-max

USE mouse;


#
# Table structure for table 'acl'
#

DROP TABLE IF EXISTS acl;
CREATE TABLE acl (
  object_id int(10) unsigned NOT NULL default '0',
  auser_id int(10) unsigned NOT NULL default '0',
  rights int(10) unsigned NOT NULL default '0',
  UNIQUE KEY auser_id (auser_id,object_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'acl'
#

INSERT INTO acl (object_id, auser_id, rights) VALUES("1", "1", "18");
INSERT INTO acl (object_id, auser_id, rights) VALUES("2", "1", "18");
INSERT INTO acl (object_id, auser_id, rights) VALUES("3", "1", "18");
INSERT INTO acl (object_id, auser_id, rights) VALUES("4", "1", "18");
INSERT INTO acl (object_id, auser_id, rights) VALUES("1", "2", "255");


#
# Table structure for table 'aevent_log'
#

DROP TABLE IF EXISTS aevent_log;
CREATE TABLE aevent_log (
  aevent_log_id int(10) unsigned NOT NULL auto_increment,
  auser_id int(10) unsigned NOT NULL default '0',
  event_type mediumint(9) NOT NULL default '256',
  stat mediumint(9) NOT NULL default '0',
  dt datetime NOT NULL default '0000-00-00 00:00:00',
  content varchar(255) collate cp1251_bin default NULL,
  PRIMARY KEY  (aevent_log_id),
  KEY ix_aevent_log_0 (auser_id,dt)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'aevent_log'
#

INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("4", "3", "1", "0", "2006-05-18 11:05:40", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("5", "3", "1", "128", "2006-06-06 14:52:32", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("94", "5", "256", "0", "2006-08-14 14:38:13", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("95", "5", "1", "0", "2006-08-14 14:38:13", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("96", "5", "2", "0", "2006-08-14 14:39:42", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("218", "4", "1", "0", "2006-10-13 14:01:22", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("217", "4", "1", "0", "2006-10-13 01:05:14", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("216", "4", "2", "0", "2006-10-13 01:04:58", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("215", "4", "1", "0", "2006-10-12 21:03:33", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("104", "5", "1", "0", "2006-08-14 15:08:07", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("105", "5", "128", "0", "2006-08-14 15:08:32", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("106", "5", "144", "0", "2006-08-14 15:08:43", "127.0.0.1:NULL, prev_name: mmm");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("107", "5", "144", "0", "2006-08-14 15:09:00", "127.0.0.1:NULL, prev_name: mmm2");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("108", "5", "128", "0", "2006-08-14 15:11:24", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("109", "5", "128", "32768", "2006-08-14 15:31:01", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("110", "5", "128", "32768", "2006-08-14 15:31:43", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("111", "5", "128", "32768", "2006-08-14 15:34:52", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("112", "5", "128", "0", "2006-08-14 15:35:06", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("113", "5", "2", "0", "2006-08-14 15:36:37", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("238", "4", "1", "0", "2006-10-28 17:05:49", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("239", "4", "1", "0", "2006-10-29 12:20:56", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("240", "4", "1", "0", "2006-11-04 23:20:01", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("241", "4", "1", "0", "2006-11-05 12:55:42", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("233", "4", "1", "0", "2006-10-22 23:00:39", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("234", "4", "1", "0", "2006-10-23 11:02:15", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("235", "4", "2", "0", "2006-10-23 11:26:01", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("236", "4", "1", "0", "2006-10-23 22:39:21", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("237", "4", "1", "0", "2006-10-27 22:55:31", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("143", "0", "1", "128", "2006-08-15 15:58:17", "192.168.1.200:NULL, name=Andrey");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("144", "6", "256", "0", "2006-08-15 15:59:11", "192.168.1.200:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("145", "6", "1", "0", "2006-08-15 15:59:11", "192.168.1.200:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("212", "4", "1", "0", "2006-10-12 19:08:05", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("213", "4", "1", "0", "2006-10-12 19:09:22", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("214", "4", "2", "0", "2006-10-12 21:02:55", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("232", "4", "1", "0", "2006-10-22 21:30:57", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("219", "4", "2", "0", "2006-10-14 04:53:15", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("186", "7", "256", "0", "2006-09-30 16:05:59", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("187", "7", "1", "0", "2006-09-30 16:05:59", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("188", "7", "2", "0", "2006-09-30 16:06:11", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("220", "4", "1", "0", "2006-10-14 04:56:24", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("221", "4", "1", "0", "2006-10-14 12:26:04", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("222", "4", "1", "0", "2006-10-14 12:30:23", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("223", "4", "2", "0", "2006-10-19 19:59:38", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("224", "4", "1", "0", "2006-10-19 19:59:53", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("225", "4", "2", "0", "2006-10-20 14:55:41", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("226", "4", "1", "0", "2006-10-20 14:55:56", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("227", "4", "2", "0", "2006-10-20 17:26:08", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("228", "4", "1", "0", "2006-10-20 17:26:14", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("229", "4", "2", "0", "2006-10-22 21:16:09", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("230", "4", "1", "0", "2006-10-22 21:21:10", "127.0.0.1:NULL");
INSERT INTO aevent_log (aevent_log_id, auser_id, event_type, stat, dt, content) VALUES("231", "4", "2", "0", "2006-10-22 21:30:53", "127.0.0.1:NULL");


#
# Table structure for table 'asession'
#

DROP TABLE IF EXISTS asession;
CREATE TABLE asession (
  asession_id int(10) unsigned NOT NULL auto_increment,
  auser_id int(10) unsigned NOT NULL default '0',
  sid varchar(64) collate cp1251_bin NOT NULL default '',
  auid varchar(64) collate cp1251_bin NOT NULL default '',
  dt_access datetime NOT NULL default '0000-00-00 00:00:00',
  dt_logon datetime default NULL,
  dt_logout datetime default NULL,
  PRIMARY KEY  (asession_id),
  KEY ix_asession_0 (auser_id),
  KEY ix_asession_1 (auid,dt_access),
  KEY ix_asession_2 (dt_access)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'asession'
#

INSERT INTO asession (asession_id, auser_id, sid, auid, dt_access, dt_logon, dt_logout) VALUES("1", "3", "127.0.0.1:NULL=3dd6bb8c59dc575b8a04436c403b282d", "127.0.0.1:NULL=ba6edd7d85eaf26a8c67ad395a6b268f", "2006-05-18 15:56:07", "2006-05-18 11:05:40", NULL);
INSERT INTO asession (asession_id, auser_id, sid, auid, dt_access, dt_logon, dt_logout) VALUES("14", "6", "192.168.1.200:NULL=61ed6361bd9027e682d2278127bfacd4", "192.168.1.200:NULL=222887d78c80dd50689852d63a7a5c81", "2006-08-15 15:59:11", "2006-08-15 15:59:11", NULL);
INSERT INTO asession (asession_id, auser_id, sid, auid, dt_access, dt_logon, dt_logout) VALUES("29", "4", "127.0.0.1:NULL=dcc6aa239fea86a5b105acecb7c2e202", "127.0.0.1:NULL=55544ede02e7e89f1c60643aaad0ff41", "2006-12-01 11:56:39", "2006-10-20 17:26:14", "2006-10-20 17:26:08");
INSERT INTO asession (asession_id, auser_id, sid, auid, dt_access, dt_logon, dt_logout) VALUES("33", "0", "127.0.0.1:NULL=d5aa95671205f95e5b0a1b2d933a64f2", "127.0.0.1:NULL=1b31630bc33cc7b7b45fb4d232b7c79e", "2006-11-30 10:57:36", NULL, NULL);
INSERT INTO asession (asession_id, auser_id, sid, auid, dt_access, dt_logon, dt_logout) VALUES("27", "4", "127.0.0.1:NULL=e8edf911c02e376f0fcc710a9c870289", "127.0.0.1:NULL=d868ed8d206fee98ad9eb54e5fd14ea0", "2006-11-09 22:29:13", "2006-11-05 12:55:42", "2006-10-23 11:26:01");


#
# Table structure for table 'auser'
#

DROP TABLE IF EXISTS auser;
CREATE TABLE auser (
  auser_id int(10) unsigned NOT NULL auto_increment,
  auser_type_id tinyint(3) unsigned NOT NULL default '0',
  rights int(10) unsigned NOT NULL default '0',
  name varchar(127) collate cp1251_bin NOT NULL default '',
  description text collate cp1251_bin,
  email varchar(63) collate cp1251_bin NOT NULL default '',
  passwd varchar(63) collate cp1251_bin NOT NULL default '',
  new_passwd varchar(63) collate cp1251_bin default NULL,
  dt_register datetime NOT NULL default '0000-00-00 00:00:00',
  dt_logon datetime default NULL,
  dt_logout datetime default NULL,
  is_published tinyint(3) unsigned NOT NULL default '1',
  is_default tinyint(3) unsigned NOT NULL default '0',
  connections_limit tinyint(3) unsigned NOT NULL default '1',
  event_type mediumint(8) unsigned NOT NULL default '0',
  fio varchar(100) collate cp1251_bin NOT NULL default '',
  www varchar(255) collate cp1251_bin NOT NULL default '',
  adress text collate cp1251_bin NOT NULL,
  dt_birth date NOT NULL default '0000-00-00',
  work_place varchar(100) collate cp1251_bin NOT NULL default '',
  work_position varchar(100) collate cp1251_bin NOT NULL default '',
  telefon bigint(20) NOT NULL default '0',
  PRIMARY KEY  (auser_id),
  UNIQUE KEY auser_type_id (auser_type_id,name),
  KEY ix_auser_0 (auser_type_id,is_published,dt_logon),
  KEY ix_auser_1 (dt_register),
  KEY ix_auser_2 (auser_type_id,name,passwd),
  KEY ix_auser_3 (auser_type_id,email,name)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'auser'
#

INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("1", "2", "143", "Owner", "Создатель объекта", "owner", "onwner", NULL, "2006-05-18 10:39:47", NULL, NULL, "1", "0", "1", "0", "", "", "", "0000-00-00", "", "", "0");
INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("2", "1", "143", "Admins", "Группа администраторов системы", "group", "group", NULL, "2006-05-18 10:39:47", NULL, NULL, "1", "0", "1", "0", "", "", "", "0000-00-00", "", "", "0");
INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("3", "0", "16777215", "admin", "", "misha@design.ru", "$apr1$aUGmfiNe$NLmZ4.gUZah28BBEeaY/N1", NULL, "2006-05-18 10:39:47", "2006-05-18 11:05:40", NULL, "1", "0", "1", "0", "", "", "", "0000-00-00", "", "", "0");
INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("4", "0", "16777215", "klen", "", "klen.com@mail.ru", "$apr1$W/TxeMeL$qojuH1t0cEcBWy9YoCVh6.", NULL, "2006-05-18 11:05:02", "2006-11-05 12:55:42", "2006-10-23 11:26:01", "1", "0", "1", "147", "Кленов Кирилл Эдуардович", "", "", "1979-12-31", "Не указан", "Самый главный", "89630210959");
INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("11", "0", "1", "test", "Тестовый пользователь", "test@test.ru", "$apr1$G16Om/zP$mNJ4eAEotblrV1yivrSqS0", NULL, "2006-11-08 00:31:52", NULL, NULL, "1", "0", "1", "0", "", "", "", "0000-00-00", "", "", "0");
INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("5", "0", "143", "Муза Владимировна", "Сирота", "musa@mail.ru", "$apr1$JfO6iFn8$T3ReoxZZKWwz1JFx2P72Q.", NULL, "2006-10-15 12:04:48", "2006-10-15 12:30:40", NULL, "1", "0", "1", "147", "", "", "", "0000-00-00", "Не указан", "", "0");
INSERT INTO auser (auser_id, auser_type_id, rights, name, description, email, passwd, new_passwd, dt_register, dt_logon, dt_logout, is_published, is_default, connections_limit, event_type, fio, www, adress, dt_birth, work_place, work_position, telefon) VALUES("10", "1", "1", "Testers", "Группа тестовых пользователей", "group", "", NULL, "2006-11-08 00:14:38", NULL, NULL, "1", "0", "1", "0", "", "", "", "0000-00-00", "", "", "0");


#
# Table structure for table 'auser_to_auser'
#

DROP TABLE IF EXISTS auser_to_auser;
CREATE TABLE auser_to_auser (
  auser_id int(10) unsigned NOT NULL default '0',
  parent_id int(10) unsigned NOT NULL default '0',
  rights int(10) unsigned NOT NULL default '0',
  UNIQUE KEY ix_auser_to_auser_0 (auser_id,parent_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'auser_to_auser'
#

INSERT INTO auser_to_auser (auser_id, parent_id, rights) VALUES("3", "2", "0");
INSERT INTO auser_to_auser (auser_id, parent_id, rights) VALUES("5", "2", "0");
INSERT INTO auser_to_auser (auser_id, parent_id, rights) VALUES("4", "2", "0");
INSERT INTO auser_to_auser (auser_id, parent_id, rights) VALUES("11", "10", "0");


#
# Table structure for table 'm_b_article'
#

DROP TABLE IF EXISTS m_b_article;
CREATE TABLE m_b_article (
  article_type_id int(11) NOT NULL default '0',
  article_id int(11) NOT NULL auto_increment,
  title varchar(255) collate cp1251_bin default NULL,
  lead text collate cp1251_bin NOT NULL,
  uri varchar(255) collate cp1251_bin default NULL,
  url varchar(255) collate cp1251_bin default NULL,
  is_not_empty tinyint(4) default '0',
  body text collate cp1251_bin,
  is_published tinyint(4) default '0',
  dt datetime NOT NULL default '0000-00-00 00:00:00',
  dt_published datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (article_type_id,article_id),
  KEY ix_m_article_0 (article_type_id,is_published,dt_published,dt)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_b_article'
#

INSERT INTO m_b_article (article_type_id, article_id, title, lead, uri, url, is_not_empty, body, is_published, dt, dt_published) VALUES("1", "1", "Тестовая новость", "<p>Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. </p>\r\n<p>Просто новость для проверки движка. Просто новость для проверки движка. Просто новость для проверки движка. </p>", NULL, NULL, "1", "Здесь текст тестовой новости", "1", "2006-10-10 00:00:00", "2006-10-10 00:00:00");
INSERT INTO m_b_article (article_type_id, article_id, title, lead, uri, url, is_not_empty, body, is_published, dt, dt_published) VALUES("1", "2", "Проверка", "бла бла", NULL, NULL, "1", "апорапо", "0", "2006-10-12 00:00:00", "2006-10-12 00:00:00");
INSERT INTO m_b_article (article_type_id, article_id, title, lead, uri, url, is_not_empty, body, is_published, dt, dt_published) VALUES("1", "3", "митапор", "апрапрапра", NULL, NULL, "1", "апрапрапр", "0", "2006-10-09 00:00:00", "2006-10-08 00:00:00");


#
# Table structure for table 'm_b_article_type'
#

DROP TABLE IF EXISTS m_b_article_type;
CREATE TABLE m_b_article_type (
  article_type_id int(11) NOT NULL auto_increment,
  path varchar(255) collate cp1251_bin NOT NULL default '',
  name varchar(255) collate cp1251_bin NOT NULL default '',
  irf int(9) default NULL,
  PRIMARY KEY  (article_type_id),
  UNIQUE KEY path (path)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_b_article_type'
#

INSERT INTO m_b_article_type (article_type_id, path, name, irf) VALUES("1", "/", "Новости на главной", "255");


#
# Table structure for table 'm_b_time_control'
#

DROP TABLE IF EXISTS m_b_time_control;
CREATE TABLE m_b_time_control (
  id int(11) NOT NULL auto_increment,
  user_id int(11) NOT NULL default '0',
  date date NOT NULL default '0000-00-00',
  time time NOT NULL default '00:00:00',
  event int(11) NOT NULL default '0',
  out_place varchar(255) collate cp1251_bin NOT NULL default '',
  comment text collate cp1251_bin NOT NULL,
  PRIMARY KEY  (id),
  KEY id (id,user_id,date)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_b_time_control'
#

INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("16", "4", "2006-08-15", "10:00:02", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("17", "4", "2006-08-15", "10:00:26", "2", "Калинина 12", "Профилактика принтера");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("18", "4", "2006-08-15", "10:07:06", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("19", "4", "2006-08-15", "10:10:35", "2", "Гаражная", "Сломался ИБП");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("20", "4", "2006-08-15", "10:10:41", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("21", "4", "2006-08-15", "10:46:46", "2", "Обед", "Обед");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("22", "4", "2006-08-15", "10:51:00", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("23", "4", "2006-08-15", "12:58:20", "2", "Домой", "Обедаю");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("24", "4", "2006-08-15", "13:04:35", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("25", "4", "2006-08-15", "13:08:39", "2", "Домой", "Обедать");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("26", "4", "2006-08-15", "15:43:18", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("27", "6", "2006-08-15", "15:59:17", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("28", "6", "2006-08-15", "16:00:01", "2", "АБК", "Просто так");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("29", "6", "2006-08-15", "16:00:20", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("30", "4", "2006-08-15", "16:03:45", "2", "На улице", "Гуляю");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("31", "6", "2006-08-15", "16:05:25", "2", "тест", "тестовая причина");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("32", "6", "2006-08-15", "16:06:22", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("33", "4", "2006-08-15", "17:41:30", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("34", "4", "2006-08-16", "09:21:37", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("35", "4", "2006-08-16", "10:16:02", "2", "АБК", "принтер сломался");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("36", "4", "2006-08-16", "11:21:07", "3", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("37", "4", "2006-08-17", "09:28:55", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("38", "4", "2006-08-17", "09:29:51", "2", "Калинина 12", "Сломался принтер");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("39", "4", "2006-09-27", "09:48:58", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("40", "4", "2006-09-28", "00:09:33", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("41", "4", "2006-09-29", "00:49:04", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("42", "4", "2006-09-30", "00:43:10", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("43", "7", "2006-09-30", "16:06:02", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("44", "4", "2006-10-01", "03:41:28", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("45", "4", "2006-10-02", "01:49:05", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("46", "4", "2006-10-03", "01:14:26", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("47", "4", "2006-10-04", "02:10:32", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("48", "4", "2006-10-05", "09:50:12", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("49", "4", "2006-10-06", "00:34:00", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("50", "4", "2006-10-07", "23:47:56", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("51", "4", "2006-10-08", "00:18:52", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("52", "4", "2006-10-09", "10:51:05", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("53", "4", "2006-10-10", "11:36:02", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("54", "4", "2006-10-11", "01:21:05", "1", "Калинина 19", "Прибыл на работу");
INSERT INTO m_b_time_control (id, user_id, date, time, event, out_place, comment) VALUES("55", "4", "2006-10-12", "09:28:00", "1", "Калинина 19", "Прибыл на работу");


#
# Table structure for table 'm_b_time_out'
#

DROP TABLE IF EXISTS m_b_time_out;
CREATE TABLE m_b_time_out (
  id int(11) NOT NULL auto_increment,
  user_id int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_b_time_out'
#



#
# Table structure for table 'm_block'
#

DROP TABLE IF EXISTS m_block;
CREATE TABLE m_block (
  block_id int(11) NOT NULL auto_increment,
  data_process_id tinyint(4) NOT NULL default '0',
  name varchar(40) collate cp1251_bin NOT NULL default '',
  data_type_id tinyint(4) NOT NULL default '0',
  is_not_empty char(1) collate cp1251_bin NOT NULL default '0',
  is_published char(1) collate cp1251_bin NOT NULL default '0',
  is_hide_published char(1) collate cp1251_bin NOT NULL default '0',
  is_shared char(1) collate cp1251_bin NOT NULL default '0',
  is_parsed_manual char(1) collate cp1251_bin NOT NULL default '0',
  dt_update date NOT NULL default '0000-00-00',
  attr text collate cp1251_bin NOT NULL,
  description varchar(255) collate cp1251_bin NOT NULL default '',
  data text collate cp1251_bin NOT NULL,
  PRIMARY KEY  (block_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_block'
#

INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("1", "3", "site:auth:login", "5", "1", "1", "0", "0", "0", "2006-11-15", "", "Информация о залогиненном пользователе, вывод логина", "<name>Пользователь</name>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("2", "0", "site:design:topmenu", "3", "1", "1", "0", "1", "0", "2006-10-17", "Style[0]", "Выводит основное меню", "<menu></menu>\r\n\r\n");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("3", "0", "site:map", "3", "1", "1", "0", "1", "0", "2006-11-15", " ", "Карта сайта", "<block_content><map></map></block_content>  ");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("4", "0", "site:option", "3", "1", "1", "", "1", "", "2006-10-05", "Style[0]Cache[300]", "Панель управления", "<block_content>\r\n<buttons>\r\n<button image=\"24_xml.gif\"   name=\"xml\"   alt=\"Вывести xml страницы\" onClick=\"window.open(\'{$system/parser/request/uri}?mode=xml\', \'xml\')\" />\r\n<button image=\"24_debug.gif\"   name=\"debug\"   alt=\"Режим отладки страницы\" onClick=\"window.open(\'{$system/parser/request/uri}?mode=debug\', \'debug\')\" />\r\n<button image=\"24_nocache.gif\"   name=\"nocache\"   alt=\"Вывести без кэша\" onClick=\"window.open(\'{$system/parser/request/uri}?mode=nocache\', \'nocache\')\" />\r\n<button image=\"24_ncdebug.gif\"   name=\"ncdebug\"   alt=\"Отладка без кэша\" onClick=\"window.open(\'{$system/parser/request/uri}?mode=ncdebug\', \'nocache\')\" />\r\n</buttons>\r\n</block_content>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("228", "0", "object:design:code", "9", "0", "1", "0", "0", "0", "2006-11-05", "Style[0]", "Подгрузка java скриптов", "<js_head> $(document).ready(function() { $(\'#loadingAjax\').hide(); }); </js_head>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("5", "0", "site:design:badges", "4", "1", "1", "0", "1", "0", "2006-10-22", "Style[0]", "Блок кнопок", "<badges>\n<br/><br/>\n    <li class=\"buttons\"><a href=\"http://www.ru.eomy.net/\"><img src=\"http://www.ru.eomy.net/eomy.net.gif\" border=\"0\" alt=\"EOMY.NET\"/></a></li>\n    <li class=\"buttons\"><a href=\"http://klen.zoxt.net/\"><img src=\"/images/mouse_80x15.jpg\" border=\"0\" alt=\"Powered by Mouse CMS\"/></a></li>\n    <li class=\"buttons\"><a href=\"http://www.parser.ru/\"><img src=\"/images/badges/parser.gif\" border=\"0\" alt=\"Powered by Parser\"/></a></li>\n    <li class=\"buttons\"><a href=\"http://www.apache.org/\"><img src=\"/images/badges/apache.png\" border=\"0\" alt=\"Powered by Apache\"/></a></li>\n    <li class=\"buttons\"><a href=\"http://www.mysql.org/\"><img src=\"/images/badges/mysql.png\" border=\"0\" alt=\"Powered by MySQL\"/></a></li>\n</badges>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("6", "11", "site:register", "5", "0", "1", "", "1", "0", "2006-09-30", "", "Регистрация и изменение личных данных пользователей", "");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("12", "1", "admin:object.tree", "1", "1", "1", "0", "1", "0", "2006-10-06", "Style[0]", "Управление объектами", "<block_content>\r\n<jq_object>\r\n  <branche id=\"0\" name=\"Корневое пространство\" parent_id=\"0\" thread_id=\"0\" path=\"\">\r\n    <system:method name=\"tree\">hash_name[OBJECTS_HASH_TREE]thread_id[0]</system:method>\r\n  </branche>\r\n</jq_object>\r\n</block_content>\r\n");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("224", "32", "site:content:articles", "7", "1", "1", "0", "1", "0", "2006-10-22", "Style[0]", "Управление статьями, новости, анонсами и тп.", "<block_content>\n{$system/parser/form/year}\n{$system/parser/form/month}\nпроверка\n</block_content>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("31", "4", "site:content:aforizm", "7", "0", "1", "0", "1", "0", "2006-10-17", "Style[0]", "Выводит случайный афоризм", "");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("208", "13", "site:content:weather", "7", "1", "1", "0", "1", "0", "2006-10-19", "", "test", "test");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("223", "0", "object:error", "3", "1", "1", "0", "0", "0", "2006-11-15", "", "Блок обрабатывающий информацию об ошибках системы", "<block_content> <h3>Тип ошибки: </h3><br/> <p> <system:method name=\"if\">name[]value[cms.404]true[Запрашиваемая вами страница <b>\'\'</b> недоступна, пожалуйста воспользуйтесь картой сайта.]</system:method>        </p> </block_content>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("227", "0", "object:global:design:code", "4", "1", "1", "0", "1", "0", "2006-10-22", "Style[0]", "блок подключает java скрипты сайта", "<js source=\"/js/jq/jq.js\"/>\n<js source=\"/js/jq/iutil.js\"/>\n<js source=\"/js/jq/ifx.js\"/>\n<js source=\"/js/jq/ifxslide.js\"/>\n<js source=\"/js/jq/ifxtransfer.js\"/>\n<js source=\"/js/jq/ifxpulsate.js\"/>\n<js source=\"/js/jq/ifxdrop.js\"/>\n<js source=\"/js/jq/ifxscrollto.js\"/>\n<js source=\"/js/jq/ifxscale.js\"/>\n<css source=\"/themes/mouse/css/modules.css\"/>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("225", "0", "site:design:leftmenu", "3", "1", "1", "0", "1", "0", "2006-10-20", "Style[0]", "Левое или правое меню сайта, фактически карта", "<block_content>\n<h2>Меню</h2>\n<sidemenu/>\n</block_content>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("226", "31", "site:content:news:calendar", "7", "1", "1", "0", "1", "0", "2006-10-20", "", "Выводит календарь новостей, статей и тп.", "<name>Календарь</name>");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("229", "33", "object:admin:edit", "1", "1", "1", "0", "1", "0", "2006-10-24", "Style[0]", "Новый вариант админки", "");
INSERT INTO m_block (block_id, data_process_id, name, data_type_id, is_not_empty, is_published, is_hide_published, is_shared, is_parsed_manual, dt_update, attr, description, data) VALUES("230", "0", "object:admin:code", "0", "1", "1", "0", "1", "0", "2006-10-25", "Style[0]", "", "<js source=\"/themes/mouse/js/table.js\" />\r\n<js source=\"/themes/mouse/js/tabs.js\"/>\r\n<js source=\"/themes/mouse/js/admin.js\" />\r\n<css source=\"/themes/mouse/css/table-builder.css\"/>\r\n<css source=\"/themes/mouse/css/form-builder.css\"/>\r\n<js_head>\r\nsites = \'{$system/OBJECTS_HASH/80/full_path}?type=sites\';\r\nobjects=\'{$system/OBJECTS_HASH/80/full_path}?type=objects\';\r\nblocks=\'{$system/OBJECTS_HASH/80/full_path}?type=blocks\';\r\nprocess=\'{$system/OBJECTS_HASH/80/full_path}?type=process\';\r\n</js_head>\r\n<block_content>\r\n<div id=\"loadingAjax\"><li><img src=\"/images/loading.gif\"/> загрузка </li></div>\r\n</block_content>");


#
# Table structure for table 'm_block_template'
#

DROP TABLE IF EXISTS m_block_template;
CREATE TABLE m_block_template (
  m_block_template_id int(11) NOT NULL auto_increment,
  sort_order tinyint(4) NOT NULL default '0',
  data_type_id tinyint(4) NOT NULL default '0',
  data_process_id tinyint(4) NOT NULL default '0',
  is_published char(1) collate cp1251_bin NOT NULL default '',
  is_hide_published char(1) collate cp1251_bin NOT NULL default '',
  is_parsed_manual char(1) collate cp1251_bin NOT NULL default '',
  name varchar(255) collate cp1251_bin NOT NULL default '',
  description text collate cp1251_bin NOT NULL,
  body text collate cp1251_bin NOT NULL,
  PRIMARY KEY  (m_block_template_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_block_template'
#



#
# Table structure for table 'm_block_to_object'
#

DROP TABLE IF EXISTS m_block_to_object;
CREATE TABLE m_block_to_object (
  block_to_object_id int(11) NOT NULL auto_increment,
  block_id int(11) NOT NULL default '0',
  object_id int(11) NOT NULL default '0',
  sort_order int(4) NOT NULL default '0',
  mode int(4) NOT NULL default '0',
  PRIMARY KEY  (block_to_object_id),
  KEY ix_object_id (object_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_block_to_object'
#

INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("762", "12", "79", "0", "2");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("750", "224", "1", "5", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("723", "3", "3", "2", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("764", "229", "84", "2", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("763", "230", "84", "3", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("761", "230", "79", "9", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("760", "229", "80", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("751", "228", "1", "6", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("759", "227", "29", "4", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("749", "31", "1", "4", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("748", "4", "1", "3", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("719", "3", "2", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("765", "227", "84", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("722", "223", "3", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("721", "1", "4", "2", "2");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("720", "6", "4", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("747", "1", "1", "2", "2");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("758", "5", "29", "3", "2");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("746", "226", "1", "1", "2");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("697", "224", "28", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("699", "1", "27", "2", "2");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("698", "224", "27", "1", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("757", "2", "29", "2", "1");
INSERT INTO m_block_to_object (block_to_object_id, block_id, object_id, sort_order, mode) VALUES("756", "225", "29", "1", "2");


#
# Table structure for table 'm_data_process'
#

DROP TABLE IF EXISTS m_data_process;
CREATE TABLE m_data_process (
  data_process_id int(11) NOT NULL auto_increment,
  sort_order tinyint(4) NOT NULL default '0',
  data_process_type_id tinyint(4) NOT NULL default '0',
  dt_update date NOT NULL default '0000-00-00',
  name varchar(50) collate cp1251_bin NOT NULL default '',
  filename varchar(255) collate cp1251_bin NOT NULL default '',
  description varchar(255) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (data_process_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_data_process'
#

INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("1", "2", "0", "2006-10-10", "jq_admin", "/mc/loader.p", "Загрузка информации, отключение кэша");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("3", "1", "0", "0000-00-00", "auth_info", "auth_info.p", "Информация о залогиненном пользователе, вывод логина");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("4", "3", "0", "0000-00-00", "афоризмы", "phylosophy.p", "Выводит случайный афоризм");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("5", "4", "0", "2006-10-10", "editor", "editor.p", "Редактор данных");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("11", "9", "0", "2006-08-14", "Регистрация", "reg_control.p", "Регистрация пользователя");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("13", "9", "0", "2006-08-14", "погода", "weather.p", "погода");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("14", "9", "0", "2006-08-14", "Новости", "news.p", "Новости и служебные сообщения компании");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("18", "9", "0", "2006-08-15", "карточка сотрудника", "cart.p", "карточка сотрудника");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("20", "9", "0", "2006-08-16", "Пользователи", "users.p", "Управление пользователями");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("21", "9", "0", "2006-08-16", "Редактирование пользователя", "user_edit.p", "Редактирование пользователя");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("31", "5", "0", "2006-10-20", "Календарь статей", "calendar.p", "Выводит календарь статей заданного типа");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("26", "9", "0", "2006-09-30", "Кнопочки", "buttons", "Блок кнопок");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("28", "9", "0", "2006-10-01", "Редактор", "editor.p", "Обработка данных");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("32", "6", "0", "2006-10-20", "Вывод статей", "article.p", "Выводит определенные типы статей в зависимости от заданного пути");
INSERT INTO m_data_process (data_process_id, sort_order, data_process_type_id, dt_update, name, filename, description) VALUES("33", "11", "0", "2006-11-06", "Админка", "/mc/control.p", "Обработчик админки");


#
# Table structure for table 'm_data_process_type'
#

DROP TABLE IF EXISTS m_data_process_type;
CREATE TABLE m_data_process_type (
  data_process_type_id int(11) NOT NULL auto_increment,
  sort_order int(11) NOT NULL default '0',
  name varchar(255) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (data_process_type_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_data_process_type'
#

INSERT INTO m_data_process_type (data_process_type_id, sort_order, name) VALUES("0", "1", "Неопределенный тип");
INSERT INTO m_data_process_type (data_process_type_id, sort_order, name) VALUES("1", "2", "Админка - объекты");
INSERT INTO m_data_process_type (data_process_type_id, sort_order, name) VALUES("2", "3", "Админка - блоки");
INSERT INTO m_data_process_type (data_process_type_id, sort_order, name) VALUES("3", "4", "Админка - обработчики");


#
# Table structure for table 'm_data_type'
#

DROP TABLE IF EXISTS m_data_type;
CREATE TABLE m_data_type (
  data_type_id int(11) NOT NULL auto_increment,
  sort_order tinyint(4) NOT NULL default '0',
  name varchar(255) collate cp1251_bin NOT NULL default '',
  description text collate cp1251_bin NOT NULL,
  update_script varchar(255) collate cp1251_bin NOT NULL default '',
  edit_script varchar(255) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (data_type_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_data_type'
#

INSERT INTO m_data_type (data_type_id, sort_order, name, description, update_script, edit_script) VALUES("1", "0", "Неопределенный тип", "Данные неопределенного типа", "", "");
INSERT INTO m_data_type (data_type_id, sort_order, name, description, update_script, edit_script) VALUES("2", "1", "Данные XML", "XML данные", "", "");
INSERT INTO m_data_type (data_type_id, sort_order, name, description, update_script, edit_script) VALUES("3", "2", "Данные HTML", "Чистые HTML данные", "", "");
INSERT INTO m_data_type (data_type_id, sort_order, name, description, update_script, edit_script) VALUES("5", "4", "Parser Code", "Код на Parser", "", "");
INSERT INTO m_data_type (data_type_id, sort_order, name, description, update_script, edit_script) VALUES("7", "6", "Статьи", "Статьи", "", "");
INSERT INTO m_data_type (data_type_id, sort_order, name, description, update_script, edit_script) VALUES("6", "5", "System:macros", "Системные макросы Mouse", "", "");


#
# Table structure for table 'm_lang'
#

DROP TABLE IF EXISTS m_lang;
CREATE TABLE m_lang (
  lang_id tinyint(4) NOT NULL default '0',
  sort_order tinyint(4) NOT NULL default '0',
  abbr varchar(5) collate cp1251_bin NOT NULL default '',
  charset varchar(20) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (lang_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin COMMENT='RAY: таблица языков сайта';



#
# Dumping data for table 'm_lang'
#

INSERT INTO m_lang (lang_id, sort_order, abbr, charset) VALUES("1", "0", "ru", "win1251");


#
# Table structure for table 'm_object'
#

DROP TABLE IF EXISTS m_object;
CREATE TABLE m_object (
  object_id int(5) unsigned NOT NULL auto_increment,
  object_type_id tinyint(4) NOT NULL default '0',
  name varchar(50) collate cp1251_bin NOT NULL default '',
  Full_Path varchar(255) collate cp1251_bin NOT NULL default '/',
  site_id tinyint(3) unsigned NOT NULL default '0',
  parent_id smallint(5) unsigned NOT NULL default '0',
  thread_id smallint(5) unsigned NOT NULL default '0',
  data_process_id tinyint(4) NOT NULL default '0',
  template_id tinyint(4) NOT NULL default '0',
  rights int(11) NOT NULL default '3',
  cache_time int(11) NOT NULL default '0',
  is_show_on_sitemap char(1) collate cp1251_bin NOT NULL default '0',
  is_show_in_menu tinyint(4) NOT NULL default '0',
  Path varchar(255) collate cp1251_bin NOT NULL default '',
  url varchar(255) collate cp1251_bin NOT NULL default '',
  link_to_object_id int(11) NOT NULL default '0',
  link_to_object_type_id tinyint(4) NOT NULL default '0',
  auser_id int(11) NOT NULL default '0',
  is_published char(1) collate cp1251_bin NOT NULL default '0',
  dt_update date NOT NULL default '0000-00-00',
  document_name varchar(255) collate cp1251_bin NOT NULL default '',
  window_name varchar(255) collate cp1251_bin NOT NULL default '',
  description varchar(255) collate cp1251_bin NOT NULL default '',
  sort_order int(11) NOT NULL default '0',
  PRIMARY KEY  (object_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin COMMENT='Mouse : Хранилище объектов';



#
# Dumping data for table 'm_object'
#

INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("1", "0", "Главная", "/", "1", "0", "1", "0", "4", "3", "0", "1", "1", "", "", "0", "0", "4", "1", "2006-11-09", "Нора минотавра", "Нора минотавра", "Главная страница сайта", "2");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("2", "0", "Карта", "/map/", "1", "0", "0", "0", "4", "1", "300", "0", "1", "map", "", "0", "0", "4", "1", "2006-11-09", "Карта сайта", "Карта сайта", "Карта сайта", "5");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("3", "0", "Страница ошибок", "/error/", "1", "0", "3", "0", "4", "1", "300", "0", "0", "error", "", "0", "0", "4", "1", "2006-10-20", "Ошибка системы", "Ошибка системы", "Страница ошибок системы", "100");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("4", "0", "Регистрация", "/reg/", "1", "0", "4", "0", "4", "1", "300", "1", "1", "reg", "", "0", "0", "4", "1", "0000-00-00", "Регистрация нового пользователя", "Регистрация пользователя", "Страница регистрации пользователей", "4");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("29", "2", "Global", "/global/", "1", "0", "0", "0", "1", "1", "250", "0", "0", "global", "", "0", "0", "4", "1", "2006-10-22", "Global", "Global", "Глобальный объект содержащий элементы интерфейса, и глобальные блоки обработчики", "0");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("24", "0", "Mouse", "/mouse/", "1", "0", "0", "0", "4", "1", "250", "1", "1", "mouse", "", "0", "0", "4", "1", "2006-11-09", "Система управления контентом", "Система управления контентом Mouse CMS", "Раздел посвященный системе управления контентом \"Mouse CMS\"", "3");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("25", "5", "Форум", "/mouse/forum/", "1", "24", "0", "0", "4", "1", "250", "1", "1", "forum", "", "0", "0", "4", "1", "2006-11-15", "Mouse форум", "Mouse CMS | Форум", "Форум", "5");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("26", "0", "Скачать", "/mouse/download/", "1", "24", "24", "0", "4", "1", "250", "1", "0", "download", "", "0", "0", "4", "1", "2006-11-05", "Загрузка Mouse CMS", "Загрузка Mouse CMS", "Загрузка дистрибутива Mouse CMS", "7");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("27", "0", "KLeN", "/mblog/", "1", "0", "0", "0", "4", "1", "250", "1", "1", "mblog", "", "0", "0", "4", "1", "2006-11-09", "Минотавров блог", "Минотавров блог", "Всякая дребедень которую минотавры рассказывают по ночам", "4");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("28", "0", "Документация", "/mouse/doc/", "1", "24", "24", "0", "4", "1", "250", "1", "1", "doc", "", "0", "0", "4", "1", "2006-11-05", "Документация Mouse CMS", "MOUSE | Документация", "Описание Mouse CMS", "0");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("80", "1", "AdminControl", "/mc/admin/", "1", "79", "0", "0", "5", "1", "250", "0", "0", "admin", "", "0", "0", "4", "1", "2006-11-15", "Админка", "Админка", "Основной интерфейс админки", "1");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("79", "0", "Admin", "/mc/", "1", "0", "0", "0", "4", "3", "250", "1", "1", "mc", "", "0", "0", "4", "1", "2006-11-09", "Администрирование Mouse CMS", "Администрирование Mouse CMS", "Тестовый объект с независимым обработчиком: test.p", "0");
INSERT INTO m_object (object_id, object_type_id, name, Full_Path, site_id, parent_id, thread_id, data_process_id, template_id, rights, cache_time, is_show_on_sitemap, is_show_in_menu, Path, url, link_to_object_id, link_to_object_type_id, auser_id, is_published, dt_update, document_name, window_name, description, sort_order) VALUES("84", "3", "AdminPicker", "/mc/picker/", "1", "79", "0", "0", "14", "7", "250", "0", "0", "picker", "", "0", "0", "0", "1", "2006-11-15", "Выбор элементов", "Выбор элементов", "Выбор элементов для полей форм и тп", "1");


#
# Table structure for table 'm_object_type'
#

DROP TABLE IF EXISTS m_object_type;
CREATE TABLE m_object_type (
  object_type_id tinyint(4) NOT NULL auto_increment,
  sort_order tinyint(4) NOT NULL default '0',
  is_show_on_sitemap char(1) collate cp1251_bin NOT NULL default '1',
  is_fake char(1) collate cp1251_bin NOT NULL default '0',
  abbr varchar(10) collate cp1251_bin NOT NULL default '',
  name varchar(40) collate cp1251_bin NOT NULL default '',
  constructor varchar(40) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (object_type_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_object_type'
#

INSERT INTO m_object_type (object_type_id, sort_order, is_show_on_sitemap, is_fake, abbr, name, constructor) VALUES("1", "0", "1", "0", "null", "Неопределенный тип", "null");
INSERT INTO m_object_type (object_type_id, sort_order, is_show_on_sitemap, is_fake, abbr, name, constructor) VALUES("2", "0", "1", "0", "global", "Глобальный объект", "global");
INSERT INTO m_object_type (object_type_id, sort_order, is_show_on_sitemap, is_fake, abbr, name, constructor) VALUES("3", "1", "1", "0", "uni", "Уникальный объект", "uni");
INSERT INTO m_object_type (object_type_id, sort_order, is_show_on_sitemap, is_fake, abbr, name, constructor) VALUES("4", "2", "1", "0", "container", "container", "container");
INSERT INTO m_object_type (object_type_id, sort_order, is_show_on_sitemap, is_fake, abbr, name, constructor) VALUES("5", "3", "1", "0", "admin", "Объекты Администрирования", "system");
INSERT INTO m_object_type (object_type_id, sort_order, is_show_on_sitemap, is_fake, abbr, name, constructor) VALUES("6", "4", "1", "0", "live", "Объекты общего типа", "live");


#
# Table structure for table 'm_site'
#

DROP TABLE IF EXISTS m_site;
CREATE TABLE m_site (
  site_id int(11) NOT NULL auto_increment,
  lang_id tinyint(4) NOT NULL default '0',
  sort_order tinyint(4) NOT NULL default '0',
  cache_time int(4) NOT NULL default '0',
  e404_object_id int(11) NOT NULL default '0',
  name varchar(255) collate cp1251_bin NOT NULL default '',
  domain varchar(255) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (site_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin COMMENT='RAY: Таблица сайтов';



#
# Dumping data for table 'm_site'
#

INSERT INTO m_site (site_id, lang_id, sort_order, cache_time, e404_object_id, name, domain) VALUES("1", "1", "3", "250", "3", "Mouse", "www.mouse.ru");


#
# Table structure for table 'm_template'
#

DROP TABLE IF EXISTS m_template;
CREATE TABLE m_template (
  template_id int(11) NOT NULL auto_increment,
  sort_order tinyint(4) NOT NULL default '0',
  template_type_id tinyint(4) NOT NULL default '0',
  dt_update date NOT NULL default '0000-00-00',
  name varchar(50) collate cp1251_bin NOT NULL default '',
  filename varchar(100) collate cp1251_bin NOT NULL default '',
  params varchar(100) collate cp1251_bin NOT NULL default '',
  description varchar(255) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (template_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_template'
#

INSERT INTO m_template (template_id, sort_order, template_type_id, dt_update, name, filename, params, description) VALUES("14", "3", "0", "2006-11-15", "Mouse easy", "Mouse/main_easy.xsl", "/themes/mouse/css/mouse.css", "Простой без шапки в одну колонку");
INSERT INTO m_template (template_id, sort_order, template_type_id, dt_update, name, filename, params, description) VALUES("4", "4", "1", "0000-00-00", "Mouse", "Mouse/main.xsl", "/themes/mouse/css/mouse.css", "Тема Mouse");
INSERT INTO m_template (template_id, sort_order, template_type_id, dt_update, name, filename, params, description) VALUES("5", "5", "1", "2006-11-15", "Mouse ajax", "Mouse/easy.xsl", "/themes/mouse/css/mouse.css", "Тема Mouse Упрощенная");


#
# Table structure for table 'm_template_group'
#

DROP TABLE IF EXISTS m_template_group;
CREATE TABLE m_template_group (
  template_group_id int(11) NOT NULL auto_increment,
  sort_order tinyint(4) NOT NULL default '0',
  directory_name varchar(255) collate cp1251_bin NOT NULL default '',
  name varchar(50) collate cp1251_bin NOT NULL default '',
  description varchar(255) collate cp1251_bin NOT NULL default '',
  PRIMARY KEY  (template_group_id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 COLLATE=cp1251_bin;



#
# Dumping data for table 'm_template_group'
#

