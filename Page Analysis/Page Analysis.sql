page analysis

Q1 Calculate the page view count of each pages?
select ph.page_name as page_name,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as add_to_cart_count
from page_hierarchy ph
join events e on e.page_id = ph.page_id
group by 1
order by 2 desc




Q2 Distribution of events Throughout the Day?
select ph.page_name as page_name,
hour(e.event_time) as hour_of_day,
count(*) as total_events
from events e 
join page_hierarchy ph on ph.page_id = e.page_id
group by 1,2
order by 2




Q3 What is the bounce rate for each page (percentage of visits that view only one page)?
select ph.page_name as page_name,
sum(case when sequence_number = 1 then 1 else 0 end) / count(*) as bounce_rate
from events e 
join page_hierarchy ph on ph.page_id = e.page_id
group by ph.page_name




Q4 Number of total users and Unique Users and average number of users Visited Each Page?
select ph.page_name as page_name,
count(u.user_id) as total_users,
count(distinct u.user_id) as unique_users
avg(distinct u.user_id) as unique_users
from events e 
join page_hierarchy ph on ph.page_id = e.page_id
join users u on u.cookie_id = e.cookie_id
group by 1




Q5 Average Sequence Number for Each Page?
select page_name as page_name,
avg(sequence_number) as avg_sequence_number
from events e 
join page_hierarchy ph on ph.page_id = e.page_id
group by 1




Q6 Find average number of unique cookies for each page?
select ph.page_name as page_name,
avg(cookie_count) as average_cookie_count
from page_hierarchy ph
left join (select page_id,
count(distinct cookie_id) as cookie_count
from
events
group by 1
) as cookie_counts on ph.page_id = cookie_counts.page_id
group by 1




Q7 What is the trend of page views over time?
select ph.page_name as page_name,
date(event_time) as date,
count(*) as page_views
from events e 
join page_hierarchy ph on ph.page_id = e.page_id
where event_type = 1
group by 1,2
order by 2




Q8 calculate total and unique visitors for each page?
select ph.page_name as page_name,
count(e.visit_id) as total_visitors_count,
count(distinct e.visit_id) as unique_visitors_count
from events e
join page_hierarchy ph on e.page_id = ph.page_id
group by 1
order by 2 desc




Q9 calculate total and unique cookie id of each pages?
select ph.page_name as page_name,
count(e.cookie_id) as total_visitors_count,
count(distinct e.cookie_id) as unique_visitors_count
from events e
join page_hierarchy ph on e.page_id = ph.page_id
group by 1
order by 2 desc