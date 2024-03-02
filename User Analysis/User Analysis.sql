user analysis 

Q1 Count the number of unique users?
select count(distinct user_id) as unique_users
from users



Q2 Calculate the frequency of user visits?
select u.user_id as user_id,
count(e.visit_id) as visit_frequency
from users u
join events e on u.cookie_id = e.cookie_id
group by 1



Q3 Analyze user engagement patterns over time?
select date(event_time) as engagement_time,
count(distinct visit_id) as num_sessions,
count(*) as total_events
from events
group by 1



Q4 Analyse How has the number of users active in each month?
select date_format(u.start_date, '%Y-%m') as registration_month,
count(distinct u.user_id) as total_active_users
from users u
group by 1
order by 1



Q5 What is the retention rate of users over multiple visits?
select count(user_id) as total_users,
count(case when visit_count > 1 then user_id end) as returning_users,
(count(case when visit_count > 1 then user_id end) / count(user_id)) * 100 as retention_rate
from (select u.user_id, COUNT(*) as visit_count
from events e
join users u on u.cookie_id = e.cookie_id
group by user_id
) as user_visits



Q6 What are the peak hours for user activity on the site?
select hour(event_time) as hour_of_day,
count(*) as activity_count
from events
group by 1
order by 2 desc



Q7 What are the busiest months for user engagement?
select month(event_time) as month,
count(*) as engagement_count
from events
group by 1
order by 2 desc
limit 5



Q8 How many cookies does each user have on average?
select avg(cookie_count) as average_cookies_per_user
from (select user_id,
count(distinct cookie_id) as cookie_count
from users
group by user_id) as user_cookie_counts



Q9 Analyse the user behavior of visiting the pages, also which page he is visiting the most?
select *
from (
select u.user_id as user_id,ph.page_name as page_name,count(visit_id) as visit_count,
row_number() over (partition by user_id order by count(visit_id)desc)as row_no
from users as u
join events as e on e.cookie_id = u.cookie_id
inner join page_hierarchy as ph on ph.page_id = e.page_id
where ph.product_id is not null
group by 1,2
)as x
where x.row_no = 1



Q10 Analyse How does the event distribution vary among users? 
select user_id,
sum(case when ei.event_name = 'Page View' then 1 else 0 end) as page_view_count,
sum(case when ei.event_name = 'Add to Cart' then 1 else 0 end) as add_cart_count,
sum(case when ei.event_name = 'Purchase' then 1 else 0 end) as purchase_count,
sum(case when ei.event_name = 'Ad Click' then 1 else 0 end) as ad_click_count,
sum(case when ei.event_name = 'Ad Impression' then 1 else 0 end) as ad_impression_count
from users u
join events e on u.cookie_id = e.cookie_id
join event_identifier ei on e.event_type = ei.event_type
group by 1



Q11 What is the unique number of visits by all users per month?
select month(event_time) as month,
count(distinct visit_id) as uniqe_visit
from events 
group by 1



Q12 What are the conversion rates for add-to-cart-to-purchase, page-view-to-purchase,  page-view-to-cart-add and cart add to abandoned?
with product_page_events as (select e.visit_id,ph.product_id,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
where ph.product_id is not null
group by 1,2),
visit_purchase as (select distinct visit_id from events where event_type = 3),
combined_product_events as (select t1.visit_id,t1.product_id,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase as t2 on t1.visit_id = t2.visit_id)
select 
round(sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) * 100.0 / sum(page_view), 2) AS page_view_to_purchase_rate,
round(sum(case when cart_add > 0 and purchase = 1 then 1 else 0 end) * 100.0 / sum(cart_add), 2) AS add_to_cart_to_purchase_rate,
round(sum(case when page_view > 0 and cart_add > 0 then 1 else 0 end) * 100.0 / sum(page_view), 2) AS page_view_to_add_to_cart_rate,
round(sum(case when cart_add > 0 and purchase = 0 then 1 else 0 end) * 100.0 / sum(cart_add), 2) AS cart_add_to_abandoned_rate
from combined_product_events



Q13 Calculate total and distinct number of cookies of each user?
select u.user_id,
count(e.cookie_id)as total_cookies,
count(distinct e.cookie_id)as unique_cookie
from users u
join events e on e.cookie_id = u.cookie_id
group by 1