-- Apple Sales Project - 1M rows sales datasets

select * from category;
select * from products;
select * from stores;
select * from warranty;
select * from sales;

-- Exploratory data analysis

select distinct repair_status from warranty;


select count(*) from sales;

-- improving query performance by creating index

--et - 71.734 ms
-- et after index - 5 ms 


explain analyze
select * from sales
where product_id = 'P-44';

create index sales_product_id ON sales(product_id);


create index sales_store_id on sales(store_id);

--et 60 ms
-- after index et 2 ms
explain analyze
select * from sales
where store_id = 'ST-31';

--1. find the number of stores in each country

select country, count(store_id) as num_of_stores from stores
group by country
order by num_of_stores desc;

--Uk and USA both has 10 stores each, followed by canada and china at 8 and 4 respectively.
-- australia has 3, whereas brazil,japan,spain,turkey, india, france, germany, UAE all has 2.

--2. calculate the number of units sold by each stores

select st.store_name, st.city, sum(s.quantity) as total_sales
from stores as st
 join sales as s
on st.store_id = s.store_id
group by 1,2
order by 3 desc;

-- apple south coast plaza located in coata mesa city has the most quantity sold at 47498, followed by apple michigan avenue, chicago at 44891.

--3. Identify how many sales occurred in December 2023.


select sum(quantity) as total_sales_dec_2023
from sales
where sale_date between '2023-12-01' and '2023-12-31';

-- the total units sold in the month od december 2023 is 32846 units.

--4. Determine how many stores have never had a warranty claim filed.

select * from stores
where store_id not in (
					select distinct(store_id) from sales as s
					right join warranty as w
					on s.sale_id = w.sale_id
					);


--5. Calculate the percentage of warranty claims marked as "Warranty Void".

select distinct(repair_status) from warranty;

SELECT 
    (SELECT COUNT(*) 
     FROM warranty 
     WHERE repair_status = 'Warranty Void') 
     * 100.0 / COUNT(claim_id) AS void_percentage
FROM warranty;

-- 23.16%

-- 6. Identify which store had the highest total units sold in the last year.

select store_name, sum(s.quantity) as total_quantity from stores as st
join sales as s
on st.store_id = s.store_id
where s.sale_date >= '2023-09-27'
group by store_name
order by 2 desc;

select current_date - INTERVAL '1 year'

select * from sales
where sale_date >= '2023-09-27'

-- apple new delhi had the highest sale of 15728 units in the year 2023

-- 7. Count the number of unique products sold in the last year.

-- 8. Find the average price of products in each category.

select category_id, category_name, avg(price) as average_price from category as ca

select ca.category_id,ca.category_name, avg(p.price) as average_price from products as p
join category as ca
on p.category_id = ca.category_id
group by 1,2
order by 3 desc;

-- 9. How many warranty claims were filed in 2020?

select count(claim_id) from warranty
where claim_date between '2020-01-01' and '2020-12-31'

--alterantive way

select count(claim_id) from warranty
where extract(year from claim_date) = '2020'

-- 10. For each store, identify the best-selling day based on highest quantity sold.

SELECT *
FROM (
    SELECT 
        st.store_name,
        to_char(sale_date, 'Day') as day_name,
        SUM(s.quantity) AS total_quantity,
        RANK() OVER (
            PARTITION BY st.store_name 
            ORDER BY SUM(s.quantity) DESC
        ) AS rnk
    FROM sales s
    JOIN stores st
        ON s.store_id = st.store_id
    GROUP BY 1,2
) t
WHERE rnk = 1;


--Medium to Hard (5 Questions)

-- 11.Identify the least selling product in each country for each year based on total units sold.


select s.product_id,st.country, extract(year from sale_date) as year, sum(s.quantity) as quantity_sold 
from sales as s
join stores as st
on st.store_id = s.store_id
group by 1,2,3
order by 4 asc;


SELECT product_id, product_name, country, year, quantity_sold
FROM (
    SELECT 
        s.product_id,
        p.product_name,
        st.country,
        EXTRACT(YEAR FROM s.sale_date) AS year,
        SUM(s.quantity) AS quantity_sold,
        RANK() OVER (
            PARTITION BY st.country, EXTRACT(YEAR FROM s.sale_date)
            ORDER BY SUM(s.quantity) ASC
        ) AS rnk
    FROM sales s
    JOIN stores st
        ON st.store_id = s.store_id
    JOIN products p
        ON p.product_id = s.product_id
    GROUP BY s.product_id, p.product_name, st.country, EXTRACT(YEAR FROM s.sale_date)
) t
WHERE rnk = 1;

-- 12. Calculate how many warranty claims were filed within 180 days of a product sale.


select count(w.claim_date - s.sale_date) as claims_after_sales_date from sales as s
join warranty as w
on s.sale_id = w.sale_id
where w.claim_date - s.sale_date <= 180

-- 13. Determine how many warranty claims were filed for each products launched in the last two years.

select 
    p.product_name,
    count(w.claim_id) AS warranty_claims
from warranty w
left join sales s
    on w.sale_id = s.sale_id
left join products p
    on s.product_id = p.product_id
where p.launch_date >= (
        select max(sale_date) - INTERVAL '2 years'
        from sales
)
group by p.product_name;

-- 14. List the months in the last three years where sales exceeded 5,000 units in the USA.

select * from sales

select extract(YEAR FROM s.sale_date) AS year, extract(month FROM s.sale_date) AS month, sum(quantity) from sales as s
left join stores as st
on s.store_id = st.store_id
where st.country = 'USA' and s.sale_date >= ( select max(sale_date) - INTERVAL '3 years'
        from sales)
group by 1,2
having sum(s.quantity) > 5000
order by 3 desc;

-- 15. Identify the product category with the most warranty claims filed in the last two years.

select 
    c.category_id, c.category_name,
    count(w.claim_id) as warranty_claims
from warranty as w
left join sales as s
    on w.sale_id = s.sale_id
left join products as p
    on s.product_id = p.product_id
left join category as c
	on c.category_id = p.category_id
where s.sale_date >= (select max(sale_date) - INTERVAL '2 years'
        from sales
)
group by 1,2
order by 3 desc;

--16. Determine the percentage chance of receiving warranty claims after each purchase for each country.

select 
    st.country,
    count(s.sale_id) as total_purchases,
    count(w.claim_id) as purchases_with_claim,
    count(w.claim_id) * 100.0 / count(s.sale_id) as claim_percentage
from sales s
join stores st
    on s.store_id = st.store_id
left join warranty w
    on s.sale_id = w.sale_id
group by st.country
order by claim_percentage desc;

--17. Analyze the year-by-year growth ratio for each store.

with yearly_sales as (
    select 
        s.store_id,
        extract(year from s.sale_date) as year,
        sum(s.quantity) as total_quantity
    from sales s
    group by s.store_id, extract(year from s.sale_date)
)

select 
    store_id,
    year,
    total_quantity,
    lag(total_quantity) over (
        partition by store_id 
        order by year
    ) as previous_year_sales,
    (total_quantity - lag(total_quantity) over (
        partition by store_id 
        order by year
    )) * 100.0 
    / lag(total_quantity) over (
        partition by store_id 
        order by year
    ) as growth_percentage
from yearly_sales
order by store_id, year;


--18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.

with product_claims as (
    select 
        p.product_id,
        p.price,
        count(w.claim_id) as total_claims,
        case 
            when p.price < 500 then 'low'
            when p.price between 500 and 1000 then 'medium'
            else 'high'
        end as price_range
    from sales s
    join products p 
        on s.product_id = p.product_id
    left join warranty w 
        on s.sale_id = w.sale_id
    where s.sale_date >= (
        select max(sale_date) - interval '5 years' 
        from sales
    )
    group by p.product_id, p.price
)

select 
    price_range,
    corr(price, total_claims) as price_claim_correlation
from product_claims
group by price_range;

--19. Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.

with product_claims as (
	select st.country,s.store_id,st.store_name, count(w.claim_id) as total_claims 
	from warranty as w
	join sales as s
		on s.sale_id = w.sale_id
	join stores st
    	on s.store_id = st.store_id
	group by 1,2,3	
)
select st.country,s.store_id, st.store_name, pc.total_claims, count(w.repair_status = 'Paid Repaired'), count(w.claim_id)*100/pc.total_claims as percentage_claims from warranty as w
join sales as s
		on  w.sale_id = s.sale_id
join stores st
    	on s.store_id = st.store_id
join product_claims as pc
		on pc.store_id = s.store_id
where w.repair_status = 'Paid Repaired'
group by 1,2,3,4, pc.total_claims
order by 6 desc

--20. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.

with running_sales_table as (
	select 
		st.store_id, 
		st.store_name,
		extract(year from s.sale_date) as year,
		extract(month from s.sale_date) as month,
		sum(quantity) as monthly_sales
	from sales as s
	join stores as st
		on s.store_id = st.store_id
	where s.sale_date >= (select max(sale_date) - interval '4 years' from sales)
	group by 1,2,3,4
)

select *,
	sum(monthly_sales) over (
		partition by store_id 
		order by year, month
	) as running_total_sales
from running_sales_table
order by store_name, year, month;
