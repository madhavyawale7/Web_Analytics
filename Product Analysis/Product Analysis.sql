product analysis

Q1 Which product category has the maximum number of products?
select product_category,count(distinct product_id)as toatl_product
from page_hierarchy
where product_id is not null
group by 1
order by 2 desc
limit 1



Q2 What is the distribution of number of views, cart adds, abandon and purchase for each product?
with product_page_events as (select e.visit_id,ph.product_id,ph.page_name,ph.product_category,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
where ph.product_id is not null
group by 1,2,3,4),
visit_purchase as (select distinct visit_id
from events
where event_type = 3),
combined_product_events as (select t1.visit_id,t1.product_id,t1.page_name,t1.product_category,t1.page_view,
t1.cart_add,case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase  as t2 on t1.visit_id = t2.visit_id)
select page_name as product,
sum(page_view) as page_views,
sum(cart_add) as cart_adds,
sum(case when cart_add = 1 and purchase = 0 then 1 else 0 end) as abandoned,
sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) as purchases
from combined_product_events
group by  product




Q3 What are the conversion rates for add-to-cart-to-purchase, page-view-to-purchase,  page-view-to-cart-add and cart add to abandoned for each product?
with product_page_events as (select e.visit_id,ph.product_id,ph.page_name,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
where ph.product_id is not null
group by 1, 2, 3),
visit_purchase as (select distinct visit_id from events where event_type = 3),
combined_product_events as (select t1.visit_id,t1.product_id,t1.page_name,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase as t2 on t1.visit_id = t2.visit_id)
select page_name as product,
round(sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) * 100.0 / sum(page_view),2) as page_view_to_purchase_rate,
round((sum(case when cart_add > 0 and purchase = 1 then 1 else 0 end) * 100.0 / sum(cart_add)),2) as add_to_cart_to_purchase_rate,
round((sum(case when page_view > 0 and cart_add > 0 then 1 else 0 end) * 100.0 / sum(page_view)),2) as page_view_to_add_to_cart_rate,
round(sum(CASE WHEN cart_add > 0 AND purchase = 0 THEN 1 ELSE 0 END) * 100.0 / SUM(cart_add), 2) AS cart_add_to_abandoned_rate
from combined_product_events
group by 1
order by 1




Q4 Which product category are frequently viewed together or purchased together during a campaign?
with VisitProducts as(select e.visit_id,
ph.product_category
from events e
join page_hierarchy ph on e.page_id = ph.page_id
where e.event_type = 1
),
VisitPairs as (select vp1.visit_id as visit_id1,
vp1.product_category as product_category1,
vp2.visit_id as visit_id2,
vp2.product_category as product_category2
from VisitProducts vp1
join VisitProducts vp2 on vp1.visit_id = vp2.visit_id
where vp1.product_category <> vp2.product_category
)
select product_category1,
product_category2,
count(*) as co_occurrences
from VisitPairs
group by 1,2
order by 3 desc




Q5 What is the count of events for each product category?
select ph.product_category as product_category,
count(*) as event_count
from events e
join page_hierarchy ph on e.page_id= ph.page_id
group by 1
limit 3
offset 1





Q6 How many times was each product added to a cart but not purchased and purchased count?
with cart_event as (select ph.product_id,
e.visit_id,
count(*) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
where ph.product_id is not null and e.event_type = 2
group by ph.product_id, e.visit_id),
visit_purchase as ( select distinct visit_id
from events
where event_type = 3),
combined_product_events as (select ce.product_id,
ce.cart_add,
case when vp.visit_id is null then 1 else 0 end as purchase
from cart_event ce
left join visit_purchase vp on ce.visit_id = vp.visit_id)
select product_id,
sum(case when cart_add = 1 and purchase = 0 then 1 else 0 end) as added_and_not_purchased,
sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) as purchases
from combined_product_events
group by product_id




Q7 What is the number of views,cart adds,add to cart but not purchasedd and purchased for each product category?
with product_page_events as (select e.visit_id,ph.product_id,ph.product_category,
sum(case when event_type = 1 then 1 else 0 end) as page_view
,sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
where ph.product_id is not null
group by 1,2,3),
visit_purchase as (select distinct visit_id
from events
where event_type = 3),
combined_product_events as (select t1.visit_id,t1.product_id,t1.product_category,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase  as t2 on t1.visit_id = t2.visit_id)
select product_category,sum(page_view) as page_views,sum(cart_add) as cart_adds,
sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) as purchased,
sum(case when cart_add = 1 and purchase = 0 then 1 else 0 end) as abandoned
from combined_product_events
group by 1
order by 1




Q8 What are the conversion rates for add-to-cart-to-purchase, page-view-to-purchase,  page-view-to-cart-add and cart add to abandoned for each product category?
with product_page_events as (select e.visit_id,ph.product_id,ph.product_category,
sum(case when event_type = 1 then 1 else 0 end) as page_view,
sum(case when event_type = 2 then 1 else 0 end) as cart_add
from events e
join page_hierarchy ph on e.page_id = ph.page_id
join campaign_identifier ci on ci.product_id = ph.product_id
where ph.product_id is not null
group by 1, 2, 3),
visit_purchase as (select distinct visit_id from events where event_type = 3),
combined_product_events as (select t1.visit_id,t1.product_id,t1.product_category,t1.page_view,t1.cart_add,
case when t2.visit_id is not null then 1 else 0 end as purchase
from product_page_events as t1
left join visit_purchase as t2 on t1.visit_id = t2.visit_id)
select product_category,
round(sum(case when cart_add = 1 and purchase = 1 then 1 else 0 end) * 100.0 / sum(page_view),2) as page_view_to_purchase_rate,
round((sum(case when cart_add > 0 and purchase = 1 then 1 else 0 end) * 100.0 / sum(cart_add)),2) as add_to_cart_to_purchase_rate,
round((sum(case when page_view > 0 and cart_add > 0 then 1 else 0 end) * 100.0 / sum(page_view)),2) as page_view_to_add_to_cart_rate,
round(sum(CASE WHEN cart_add > 0 AND purchase = 0 THEN 1 ELSE 0 END) * 100.0 / SUM(cart_add), 2) AS cart_add_to_abandoned_rate
from combined_product_events
group by 1
order by 1



Q9  What are the products added to the cart by users during their website visits?
with product_sequence as (select e.visit_id,e.cookie_id as user_id,
group_concat(case when e.event_type = 2 then ph.page_name else null end order by e.sequence_number, ', ') as cart_products
from events as e
left join clique_bait.page_hierarchy as ph on e.page_id = ph.page_id
group by 1,2
)
select ps.visit_id,ps.user_id,substring_index(substring_index(ps.cart_products, ', ', n), ', ', -1) as product_added
from product_sequence as ps
join (select 1 + units.i + tens.i * 10 as n
from(select 0 as i union select 1 union select 2 union select 3 union select 4 union 
select 5 union select 6 union select 7 union select 8 union select 9) as units
cross join
(select 0 as i union select 1 union select 2 union select 3 union select 4 union 
select 5 union select 6 union select 7 union select 8 union select 9) as tens
order by n
) as numbers
on char_length(ps.cart_products) - char_length(replace(ps.cart_products, ', ', '')) >= n - 1
limit 10




Q10 Analyze common sequences of products added to the cart?
with cartsequences as (select u.user_id,ph.page_name,e.event_time,
row_number() over (partition by u.user_id order by e.event_time) as sequence_number
from events e
join users u on e.cookie_id = u.cookie_id
join page_hierarchy ph on e.page_id = ph.page_id
where e.event_type = 2 
)
select prev.page_name as previous_product_name,curr.page_name as current_product_name,count(*) as sequence_count
from cartsequences curr
join cartsequences prev on curr.user_id = prev.user_id and curr.sequence_number = prev.sequence_number + 1
group by 1,2
order by 3 desc








