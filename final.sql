select "Node id",
"Node name",
"Agent Version",
"Agent type",
"Agent Stuatus",
"Application id",
"Account Id",
"Tier name",
"Average original request length"
union all
select
n.id node_id,
n.name "Node name",
agent_version "Agent Version",
a.type "Agent type",
if(historical, "Active", "Inactive") "Agent Stuatus",
ac.application_id "Application id",
ap.account_id "Account Id",
ac.name "Tier name",
round(avg(rs.original_length)) "Average original request length"
from application_component_node n
left join application_component_node_agent_mapping m on n.id=m.application_component_node_id
left join agent a on a.id=m.agent_id
left join application_component ac on ac.id=n.application_component_id
left join application ap on ap.id=ac.application_id
left join requestdata_summary rs on n.id=rs.node_id INTO OUTFILE '/home/jun.ouyang/test1/general.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"JVM CPU used % min",
"JVM CPU used % max",
"JVM CPU used % avg"
union all
select
cpu.process_cpu_percent_min "JVM CPU used % min",
cpu.process_cpu_percent_max "JVM CPU used % max",
cpu.process_cpu_percent_avg "JVM CPU used % avg"
from
application_component_node n left join
(select node_id, min(min_val) process_cpu_percent_min, max(max_val) process_cpu_percent_max, round(avg(sum_val / count_val),2) process_cpu_percent_avg from metricdata_ten_min md where metric_id in (select id from metric where name like 'JVM|Process CPU Usage %') and ts_min > floor((unix_timestamp() / 60) - 4*60) group by node_id order by node_id) cpu on n.id=cpu.node_id INTO OUTFILE '/home/jun.ouyang/test1/cpu.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"JVM Heap Used % min",
"JVM Heap Used % max",
"JVM Heap Used % avg"
union all
select
n.id node_id,
heap_u.heap_per_min "JVM Heap Used % min",
heap_u.heap_per_max "JVM Heap Used % max",
heap_u.heap_per_avg "JVM Heap Used % avg"
from
application_component_node n left join
(select node_id, min(min_val) heap_per_min, max(max_val) heap_per_max, round(avg(sum_val / count_val),2) heap_per_avg from metricdata_ten_min md where metric_id in (select id from metric where name like 'JVM|Memory:Heap|Used %') and ts_min > floor((unix_timestamp() / 60) - 4*60) group by node_id order by node_id) heap_u on n.id=heap_u.node_id INTO OUTFILE '/home/jun.ouyang/test1/heap_u.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"JVM Heap Used in GB min",
"JVM Heap Used in GB max",
"JVM Heap Used in GB avg"
union all
select
n.id node_id,
heap_g.max_heap_available_gb_min "JVM Heap Used in GB min",
heap_g.max_heap_available_gb_max "JVM Heap Used in GB max",
heap_g.max_heap_available_gb_avg "JVM Heap Used in GB avg"
from
application_component_node n left join
(select node_id, round(min(min_val)/1024, 2) max_heap_available_gb_min, round(max(max_val)/1024, 2) max_heap_available_gb_max, round(avg(sum_val / count_val)/1024, 2) max_heap_available_gb_avg from metricdata_ten_min md where metric_id in (select id from metric where name = 'JVM|Memory:Heap|Max Available (MB)') and ts_min > floor((unix_timestamp() / 60) - 4*60) group by node_id order by node_id) heap_g on n.id=heap_g.node_id INTO OUTFILE '/home/jun.ouyang/test1/heap_g.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Host memory in GB"
union all
select
n.id node_id,
memory.host_memory_gb "Host memory in GB"
from
application_component_node n left join
(select node_id, round(min(min_val)/1024, 2) host_memory_gb from metricdata_ten_min md where metric_id in (select id from metric where name = 'Hardware Resources|Memory|Total (MB)') and ts_min > floor((unix_timestamp() / 60) - 4*60) group by node_id order by node_id) memory on n.id=memory.node_id INTO OUTFILE '/home/jun.ouyang/test1/memory.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Active Bts"
union all
select
n.id node_id,
active_bts.active_bts "Active Bts"
from
application_component_node n left join
(select node_id, count(distinct metric_id) active_bts from metricdata_ten_min md where md.metric_id in (select id from metric where name like "BTM|BTs|BT:%" and name like "%|Calls per Minute" and length(name) - length(REPLACE(name, '|', '')) = 4) and ts_min > floor((unix_timestamp() / 60) - 4*60) and md.sum_val > 0 group by node_id order by node_id) active_bts on n.id=active_bts.node_id INTO OUTFILE '/home/jun.ouyang/test1/active_bts.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Active Seps"
union all
select
n.id node_id,
active_seps.active_seps "Active Seps"
from
application_component_node n left join
(select node_id, count(distinct metric_id) active_seps from metricdata_ten_min md where md.metric_id in (select id from metric where name like "BTM|Application Diagnostic Data|SEP:%" and name like "%|Calls per Minute") and ts_min > floor((unix_timestamp() / 60) - 4*60) and md.sum_val > 0 group by node_id order by node_id) active_seps on n.id=active_seps.node_id INTO OUTFILE '/home/jun.ouyang/test1/active_seps.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Host id",
"Host name",
"CPU core count"
union all
select
n.id node_id,
host.host_id "Host id",
host.host_name "Host name",
host.cpu_core_count "CPU core count"
from
application_component_node n left join
(select acn.id node_id, sm.id machine_id, sum(property_value) cpu_core_count, sm.name host_name, sm.host_id from application_component_node acn left join machine_instance mi on acn.machine_instance_id=mi.id left join sim_machine sm on sm.host_id=mi.internal_name and sm.account_id=mi.account_id left join sim_machine_property smp on sm.id=smp.machine_id where property_key like "CPU%|Core Count" group by acn.id) host on n.id=host.node_id INTO OUTFILE '/home/jun.ouyang/test1/host.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Logical processes count"
union all
select
n.id node_id,
cpu_l.cpu_logical_processes_count "Logical processes count"
from
application_component_node n left join
(select acn.id node_id, sm.id machine_id, sum(property_value) cpu_logical_processes_count, sm.name host_name, sm.host_id from application_component_node acn left join machine_instance mi on acn.machine_instance_id=mi.id left join sim_machine sm on sm.host_id=mi.internal_name and sm.account_id=mi.account_id left join sim_machine_property smp on sm.id=smp.machine_id where property_key like "CPU%|Logical Processor Count" group by acn.id) cpu_l on n.id=cpu_l.node_id INTO OUTFILE '/home/jun.ouyang/test1/cpu_l.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';


select
"Node id",
"Metrics per minute max",
"Metrics per minute min",
"Metrics per minute avg"
union all
select
n.id node_id,
mpm.metrics_per_min_max "Metrics per minute max",
mpm.metrics_per_min_min "Metrics per minute min",
mpm.metrics_per_min_avg "Metrics per minute avg"
from
application_component_node n left join
(select node_id, max(c) metrics_per_min_max, min(c) metrics_per_min_min, round(avg(c)) metrics_per_min_avg from (select count(*) c, ts_min, node_id from metricdata_ten_min where ts_min > floor((unix_timestamp() / 60) - 4*60) group by node_id, ts_min) mc group by node_id) mpm on n.id=mpm.node_id INTO OUTFILE '/home/jun.ouyang/test1/mpm.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Events per minute max",
"Events per minute min",
"Events per minute avg"
union all
select
n.id node_id,
epm.events_per_min_max "Events per minute max",
epm.events_per_min_min "Events per minute min",
epm.events_per_min_avg "Events per minute avg"
from
application_component_node n left join
(select triggered_entity_id node_id, max(c) events_per_min_max, min(c) events_per_min_min, round(avg(c)) events_per_min_avg from (select count(*) c, ts_min, triggered_entity_id from eventdata_min where ts_min > floor((unix_timestamp() / 60) - 4*60) and triggered_entity_type='APPLICATION_COMPONENT_NODE' group by triggered_entity_id, ts_min) ec group by triggered_entity_id) epm on n.id=epm.node_id INTO OUTFILE '/home/jun.ouyang/test1/epm.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

select
"Node id",
"Snapshots per minute max",
"Snapshots per minute min",
"Snapshots per minute avg"
union all
select
n.id node_id,
spm.snapshots_per_min_max "Snapshots per minute max",
spm.snapshots_per_min_min "Snapshots per minute min",
spm.snapshots_per_min_avg "Snapshots per minute avg"
from
application_component_node n left join
(select node_id, max(c) snapshots_per_min_max, min(c) snapshots_per_min_min, round(avg(c)) snapshots_per_min_avg from (select count(distinct guid) c, ts_ms/60000, node_id from requestdata_summary where ts_ms > floor((unix_timestamp() * 1000 ) - 4*3600 * 1000) group by node_id, ts_ms/60000) sc group by node_id) spm on n.id=spm.node_id INTO OUTFILE '/home/jun.ouyang/test1/spm.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';