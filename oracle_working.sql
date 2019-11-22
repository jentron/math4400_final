
-- truncated to 30 minute intervals
select trunc((contactStart - trunc(contactStart))*2*24)/(2*24)+trunc(contactStart) as timerounded from calls order by x1;

update calls set timerounded = trunc((contactStart - trunc(contactStart))*2*24)/(2*24)+trunc(contactStart);



-- "","timerounded","AVG(inQueueSeconds)","summary2$`AVG(abandonseconds)`","summary3$`AVG(abandoned)`","summary4$`COUNT(campaignId)`","CallVolume","HandleTime"
select timerounded, round((timerounded-TRUNC(timerounded))*24, 1) as hour, avg(inqueueseconds), avg(abandonseconds), avg(abandoned), count(campaignID), count(x1) CallVolume, AVG(NULLIF(agentseconds,0)) as AHT
from calls
where (synthetic = 'FALSE' or synthetic = 'TRUE' )
group by timerounded
order by timerounded;

select round(1.23456789, 4) from dual;

 SELECT *
 FROM calls 
 where timerounded < to_date('01-MAY-2018 08:00:00', 'DD-MM-RRRR HH24:MI:SS')
 order by timerounded;
 
 Select To_date ('15/2/2007 00:00:00', 'DD/MM/YYYY HH24:MI:SS'),
       To_date ('28/2/2007 10:12', 'DD/MM/YYYY HH24:MI:SS'),
       To_Char (to_date('28/2/2007 10:12', 'DD/MM/YYYY HH24:MI:SS'), 'DDD')
       
  From DUAL;

select count(*) from calls where synthetic = 'FALSE';

select to_char(contactstart, 'DDD') as callDate, campaignID, count(*) as count
from calls
group by to_char(contactstart, 'DDD'), campaignID
order by to_char(contactstart, 'DDD'), campaignID;

select count(distinct campaignid) from calls;
select distinct campaignid from calls;

select trunc(contactstart), count(*) as callvolume
from calls
group by trunc(contactstart)
order by trunc(contactstart) ;

select contactstart, contactid, agentseconds, round(agentseconds/3600, 2) agenthours from calls 
where agentseconds > 2*60*60 
    and synthetic='FALSE'
order by contactid asc, agentseconds desc;

select count(*) from calls where agentseconds > 2*60*60;

select count(*) from calls where synthetic = 'FALSE';

select contactstart, train.callvolume
from avol 
left join (
    select timerounded, count(x1) CallVolume, AVG(NULLIF(agentseconds,0)) as AHT
    from calls
  --  where (synthetic = 'FALSE' or synthetic = 'TRUE' )
    group by timerounded
) train
on avol.contactstart = train.timerounded
order by contactstart;