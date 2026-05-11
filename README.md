________________________________________
🌍 Global Air Quality Analysis Pipeline: From Raw Sensors to SQL Insights 
📌 Project overview
Air pollution is a major global health challenge. In this project, an end to end data pipeline was built to process more than 18,000 hourly historical sensor readings from 50 global cities.
The idea is not just to plot a few charts, but to design a small “analytics system”: ingest hourly sensor archives (CSV), with an architecture ready for live API ingestion, clean and transform them with Python, load them into a SQL data warehouse, and then run advanced queries to spot patterns and anomalies.
Key business questions
1.	Do traffic related pollutants like NO₂ really drive the biggest urban pollution spikes?
2.	How often do major cities break WHO safety limits?
3.	Can sudden industrial events or fires be detected automatically using SQL based anomaly rules?
________________________________________
## Tech stack & architecture
The project follows a realistic data engineering flow: from CSV files, into Python for transformation, then into SQL for long term storage and analysis.
Component	Tool	Role in the pipeline
ETL & scripting	Python (Pandas)	Reads raw CSVs, parses datetimes, creates rush hour flags, and cleans noisy records.
Analytical store  SQL (SQLite for dev; Postgres-compatible schema for production)	Stores structured data and powers joins, aggregations, and window function queries.
EDA & charts	Matplotlib / Seaborn	Builds heatmaps, boxplots, and line charts to understand trends and distributions.

________________________________________
## Key insights from Python EDA
Before loading data into SQL, exploratory analysis in Python highlighted several important patterns.
1. Rush hour pollution is real
When NO₂ levels are plotted by hour of day, the curve forms two clear peaks: one around 8 AM and another around 6 PM, matching morning and evening commute times. This strongly links traffic to daily air quality stress.
 
2. Correlation heatmap: what drives AQI
A correlation heatmap between pollutants, weather variables, and AQI shows that PM2.5 and NO₂ have the strongest positive relationships with AQI, while factors like wind speed and humidity have much weaker correlations. This indicates that, in this dataset, local emissions are more important drivers of air quality than meteorological dispersion.
 
3. Weekly air quality patterns
Boxplots of AQI by day of week reveal how pollution behaves over the typical workweek versus the weekend. In this data, weekday and weekend distributions are fairly similar, suggesting that background pollution and continuous sources (not just weekday traffic) play a significant role.
 
4. A temperature–ozone surprise
Environmental theory suggests that hotter days should boost ozone (O₃), but this dataset showed almost no relationship between temperature and O₃. For these cities and this time window, local emission sources appear to matter more than heat driven chemistry.
 
________________________________________
## Advanced SQL analytics
After loading the cleaned data into SQLite/PostgreSQL, SQL was used for finer grained, time series analysis with window functions and CTEs.


## Production roadmap

| Layer | Current | Production upgrade |
|-------|---------|-------------------|
| Ingestion | Static CSV | OpenAQ API polled hourly via Airflow |
| Storage | SQLite file | PostgreSQL → Redshift/BigQuery |
| Orchestration | Manual notebook run | Apache Airflow DAG with retries |
| Data quality | In-notebook assertions | Great Expectations suite |
| Serving | SQL queries | Materialized views + Power BI refresh |
| Monitoring | None | pipeline_runs table + email alerts |

