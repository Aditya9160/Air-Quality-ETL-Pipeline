select * from pollution_data


---How many hours did each city spend in hazardous conditions?
select city,
	count(case when aqi<=50 then 1 end) as good_hours,
	count(case when aqi>50 and aqi <=100 then 1 end) as moderate_hours,
	count(case when aqi>150 then 1 end) as unhealthy_hours
from pollution_data
group by city
order by unhealthy_hours desc
limit 10;


---What was the single worst date for each city?
with RankedPollution as (
	select city,
			timestamp,
		max(aqi) as peak_aqi,
		rank() over (partition by city order by max(aqi) desc) as rank_num
	from pollution_data
	group by city,timestamp
)
select city,
	timestamp,
	peak_aqi
from RankedPollution
where rank_num=1
order by peak_aqi desc;
---When did pollution DOUBLE in a single hour?
WITH LaggedData AS (
    SELECT 
        city,
        timestamp,
		extract(hour from timestamp) as current_hour,
        aqi as current_aqi,
        LAG(aqi) OVER (PARTITION BY city ORDER BY timestamp) as prev_hour_aqi,
		lag(extract(hour from timestamp)) over (partition by city order by timestamp) as prev_hour
    FROM pollution_data
)
SELECT 
    city,
    timestamp,
	prev_hour,
	prev_hour_aqi,
	current_hour,
	current_aqi,
    (current_aqi - prev_hour_aqi) as jump
FROM LaggedData
WHERE current_aqi >= (prev_hour_aqi * 2) -- Filter for 2x jumps
ORDER BY jump DESC
LIMIT 10;

---Smooth out the sensor noise for London trends.
SELECT 
    timestamp,
    city,
    aqi as actual_aqi,
    round(AVG(aqi) OVER (
        PARTITION BY city 
        ORDER BY timestamp 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ),0) as moving_avg_3hr
FROM pollution_data
WHERE city = 'London'
ORDER BY timestamp
LIMIT 20;


