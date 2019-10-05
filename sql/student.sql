/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 8.0.16 : Database - student
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`student` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `student`;

/*Table structure for table `major` */

DROP TABLE IF EXISTS `major`;

CREATE TABLE `major` (
  `majorid` int(11) NOT NULL AUTO_INCREMENT,
  `majorname` varchar(20) NOT NULL,
  PRIMARY KEY (`majorid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `major` */

insert  into `major`(`majorid`,`majorname`) values 
(1,'javaee'),
(2,'html5'),
(3,'android');

/*Table structure for table `result` */

DROP TABLE IF EXISTS `result`;

CREATE TABLE `result` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `studentno` varchar(10) NOT NULL,
  `score` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Data for the table `result` */

insert  into `result`(`id`,`studentno`,`score`) values 
(1,'s001',100),
(2,'s002',90),
(3,'s003',80),
(4,'s004',70),
(5,'s005',60),
(6,'s006',50),
(7,'s006',40),
(8,'s005',95),
(9,'s006',88);

/*Table structure for table `student` */

DROP TABLE IF EXISTS `student`;

CREATE TABLE `student` (
  `studentno` varchar(10) NOT NULL,
  `studentname` varchar(20) NOT NULL,
  `loginpwd` varchar(8) NOT NULL,
  `sex` char(1) DEFAULT NULL,
  `majorid` int(11) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `borndate` datetime DEFAULT NULL,
  PRIMARY KEY (`studentno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `student` */

insert  into `student`(`studentno`,`studentname`,`loginpwd`,`sex`,`majorid`,`phone`,`email`,`borndate`) values 
('S001','张三封','8888','男',1,'13288886666','zhangsanfeng@126.com','1966-09-01 00:00:00'),
('S002','殷天正','8888','男',1,'13888881234','yintianzheng@qq.com','1976-09-02 00:00:00'),
('S003','周伯通','8888','男',2,'13288886666','zhoubotong@126.com','1986-09-03 00:00:00'),
('S004','张翠山','8888','男',1,'13288886666',NULL,'1995-09-04 00:00:00'),
('S005','小小张','8888','女',3,'13288885678','xiaozhang@126.com','1990-09-05 00:00:00'),
('S006','张无忌','8888','男',2,'13288886666','zhangwuji@126.com','1998-08-09 00:00:00'),
('S007','赵敏','0000','女',1,'13288880987','zhaomin@126.com','1998-06-09 00:00:00'),
('S008','周芷若','6666','女',1,'13288883456','zhouzhiruo@126.com','1996-07-09 00:00:00'),
('S009','殷素素','8888','女',1,'13288886666','yinsusu@163.com','1986-01-09 00:00:00'),
('S010','宋远桥','6666','男',3,'1328888890','songyuanqiao@qq.com','1996-02-09 00:00:00'),
('S011','杨不悔','6666','女',2,'13288882345',NULL,'1995-09-09 00:00:00'),
('S012','杨逍','9999','男',1,'13288885432',NULL,'1976-09-09 00:00:00'),
('S013','纪晓芙','9999','女',3,'13288888765',NULL,'1976-09-09 00:00:00'),
('S014','谢逊','9999','男',1,'13288882211',NULL,'1946-09-09 00:00:00'),
('S015','宋青书','9999','男',3,'13288889900',NULL,'1976-06-08 00:00:00');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
