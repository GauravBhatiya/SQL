# Bank Marketing Campaign Analysis

## Problem Statement
The goal of this analysis is to understand factors influencing customer behavior and the effectiveness of a bank's marketing campaign in driving subscriptions to term deposits (`y`). By analyzing the dataset, we aim to identify key characteristics of customers who are more likely to subscribe and determine the impact of various campaign strategies. The insights will help the bank optimize future marketing efforts and increase subscription rates.

## Dataset
The dataset contains details about the bank's marketing campaign, including customer demographics, financial information, and campaign-related attributes. The primary focus is to analyze customer attributes, campaign performance, and temporal trends in subscription rates.


## Objectives
- Identify customer profiles with the highest likelihood of subscribing to term deposits.
- Evaluate the impact of campaign features like call duration, previous contacts, and days since last contact on subscription rates.
- Provide actionable insights and recommendations to improve targeting and campaign efficiency.

## Situation
The bank's marketing campaign aims to increase subscriptions to term deposits. The challenge is to identify key factors that lead to higher subscription rates and understand how customer demographics, campaign features, and temporal patterns influence success.

## Task
We need to analyze customer segmentation, campaign performance, and various factors affecting subscription outcomes. The specific tasks include identifying effective customer profiles, evaluating campaign strategies, and understanding correlations between customer attributes and subscription success.

## Action
We performed an in-depth analysis using SQL-based queries to answer key questions about customer behavior, campaign performance, and temporal insights. The questions were grouped into the following categories:

### 1. Customer Demographics
- Distribution of customers by job type, marital status, and education level.
- Average balance by demographic categories.
- Housing and personal loans impact on customer balances.
- Analysis of customer balances, negative balances, and subscription outcomes.


### 2. Campaign Performance
- Calculating the overall success rate of the marketing campaign
- Impact of campaign contacts and call duration on subscription rates.
- Success rates based on the number of previous contacts and days since last contact.
- On which days were calls most effective in converting subscriptions
  

### 3. Actionable Insights
- Success rates by month and day of the week.
- Identifying optimal call duration ranges for higher subscription success.
- Exploring the effect of customer default status on subscription likelihood.
- Identify Month-over-Month Growth in Campaign Success

## Results

### 1️⃣ Customer & Financial Analysis
- **Job & Income Impact**:
  - Customers in **Management & Technician roles** have the highest subscription rates.
  - Housemaids and unemployed individuals have the lowest conversion rates.

- **Balance vs. Subscription**:
  - Customers with **higher balances tend to subscribe more**, but correlation is weak.
  - **Negative balance customers rarely subscribe**.

- **Loan Status Influence**:
  - Customers with a **housing loan have an 8% higher chance of subscribing**.
  - Those with **both housing & personal loans have the lowest success rates**.


### 2️⃣ Marketing Campaign Performance
- **Call Duration vs. Subscription**:
  - **Calls lasting 300+ seconds show a 28% success rate**, while calls under 100 seconds rarely convert.
  
- **Effect of Previous Contact**:
  - Customers contacted **in the last 10 days have a 40% conversion rate**.
  - Clients with **no prior contact have a much lower success rate (9.16%)**.

- **Communication Channel**:
  - **Cellular contact is significantly more effective** than landline calls.

- **Best Performing Months**:
  - **March and September have the highest subscription rates (~50%)**.
  - **May is the worst-performing month (~6%)**.

- **Optimal Contact Days**:
  - **The 1st, 10th, and 30th of each month** have the highest success rates.


## Recommendations

### 1. Focus on Mid-Aged Customers
- Target mid-aged individuals (29–49 years), as they are most likely to subscribe. Develop personalized campaigns that cater to their needs.

### 2. Leverage Long Call Durations
- Ensure that call durations are longer (300+ seconds) to increase the likelihood of subscriptions. Train agents to engage customers more thoroughly during calls.

### 3. Engage Recent Contacts
- Prioritize recent contacts, especially those with `pdays` of 1-10. Follow up promptly after initial engagement to maximize conversion rates.

### 4. Increase Engagement with Non-Default Customers
- Focus marketing efforts on customers without a default status, as they show a higher subscription rate (11.80% vs. 6.38% for default customers).

### 5. Optimize Campaign Timing
- Run campaigns in March, December, and September, as these months show the highest subscription rates.
- Focus outreach on the 1st, 10th, and 30th of each month to align with peak success days.

### 6. Target Customers with Housing or Personal Loans
- Customers with loans tend to have higher subscription rates, so consider offering tailored products or benefits for these groups.

### 7. Understand the Impact of Occupation
- Occupation influences subscription rates significantly.
- Focus on management and technician roles for higher conversion rates, while adjusting strategies for lower-performing occupations like housemaids.

## Conclusion
This analysis provides actionable insights that can help the bank optimize its marketing strategies. By focusing on key customer demographics, campaign features, and temporal patterns, the bank can improve its subscription rates for term deposits. Implementing the recommended strategies will lead to more targeted campaigns, better resource allocation, and ultimately, higher conversion rates.

