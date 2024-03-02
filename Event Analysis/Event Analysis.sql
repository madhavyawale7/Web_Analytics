event analysis

Q1 calculate total number of events?
select count(event_name) as total_events
from event_identifier 



Q2 What are the most frequent event recorded?
select ei.event_name as event_name,
count(*) as event_count
from events e
join event_identifier ei on ei.event_type = e.event_type
group by 1



Q3 Analyze How many events were recorded on each day?
select date(event_time) as event_date,
count(*) as total_events
from events
group by 1



Q4 What percentage of visits include viewing the checkout page but do not result in a purchase event?
select (1-a.purchase/a.checkout)*100 as percentage 
from ( select sum(case when event_type = 1 
and page_id = 12 then 1 else 0 end) as checkout, 
sum(case when event_type = 3 then 1 else 0 end) as purchase 
from events) as a



Q5 What are the most common sequences of events before a purchase occurs?
with purchase_events as (
select distinct visit_id
from events
where event_type = 3
)
select ei.event_name, COUNT(*) AS event_count_before_purchase
from events e
join event_identifier ei on ei.event_type = e.event_type
where visit_id in (select visit_id from purchase_events)
group by 1
order by 2 desc



Q6 How does the frequency of specific events change over time?
select date(event_time) as event_date,
event_name,
count(*) as event_count
from events e
join event_identifier ei on ei.event_type = e.event_type
group by 1, 2
order by 1



Q7 What percentage of visits involve page views but do not lead to a purchase event and  what percentage of visits include a purchase event?
with PageViewsPerVisit as (
select visit_id,
count(*) as page_views_count
from events
where event_type = 1
group by 1
),
PurchaseEventsPerVisit as (
select visit_id,
count(*) as purchase_events_count
from events
where event_type = 3
group by 1
)
select 
round(count(distinct pe.visit_id) * 100 / count(distinct pv.visit_id),2) as percentage_visits_with_purchase,
round((count(distinct pv.visit_id) - count(distinct pe.visit_id)) * 100 / count(distinct pv.visit_id),2) as percentage_visits_without_purchase
from PageViewsPerVisit pv
left join PurchaseEventsPerVisit pe on pv.visit_id = pe.visit_id



Q8 calculate average number of cookie id for each event?
select e.event_name as event_name,
avg(cookie_count) as average_cookie_count
from event_identifier e
left join events ev on e.event_type = ev.event_type
left join
(select event_type,
count(distinct cookie_id) as cookie_count
from events
group by 1
) as cookie_counts on e.event_type = cookie_counts.event_type
group by 1



Q9 what is average of sequence number for each event? 
select event_name,
avg(sequence_number) as average_sequence_number
from event_identifier
join events on event_identifier.event_type = events.event_type
group by 1



Q10 calculate total number of cookie id and unique cookie id for each event?
select ei.event_name,
count(e.cookie_id) as total_cookie,
count(distinct e.cookie_id) as unique_cookie
from event_identifier ei
join events e on ei.event_type = e.event_type
group by 1



Q11 calculate total number of users,unique users and average number of users click on each event? 
select ei.event_name as event_name,
count(u.user_id) as total_users,
count(distinct u.user_id) as unique_users,
avg(distinct u.user_id) as avg_no_users
from event_identifier ei
join events e on ei.event_type = e.event_type
join users u on u.cookie_id = e.cookie_id
group by 1



Q12 calculate total number of visits and unique visits for each event? 
select ei.event_name as event_name,
count(e.visit_id) as total_visit,
count(distinct e.visit_id) as unique_visit
from event_identifier ei
join events e on ei.event_type = e.event_type
join users u on u.cookie_id = e.cookie_id
group by 1



Q13 calculate average number of visits for each event? 
select ei.event_name as event_name,
avg(visits_per_event) as average_visits_per_event
from event_identifier ei
join(
select event_type,
count(distinct visit_id) as visits_per_event
from events
group by 1
)as event_visits on ei.event_type = event_visits.event_type
group by 1 



Q14 What are the total and average page views, total and average cart additions, total and average purchases, and the purchase rate for visits with and without ad impression?
with visit_summary as (select e.visit_id,min(e.event_time) as visit_start_time,sum(case when e.event_type = 1 then 1 else 0 end) as page_views,
sum(case when e.event_type = 2 then 1 else 0 end) as cart_adds,max(case when e.event_type = 3 then 1 else 0 end) as purchase,
sum(case when e.event_type = 4 then 1 else 0 end) as impression,sum(case when e.event_type = 5 then 1 else 0 end) as click
from events e 
inner join users u on e.cookie_id = u.cookie_id
left join page_hierarchy ph on e.page_id = ph.page_id
group by 1)
select 'with_impression' as impression_status,round(sum(page_views), 2) as total_page_views,round(avg(page_views), 2) as avg_page_views,
round(sum(cart_adds), 2) as total_cart_adds,round(avg(cart_adds), 2) as avg_cart_adds,round(sum(purchase), 2) as total_purchase,
round(avg(purchase), 2) as avg_purchase,round(100 * sum(purchase) / count(*), 2) as purchase_rate
from visit_summary
where impression > 0
union all
select 'without_impression' as impression_status,round(sum(page_views), 2) as total_page_views,round(avg(page_views), 2) as avg_page_views,
round(sum(cart_adds), 2) as total_cart_adds,round(avg(cart_adds), 2) as avg_cart_adds,round(sum(purchase), 2) as total_purchase,
round(avg(purchase), 2) as avg_purchase,round(100 * sum(purchase) / count(*), 2) as purchase_rate
from visit_summary
where impression = 0



Q15 What are the total and average page views, total and average cart additions, total and average purchases, and the purchase rate for visits with and without ad clicks?
with visit_summary as (select e.visit_id,min(e.event_time) as visit_start_time,sum(case when e.event_type = 1 then 1 else 0 end) as page_views,
sum(case when e.event_type = 2 then 1 else 0 end) as cart_adds,
max(case when e.event_type = 3 then 1 else 0 end) as purchase,
sum(case when e.event_type = 4 then 1 else 0 end) as impression,
sum(case when e.event_type = 5 then 1 else 0 end) as click
from events e
inner join users u on e.cookie_id = u.cookie_id
left join page_hierarchy ph on e.page_id = ph.page_id
group by 1)
select 'with_click' as click_status,round(sum(page_views), 2) as total_page_views,round(avg(page_views), 2) as avg_page_views,
round(sum(cart_adds), 2) as total_cart_adds,round(avg(cart_adds), 2) as avg_cart_adds,
round(sum(purchase), 2) as total_purchase,round(avg(purchase), 2) as avg_purchase,
round(100 * sum(purchase) / count(*), 2) as purchase_rate from visit_summary
where click > 0
union all
select 'without_click' as click_status,round(sum(page_views), 2) as total_page_views,round(avg(page_views), 2) as avg_page_views,
round(sum(cart_adds), 2) as total_cart_adds,round(avg(cart_adds), 2) as avg_cart_adds,
round(sum(purchase), 2) as total_purchase,round(avg(purchase), 2) as avg_purchase,
round(100 * sum(purchase) / count(*), 2) as purchase_rate from visit_summary
where click = 0



Q16 What is the purchase rate for visits where users interacted with the website by clicking, for visits without impressions & for visits with impressions but without clicks?
with visit_summary as (select e.visit_id,min(e.event_time) as visit_start_time,sum(case when e.event_type = 1 then 1 else 0 end) as page_views,
sum(case when e.event_type = 2 then 1 else 0 end) as cart_adds,max(case when e.event_type = 3 then 1 else 0 end) as purchase,
sum(case when e.event_type = 4 then 1 else 0 end) as impression,sum(case when e.event_type = 5 then 1 else 0 end) as click
from events e
inner join users u on e.cookie_id = u.cookie_id
left join page_hierarchy ph on e.page_id = ph.page_id
group by 1)
select 'with_click' as impression_status, round(100 * sum(purchase) / count(*), 2) as purchase_rate
from visit_summary
where click > 0
union all
select 'without_impression' as impression_status,round(100 * sum(purchase) / count(*), 2) as purchase_rate
from visit_summary
where impression = 0 
union all
select 'with_impression_without_click' as impression_status,round(100 * sum(purchase) / count(*), 2) as purchase_rate
from visit_summary
where impression > 0 and click = 0;

