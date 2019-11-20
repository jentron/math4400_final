-- something about the company
-- insight about the data
-- explain your model
-- ask a question about the company

create tablespace math4400_tabspace datafile 'math4400_tabspace.dat'
 size 10M autoextend on;
create temporary tablespace math4400_tabspace_temp tempfile 'math4400_tabspace_temp.dat' size 5M autoextend on;
create user math4400 identified by julian default tablespace math4400_tabspace  temporary tablespace math4400_tabspace_temp;

grant create session to math4400;
grant create table to math4400;
grant unlimited tablespace to math4400;

	X1,
	contactId,
	contactStart,
	campaignId,
	abandoned,
	abandonseconds,
	inQueueSeconds,
	agentSeconds,
	Synthetic

