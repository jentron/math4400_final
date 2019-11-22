drop table calls;

create table calls (
	X1 NUMBER(38) PRIMARY KEY,
	contactId VARCHAR2(12),
	contactStart DATE,
	campaignId VARCHAR2(12),
	abandoned NUMBER(38),
	abandonseconds NUMBER(38),
	inQueueSeconds NUMBER(38),
	agentSeconds NUMBER(38),
	Synthetic CHAR(5)
);

alter table calls add  (timerounded date);

drop table avol;
create table avol (
    contactStart DATE PRIMARY KEY,
    callVolume NUMBER(38),
    calls NUMBER(38)
    );
    