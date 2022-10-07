-- You only need this if you have a new mySQL install
-- nwn server user 
-- assumes mysql is running on same computer as nwn server
CREATE USER 'nwn'@'localhost';
-- set the password
-- see for why it is done like this http://dev.mysql.com/doc/refman/5.1/en/old-client.html )
SET PASSWORD FOR 'nwn'@'localhost' = OLD_PASSWORD('password'); -- change this to a better password!!!
-- make the database
CREATE DATABASE nwn;
-- let the nwn server read and modify it
GRANT ALL ON nwn.* TO 'nwn'@'localhost';