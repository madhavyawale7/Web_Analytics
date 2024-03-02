campaign analysis

Q1 How many campaigns have been run within a specific time period?
select count(distinct campaign_id) as total_campaigns
from campaign_identifier
where start_date >= date(start_date) and end_date <= date(end_date)



Q2 What are the start and end dates of each campaign?
select campaign_name as campaign_name, min(date(start_date)) as start_date, max(date(end_date)) as end_date
from campaign_identifier
group by 1




Q3 How many total visits and unique visits were generated during each campaign?
select ci.campaign_name as campaign_name,
count(e.visit_id) as total_visits,
count(distinct e.visit_id) as total_unique_visits
from campaign_identifier ci
join page_hierarchy ph on ci.product_id = ph.product_id
join events e on e.page_id = ph.page_id
group by 1




Q4 What is the average duration of each campaign?
select campaign_name as campaign_name,
avg(datediff(end_date, start_date)) as average_duration_days
from campaign_identifier
group by 1




Q5 How many total users and unique users and average unique users engaged with each campaign?
select ci.campaign_name as campaign_name,count(user_id) as total_user,
count(distinct user_id) as unique_users,
avg(distinct user_id) as average_no_of_users
from campaign_identifier ci 
join page_hierarchy ph on ci.product_id = ph.product_id
join events e on e.page_id = ph.page_id
join users u on u.cookie_id = e.cookie_id
group by 1



Q6 How do event types vary across different campaigns?
select ci.campaign_name as campaign_name,
e.event_type as event_type,
count(*) AS event_count
from events e
join page_hierarchy ph on ph.page_id = e.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
group by 1,2



Q7 How many products were associated with each of the specified campaigns?
select campaign_name,count(product_id) as product_count
from campaign_identifier
where campaign_id = 1
group by 1
union 
select campaign_name,count(product_id) as product_count
from campaign_identifier
where campaign_id = 3
group by 1
union
select campaign_name,count(product_id) as product_count
from campaign_identifier
where campaign_id = 2
group by 1




Q8 What is the number of views,cart adds,add to cart but not purchased and purchased in each campaign?
with product_page_events as (select e.visit_id,ph.product_id,ci.campaign_name,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
where ph.product_id is not null
group by 1,2,3
),
visit_purchase as (select distinct visit_id
from events
where event_type = 3
),
combined_product_events as (select t1.visit_id,t1.product_id,t1.campaign_name,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase  as t2 on t1.visit_id = t2.visit_id)
select campaign_name,sum(page_view) as page_views,sum(cart_add) as cart_adds,
sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) as purchased,
sum(case when cart_add = 1 and purchase = 0 then 1 else 0 end) as abandoned
from combined_product_events
group by 1
order by 1




Q9 What are the conversion rates for add-to-cart-to-purchase, page-view-to-purchase,  page-view-to-cart-add and cart add to abandoned for each campaign?
with product_page_events as (select e.visit_id,ph.product_id,ci.campaign_name,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
where ph.product_id is not null
group by 1, 2, 3),
visit_purchase as (select distinct visit_id from events where event_type = 3),
combined_product_events as (select t1.visit_id,t1.product_id,t1.campaign_name,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase as t2 on t1.visit_id = t2.visit_id)
select campaign_name,
round(sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) * 100.0 / sum(page_view),2) as page_view_to_purchase_rate,
round((sum(case when cart_add > 0 and purchase = 1 then 1 else 0 end) * 100.0 / sum(cart_add)),2) as add_to_cart_to_purchase_rate,
round((sum(case when page_view > 0 and cart_add > 0 then 1 else 0 end) * 100.0 / sum(page_view)),2) as page_view_to_add_to_cart_rate,
round(sum(CASE WHEN cart_add > 0 AND purchase = 0 THEN 1 ELSE 0 END) * 100.0 / SUM(cart_add), 2) AS cart_add_to_abandoned_rate
from combined_product_events
group by 1
order by 1




Q10 How many total cookie id and unique cookie id of each campaign?
select ci.campaign_name as campaign_name,
count(e.cookie_id) as total_cookies,
count(distinct e.cookie_id) as unique_cookies
from campaign_identifier ci 
join page_hierarchy ph on ci.product_id = ph.product_id
join events e on e.page_id = ph.page_id
group by 1





q11 What is the average sequence number of each campaign?
select ci.campaign_name as campaign_name,
avg(e.sequence_number) as avg_sequence_number
from campaign_identifier ci
join page_hierarchy ph on ph.product_id = ci.product_id
join events e on e.page_id = ph.page_id
group by 1





Q12 What is the Abandoned Rate Of Product in Each Campaign?
with product_page_events as (select e.visit_id,ph.product_id,ci.campaign_name,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
where ph.product_id is not null
group by 1, 2, 3
),
visit_purchase as (select distinct visit_id
from events
where event_type = 3
),
combined_product_events as (select t1.visit_id,t1.product_id,t1.campaign_name,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase as t2 on t1.visit_id = t2.visit_id
)
select campaign_name,
round(sum(case when cart_add = 1 and purchase = 0 then 1 else 0 end) * 1.0*100 / sum(cart_add), 2)as abandoned_rate
from combined_product_events
group by 1
