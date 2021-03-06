-- phpMyAdmin SQL Dump
-- version 2.11.5
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2008 年 07 月 06 日 18:00
-- 服务器版本: 5.0.51
-- PHP 版本: 5.2.5

--
-- 数据库: `typecho`
--

-- --------------------------------------------------------

--
-- 表的结构 `typecho_comments`
--

CREATE TABLE `typecho_comments` (
  `coid` int(10) unsigned NOT NULL auto_increment,
  `cid` int(10) unsigned default '0',
  `created` int(10) unsigned default '0',
  `author` varchar(200) default NULL,
  `authorId` int(10) unsigned default '0',
  `ownerId` int(10) unsigned default '0',
  `mail` varchar(200) default NULL,
  `url` varchar(200) default NULL,
  `ip` varchar(64) default NULL,
  `agent` varchar(200) default NULL,
  `text` text,
  `type` varchar(16) default 'comment',
  `status` varchar(16) default 'approved',
  `parent` int(10) unsigned default '0',
  PRIMARY KEY  (`coid`),
  KEY `cid` (`cid`),
  KEY `created` (`created`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_contents`
--

CREATE TABLE `typecho_contents_source` (
  `cid` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(200) default NULL, /**冗余多一个标题，方便在后台文章列表的时候取出来*/
  `slug` varchar(200) default NULL,
  `created` int(10) unsigned default '0',
  `modified` int(10) unsigned default '0',
  `order` int(10) unsigned default '0',
  `authorId` int(10) unsigned default '0',
  `template` varchar(32) default NULL,
  `type` varchar(16) default 'post',
  `status` varchar(16) default 'publish',
  `password` varchar(32) default NULL,
  `commentsNum` int(10) unsigned default '0',
  `allowComment` char(1) default '0',
  `allowPing` char(1) default '0',
  `allowFeed` char(1) default '0',
  `parent` int(10) unsigned default '0',
  `ext_categories` varchar(128) default NULL,
  PRIMARY KEY  (`cid`),
  UNIQUE KEY `slug` (`slug`),
  KEY `created` (`created`),
  FULLTEXT KEY `ext_categories` (`ext_categories`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_contents_extend`，用于分区记录文章内容，减少IO
--

CREATE TABLE `typecho_contents_extend` (
  `cid` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(200) default NULL,
  `text` text,
  PRIMARY KEY  (`cid`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%
PARTITION BY HASH(cid)
PARTITIONS 128;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_contents_index`，用于对文章内容进行索引
--
CREATE TABLE `typecho_contents_index` (
  `cid` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(200) default NULL,
  `text` text,
  PRIMARY KEY  (`cid`),
  FULLTEXT KEY `index_title` (`title`),
  FULLTEXT KEY `index_text` (`text`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%;

-- --------------------------------------------------------

--
-- 兼容官方版本所使用的视图结构 `typecho_contents`
--
create view `typecho_contents` as 
select 
 typecho_contents_source.`cid`,
 typecho_contents_source.`title`,
 typecho_contents_source.`slug`,
 typecho_contents_extend.`text`,
 typecho_contents_source.`created`,
 typecho_contents_source.`modified`,
 typecho_contents_source.`order`,
 typecho_contents_source.`authorId`,
 typecho_contents_source.`template`,
 typecho_contents_source.`type`,
 typecho_contents_source.`status`,
 typecho_contents_source.`password`,
 typecho_contents_source.`commentsNum`,
 typecho_contents_source.`allowComment`,
 typecho_contents_source.`allowPing`,
 typecho_contents_source.`allowFeed`,
 typecho_contents_source.`parent`,
 typecho_contents_source.`ext_categories`
from `typecho_contents_source` 
 inner join `typecho_contents_extend` using(cid);

-- --------------------------------------------------------

--
-- 表的结构 `typecho_fields`
--

CREATE TABLE `typecho_fields` (
  `cid` int(10) unsigned NOT NULL,
  `name` varchar(200) NOT NULL,
  `type` varchar(8) default 'str',
  `str_value` text,
  `int_value` int(10) default '0',
  `float_value` float default '0',
  PRIMARY KEY  (`cid`,`name`),
  KEY `int_value` (`int_value`),
  KEY `float_value` (`float_value`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_metas`
--

CREATE TABLE `typecho_metas` (
  `mid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(200) default NULL,
  `slug` varchar(200) default NULL,
  `type` varchar(32) NOT NULL,
  `description` varchar(200) default NULL,
  `count` int(10) unsigned default '0',
  `order` int(10) unsigned default '0',
  `parent` int(10) unsigned default '0',
  PRIMARY KEY  (`mid`),
  KEY `slug` (`slug`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_options`
--

CREATE TABLE `typecho_options` (
  `name` varchar(32) NOT NULL,
  `user` int(10) unsigned NOT NULL default '0',
  `value` text,
  PRIMARY KEY  (`name`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=%charset%;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_relationships`
--

CREATE TABLE `typecho_relationships` (
  `cid` int(10) unsigned NOT NULL,
  `mid` int(10) unsigned NOT NULL,
  KEY `cid` (`cid`) USING HASH,
  KEY `mid` (`mid`) USING HASH,
  PRIMARY KEY  (`cid`,`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=%charset%
PARTITION BY HASH(mid)
PARTITIONS 32;

-- --------------------------------------------------------

--
-- 表的结构 `typecho_users`
--

CREATE TABLE `typecho_users` (
  `uid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(32) default NULL,
  `password` varchar(64) default NULL,
  `mail` varchar(200) default NULL,
  `url` varchar(200) default NULL,
  `screenName` varchar(32) default NULL,
  `created` int(10) unsigned default '0',
  `activated` int(10) unsigned default '0',
  `logged` int(10) unsigned default '0',
  `group` varchar(16) default 'visitor',
  `authCode` varchar(64) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `mail` (`mail`)
) ENGINE=MyISAM  DEFAULT CHARSET=%charset%;
