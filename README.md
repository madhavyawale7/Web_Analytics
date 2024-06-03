# Web_Analytics

![CB](https://github.com/madhavyawale7/Web_Analytics/assets/159420665/1107fd73-44d3-48b3-b907-ec9fa623e0ee)

## Table of Contents

- [Introduction](#Introduction)
- [SKILLS](#SKILLS-USED)
- [Project Summary](#SUMMARY)
- [Insight](#Insight)

# Introduction:

This digital case study for the Clique Bait food app offers businesses in-depth insights into user behavior, campaign performance, and product success. By meticulously analyzing event, user, campaign, page, and product data, our study delivers actionable recommendations to refine strategies and drive growth in the competitive digital marketplace.

# SKILLS USED:

| Feature                            | Description                                                                      |
|------------------------------------|----------------------------------------------------------------------------------|
| Data Aggregation                   | Using functions such as COUNT, SUM, AVG, MIN, MAX, and GROUP BY to consolidate data. |
| Data Ordering                      | Sorting data with HAVING and ORDER BY clauses.                                   |
| Data Manipulation                  | Applying JOIN (Left, Inner), UNION, and DISTINCT to manipulate data sets. |
| Window Functions                   | Leveraging window functions like ROW_NUMBER, and RANK for sequential data analysis. |
| Subqueries                         | Isolating specific data subsets for detailed analysis using subqueries.          |
| Logical Functions                  | Utilizing CASE WHEN for data categorization and conditional processing.          |
| Date and Time Functions            | Applying functions like TIMESTAMPDIFF, and DATEDIFF for examining temporal data. |
| Common Table Expressions (CTEs)    | Using CTEs to create temporary result sets for complex queries.                  |
| Data Formatting and Transformation | Employing functions such as CONCAT, SUBSTRING, and REPLACE for data formatting and transformation. |
| Dimensional Aggregation            | Aggregating data across various dimensions with functions like GROUP_CONCAT.     |
| Alias Usage                        | Using aliases to enhance query readability and comprehension.              |




# SUMMARY:

+ [User Analysis](https://github.com/madhavyawale7/Web_Analytics/tree/main/User%20Analysis): Employed SQL functions to explore user engagement, calculating metrics like engagement counts and averages. Techniques included concatenating event sequences, connecting tables, categorizing events with logical functions, and formatting dates for time analysis. Window functions and subqueries were used to identify trends and behaviors at various stages of the user journey, facilitating data-driven decisions.

+ [Product Analysis](https://github.com/madhavyawale7/Web_Analytics/tree/main/Product%20Analysis): Leveraged SQL functions to assess user interactions, product performance, and purchasing trends. Techniques such as aggregation, joining, and ranking identified top-performing and less-viewed products. Insights into conversion funnels and viewing patterns informed product presentation and marketing strategies.

+ [Event Analysis](https://github.com/madhavyawale7/Web_Analytics/tree/main/Event%20Analysis): Applied SQL techniques to dissect user engagement dynamics, identifying event sequences and behavior patterns. Aggregation, grouping, and logical operations were utilized to uncover event distributions and trends. Subqueries and temporal analysis provided insights into the timing and sequence of interactions, enhancing strategy optimization.

+ [Campaign Analysis](https://github.com/madhavyawale7/Web_Analytics/tree/main/Campaign%20Analysis): Employed SQL queries to evaluate marketing campaign effectiveness, analyzing engagement metrics, conversion rates, and product distribution. The analysis provided actionable insights into campaign performance and user behavior, enabling data-driven marketing strategy optimization and business growth.

+ [Page Analysis](https://github.com/madhavyawale7/Web_Analytics/tree/main/Page%20Analysis): Utilized SQL queries to gain insights into user engagement, event sequences, and conversion rates on website pages. By counting, grouping, and averaging data, engagement patterns, entry points, and bounce rates were revealed. This analysis informs content optimization and enhances the user experience.

  # Insight:

#### Page Analysis
1. **Highest and Lowest Visited Pages:**
   - The "All Products" page had the highest total visitors (4752) and unique visitors (3174), indicating it is a central hub for user navigation.
   - The "Home Page" had fewer total visitors (1782) but matched its unique visitor count, suggesting it is mainly visited by new users.

2. **Conversion Pages:**
   - The "Checkout" page had a total visitor count of 2103, all of whom were unique visitors, highlighting its role in the final stages of the purchasing process.
   - The "Confirmation" page, with 1777 total and unique visitors, shows a high rate of purchase completion.

#### Product Analysis
1. **Popular Products:**
   - "Lobster," "Crab," and "Oyster" were the most visited product pages, each attracting over 2,500 total visitors and around 1,550 unique visitors, indicating high user interest.
   - "Black Truffle" had the lowest visitor count among the listed products but still garnered substantial interest.

2. **User Preferences:**
   - The visitor distribution across various products suggests a diverse range of interests, with no single product overwhelmingly dominating.

#### User Analysis
1. **Unique Visitors and Cookies:**
   - Unique visitor counts and unique cookie counts align closely, showing effective user tracking.
   - High unique visitor counts on the "Checkout" and "Confirmation" pages indicate successful conversion rates.

2. **Repeat Visits:**
   - The disparity between total and unique visitors on product pages suggests repeat visits, with users likely comparing multiple products before making a decision.

#### Campaign Analysis
1. **Campaign Performance:**
   - While specific campaign performance metrics were not detailed, the structure allows for tracking and comparing the effectiveness of various campaigns based on traffic and conversions.
   - Future analysis can focus on which campaigns drive the most engaged traffic and lead to higher conversion rates.

#### Event Analysis
1. **Event Tracking:**
   - Tracking different event types and names provides insights into user interactions and engagement levels.
   - Detailed event analysis can help in understanding user actions, such as product clicks, add-to-cart events, and checkout completions.

2. **User Interaction Patterns:**
   - Analysis of events can reveal user navigation patterns and bottlenecks in the purchasing process, helping to optimize the user experience.


