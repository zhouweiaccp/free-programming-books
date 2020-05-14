


## CREATE USER
CREATE USER 'jeffrey'@'localhost' IDENTIFIED BY 'password';

CREATE USER 'jeffrey'@'localhost'
  IDENTIFIED WITH sha256_password BY 'new_password'
  PASSWORD EXPIRE INTERVAL 180 DAY;


  

https://dev.mysql.com/doc/refman/5.7/en/create-user.html

## 显示帐号权限
 SHOW GRANTS;


 help Account Management
help grant

https://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html#privileges-provided-guidelines

Summary of Available Privileges
The following table shows the privilege names used in GRANT and REVOKE statements, along with the column name associated with each privilege in the grant tables and the context in which the privilege applies.

Table 6.2 Permissible Privileges for GRANT and REVOKE

Privilege	Grant Table Column	Context
ALL [PRIVILEGES]	Synonym for “all privileges”	Server administration
ALTER	Alter_priv	Tables
ALTER ROUTINE	Alter_routine_priv	Stored routines
CREATE	Create_priv	Databases, tables, or indexes
CREATE ROUTINE	Create_routine_priv	Stored routines
CREATE TABLESPACE	Create_tablespace_priv	Server administration
CREATE TEMPORARY TABLES	Create_tmp_table_priv	Tables
CREATE USER	Create_user_priv	Server administration
CREATE VIEW	Create_view_priv	Views
DELETE	Delete_priv	Tables
DROP	Drop_priv	Databases, tables, or views
EVENT	Event_priv	Databases
EXECUTE	Execute_priv	Stored routines
FILE	File_priv	File access on server host
GRANT OPTION	Grant_priv	Databases, tables, or stored routines
INDEX	Index_priv	Tables
INSERT	Insert_priv	Tables or columns
LOCK TABLES	Lock_tables_priv	Databases
PROCESS	Process_priv	Server administration
PROXY	See proxies_priv table	Server administration
REFERENCES	References_priv	Databases or tables
RELOAD	Reload_priv	Server administration
REPLICATION CLIENT	Repl_client_priv	Server administration
REPLICATION SLAVE	Repl_slave_priv	Server administration
SELECT	Select_priv	Tables or columns
SHOW DATABASES	Show_db_priv	Server administration
SHOW VIEW	Show_view_priv	Views
SHUTDOWN	Shutdown_priv	Server administration
SUPER	Super_priv	Server administration
TRIGGER	Trigger_priv	Tables
UPDATE	Update_priv	Tables or columns
USAGE	Synonym for “no privileges”	Server administration

Privilege Descriptions
The following list provides general descriptions of each privilege available in MySQL. Particular SQL statements might have more specific privilege requirements than indicated here. If so, the description for the statement in question provides the details.

ALL, ALL PRIVILEGES

These privilege specifiers are shorthand for “all privileges available at a given privilege level” (except GRANT OPTION). For example, granting ALL at the global or table level grants all global privileges or all table-level privileges, respectively.

ALTER

Enables use of the ALTER TABLE statement to change the structure of tables. ALTER TABLE also requires the CREATE and INSERT privileges. Renaming a table requires ALTER and DROP on the old table, CREATE, and INSERT on the new table.

ALTER ROUTINE

Enables use of statements that alter or drop stored routines (stored procedures and functions).

CREATE

Enables use of statements that create new databases and tables.

CREATE ROUTINE

Enables use of statements that create stored routines (stored procedures and functions).

CREATE TABLESPACE

Enables use of statements that create, alter, or drop tablespaces and log file groups.

CREATE TEMPORARY TABLES

Enables the creation of temporary tables using the CREATE TEMPORARY TABLE statement.

After a session has created a temporary table, the server performs no further privilege checks on the table. The creating session can perform any operation on the table, such as DROP TABLE, INSERT, UPDATE, or SELECT. For more information, see Section 13.1.18.2, “CREATE TEMPORARY TABLE Statement”.

CREATE USER

Enables use of the ALTER USER, CREATE USER, DROP USER, RENAME USER, and REVOKE ALL PRIVILEGES statements.

CREATE VIEW

Enables use of the CREATE VIEW statement.

DELETE

Enables rows to be deleted from tables in a database.

DROP

Enables use of statements that drop (remove) existing databases, tables, and views. The DROP privilege is required to use the ALTER TABLE ... DROP PARTITION statement on a partitioned table. The DROP privilege is also required for TRUNCATE TABLE.

EVENT

Enables use of statements that create, alter, drop, or display events for the Event Scheduler.

EXECUTE

Enables use of statements that execute stored routines (stored procedures and functions).

FILE

Affects the following operations and server behaviors:

Enables reading and writing files on the server host using the LOAD DATA and SELECT ... INTO OUTFILE statements and the LOAD_FILE() function. A user who has the FILE privilege can read any file on the server host that is either world-readable or readable by the MySQL server. (This implies the user can read any file in any database directory, because the server can access any of those files.)

Enables creating new files in any directory where the MySQL server has write access. This includes the server's data directory containing the files that implement the privilege tables.

As of MySQL 5.7.17, enables use of the DATA DIRECTORY or INDEX DIRECTORY table option for the CREATE TABLE statement.

As a security measure, the server does not overwrite existing files.

To limit the location in which files can be read and written, set the secure_file_priv system variable to a specific directory. See Section 5.1.7, “Server System Variables”.

GRANT OPTION

Enables you to grant to or revoke from other users those privileges that you yourself possess.

INDEX

Enables use of statements that create or drop (remove) indexes. INDEX applies to existing tables. If you have the CREATE privilege for a table, you can include index definitions in the CREATE TABLE statement.

INSERT

Enables rows to be inserted into tables in a database. INSERT is also required for the ANALYZE TABLE, OPTIMIZE TABLE, and REPAIR TABLE table-maintenance statements.

LOCK TABLES

Enables use of explicit LOCK TABLES statements to lock tables for which you have the SELECT privilege. This includes use of write locks, which prevents other sessions from reading the locked table.

PROCESS

Enables display of information about the threads executing within the server (that is, information about the statements being executed by sessions). The privilege enables use of SHOW PROCESSLIST or mysqladmin processlist to see threads belonging to other accounts; you can always see your own threads. The PROCESS privilege also enables use of SHOW ENGINE.

PROXY

Enables one user to impersonate or become known as another user. See Section 6.2.14, “Proxy Users”.

REFERENCES

Creation of a foreign key constraint requires the REFERENCES privilege for the parent table.

RELOAD

Enables use of the FLUSH statement. It also enables mysqladmin commands that are equivalent to FLUSH operations: flush-hosts, flush-logs, flush-privileges, flush-status, flush-tables, flush-threads, refresh, and reload.

The reload command tells the server to reload the grant tables into memory. flush-privileges is a synonym for reload. The refresh command closes and reopens the log files and flushes all tables. The other flush-xxx commands perform functions similar to refresh, but are more specific and may be preferable in some instances. For example, if you want to flush just the log files, flush-logs is a better choice than refresh.

The RELOAD privilege also enables use of the RESET MASTER and RESET SLAVE statements.

REPLICATION CLIENT

Enables use of the SHOW MASTER STATUS, SHOW SLAVE STATUS, and SHOW BINARY LOGS statements. Grant this privilege to accounts that are used by slave servers to connect to the current server as their master.

REPLICATION SLAVE

Enables the account to request updates that have been made to databases on the master server, using the SHOW SLAVE HOSTS, SHOW RELAYLOG EVENTS, and SHOW BINLOG EVENTS statements. This privilege is also required to use the mysqlbinlog options --read-from-remote-server (-R) and --read-from-remote-master. Grant this privilege to accounts that are used by slave servers to connect to the current server as their master.

SELECT

Enables rows to be selected from tables in a database. SELECT statements require the SELECT privilege only if they actually access tables. Some SELECT statements do not access tables and can be executed without permission for any database. For example, you can use SELECT as a simple calculator to evaluate expressions that make no reference to tables:

SELECT 1+1;
SELECT PI()*2;
The SELECT privilege is also needed for other statements that read column values. For example, SELECT is needed for columns referenced on the right hand side of col_name=expr assignment in UPDATE statements or for columns named in the WHERE clause of DELETE or UPDATE statements.

The SELECT privilege is needed for tables or views used with EXPLAIN, including any underlying tables in view definitions.

SHOW DATABASES

Enables the account to see database names by issuing the SHOW DATABASE statement. Accounts that do not have this privilege see only databases for which they have some privileges, and cannot use the statement at all if the server was started with the --skip-show-database option.

Caution
Because a global privilege is considered a privilege for all databases, any global privilege enables a user to see all database names with SHOW DATABASES or by examining the INFORMATION_SCHEMA SCHEMATA table.

SHOW VIEW

Enables use of the SHOW CREATE VIEW statement. This privilege is also needed for views used with EXPLAIN.

SHUTDOWN

Enables use of the SHUTDOWN statement, the mysqladmin shutdown command, and the mysql_shutdown() C API function.

SUPER

Affects the following operations and server behaviors:

Enables server configuration changes by modifying global system variables. For some system variables, setting the session value also requires the SUPER privilege. If a system variable is restricted and requires a special privilege to set the session value, the variable description indicates that restriction. Examples include binlog_format, sql_log_bin, and sql_log_off. See also Section 5.1.8.1, “System Variable Privileges”.

Enables changes to global transaction characteristics (see Section 13.3.6, “SET TRANSACTION Statement”).

Enables the account to start and stop replication, including Group Replication.

Enables use of the CHANGE MASTER TO and CHANGE REPLICATION FILTER statements.

Enables binary log control by means of the PURGE BINARY LOGS and BINLOG statements.

Enables setting the effective authorization ID when executing a view or stored program. A user with this privilege can specify any account in the DEFINER attribute of a view or stored program.

Enables use of the CREATE SERVER, ALTER SERVER, and DROP SERVER statements.

Enables use of the mysqladmin debug command.

Enables InnoDB encryption key rotation.

Enables reading the DES key file by the DES_ENCRYPT() function.

Enables execution of Version Tokens user-defined functions.

Enables control over client connections not permitted to non-SUPER accounts:

Enables use of the KILL statement or mysqladmin kill command to kill threads belonging to other accounts. (An account can always kill its own threads.)

The server does not execute init_connect system variable content when SUPER clients connect.

The server accepts one connection from a SUPER client even if the connection limit configured by the max_connections system variable is reached.

A server in offline mode (offline_mode enabled) does not terminate SUPER client connections at the next client request, and accepts new connections from SUPER clients.

Updates can be performed even when the read_only system variable is enabled. This applies to explicit table updates, and to use of account-management statements such as GRANT and REVOKE that update tables implicitly.

You may also need the SUPER privilege to create or alter stored functions if binary logging is enabled, as described in Section 23.7, “Stored Program Binary Logging”.

TRIGGER

Enables trigger operations. You must have this privilege for a table to create, drop, execute, or display triggers for that table.

When a trigger is activated (by a user who has privileges to execute INSERT, UPDATE, or DELETE statements for the table associated with the trigger), trigger execution requires that the user who defined the trigger still have the TRIGGER privilege for the table.

UPDATE

Enables rows to be updated in tables in a database.

USAGE

This privilege specifier stands for “no privileges.” It is used at the global level with GRANT to modify account attributes such as resource limits or SSL characteristics without naming specific account privileges in the privilege list. SHOW GRANTS displays USAGE to indicate that an account has no privileges at a privilege level.

Privilege-Granting Guidelines
It is a good idea to grant to an account only those privileges that it needs. You should exercise particular caution in granting the FILE and administrative privileges:

FILE can be abused to read into a database table any files that the MySQL server can read on the server host. This includes all world-readable files and files in the server's data directory. The table can then be accessed using SELECT to transfer its contents to the client host.

GRANT OPTION enables users to give their privileges to other users. Two users that have different privileges and with the GRANT OPTION privilege are able to combine privileges.

ALTER may be used to subvert the privilege system by renaming tables.

SHUTDOWN can be abused to deny service to other users entirely by terminating the server.

PROCESS can be used to view the plain text of currently executing statements, including statements that set or change passwords.

SUPER can be used to terminate other sessions or change how the server operates.

Privileges granted for the mysql system database itself can be used to change passwords and other access privilege information:

Passwords are stored encrypted, so a malicious user cannot simply read them to know the plain text password. However, a user with write access to the mysql.user system table authentication_string column can change an account's password, and then connect to the MySQL server using that account.

INSERT or UPDATE granted for the mysql system database enable a user to add privileges or modify existing privileges, respectively.

DROP for the mysql system database enables a user to remote privilege tables, or even the database itself.