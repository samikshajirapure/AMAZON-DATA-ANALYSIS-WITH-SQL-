-- project: Amazon data analysis with sql
-- retriving the entired dataset
SELECT * FROM projectcapstone.amazon;

-- Query to check null values
SELECT 
    SUM(CASE WHEN `Invoice ID` IS NULL THEN 1 ELSE 0 END) AS Invoice_ID_Null_Count,
    SUM(CASE WHEN Branch IS NULL THEN 1 ELSE 0 END) AS Branch_Null_Count,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_Null_Count,
    SUM(CASE WHEN `Customer type` IS NULL THEN 1 ELSE 0 END) AS Customer_Type_Null_Count,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Null_Count,
    SUM(CASE WHEN `Product line` IS NULL THEN 1 ELSE 0 END) AS Product_Line_Null_Count,
    SUM(CASE WHEN `Unit price` IS NULL THEN 1 ELSE 0 END) AS Unit_Price_Null_Count,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_Null_Count,
    SUM(CASE WHEN `Tax 5%` IS NULL THEN 1 ELSE 0 END) AS Tax_Null_Count,
    SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS Total_Null_Count,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_Null_Count,
    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS Time_Null_Count,
    SUM(CASE WHEN Payment IS NULL THEN 1 ELSE 0 END) AS Payment_Null_Count,
    SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS Cogs_Null_Count,
    SUM(CASE WHEN `gross margin percentage` IS NULL THEN 1 ELSE 0 END) AS Gross_Margin_Percentage_Null_Count,
    SUM(CASE WHEN `gross income` IS NULL THEN 1 ELSE 0 END) AS Gross_Income_Null_Count,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS Rating_Null_Count
FROM projectcapstone.amazon;

-- ADD NEW THREE COLUMN: TIME OF DAY, DAY NAME AND MONTH NAME
-- 1.ADD COLUMN FOR TIME OF DAY

SET SQL_SAFE_UPDATES = 0; -- Disable safe update mode

UPDATE projectcapstone.amazon
SET Time_of_day = 
    CASE
        WHEN HOUR(TIME(CONCAT(Date, ' ', Time))) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(TIME(CONCAT(Date, ' ', Time))) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(TIME(CONCAT(Date, ' ', Time))) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END;

SET SQL_SAFE_UPDATES = 1; -- Re-enable safe update mode


-- 2. ADD A COLUMN FOR DAY OF WEEK

SET SQL_SAFE_UPDATES = 0;

UPDATE projectcapstone.amazon
SET Day_of_week = DAYNAME(Date);

SET SQL_SAFE_UPDATES = 1;

-- 3. ADD A COLUMN FOR MONTH OF YEAR

SET SQL_SAFE_UPDATES = 0;

UPDATE projectcapstone.amazon
SET Month_of_year = MONTHNAME(Date);

SET SQL_SAFE_UPDATES = 1;

-- CHECK THREE COLUMN ADD OR NOT
DESCRIBE projectcapstone.amazon;
SELECT * FROM projectcapstone.amazon;

SELECT
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon;
  
-- ANALYSIS LIST: PRODUCT ANALYSIS,SALES ANALYSIS, CUSTOMER ANALYSIS
-- 1.PRODUCT ANAYSIS 
-- Understanding product line performance and identifying the best and underperforming product lines
-- A.Best-performing product lines (by total revenue)

SELECT 
    City, 
    `Product line` , 
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon
GROUP BY 
    City, `Product line`
ORDER BY 
    City, Total_Revenue DESC;

-- B.the product line that need to be improvement

SELECT 
    City, 
    `Product line`  , 
    AVG(Rating) AS Average_Rating
FROM 
    projectcapstone.amazon
GROUP BY 
    City, `Product line`
ORDER BY 
    City, Average_Rating DESC;

-- C.sales count by product line

SELECT 
    City, 
    `Product line` , 
    COUNT(*) AS Sales_Count
FROM 
    projectcapstone.amazon
GROUP BY 
    City, `Product line`
ORDER BY 
    City, Sales_Count DESC;
    
  -- Comment:Product Analysis helps determine the most and least popular product lines for each city, along with their performance ratings.

    
-- 2.SALES ANALYSIS
-- to analyze sales trades and measure the effectiveness of sales stratergies
-- A. monthly sales trades by city
    SELECT 
    City, 
    Month_of_year, 
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon
GROUP BY 
    City, Month_of_year
ORDER BY 
    City, FIELD(Month_of_year, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
    
-- B.Daily Sales Trends by City  
    SELECT 
    City, 
    Day_of_week, 
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon
GROUP BY 
    City, Day_of_week
ORDER BY 
    City, FIELD(Day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- C.Time of Day Sales trends by City
   SELECT 
    City, 
    Time_of_day, 
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon
GROUP BY 
    City, Time_of_day
ORDER BY 
    City, Total_Revenue DESC;
    
--  Comment:Sales Analysis identifies sales trends by month, day, and time of day, helping evaluate the effectiveness of current strategies.

-- 3.CUSTOMER ANALYSIS
-- To analyze customer segments, purchase trends, and profitability:
-- A.Revenue Contribution by Customer Type
    
    SELECT 
    City, 
    `Customer type`, 
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon
GROUP BY 
    City, `Customer type`
ORDER BY 
    City, Total_Revenue DESC;
    
-- B.Purchase Trends by Gender

SELECT 
    City, 
    Gender, 
    COUNT(*) AS Purchase_Count, 
    SUM(Total) AS Total_Revenue
FROM 
    projectcapstone.amazon
GROUP BY 
    City, Gender
ORDER BY 
    City, Total_Revenue DESC;
    
-- C.Profitability by Customer Type

SELECT 
    City, 
    `Customer type`, 
    SUM(`gross income`) AS Total_Profit
FROM 
    projectcapstone.amazon
GROUP BY 
    City, `Customer type`
ORDER BY 
    City, Total_Profit DESC;
    
-- Comment: Customer Analysis focuses on purchase behavior by customer type and gender, along with profitability.

-- BUSINESS  QUESTION TO ANSWER:

-- Question 1: What is the count of distinct cities in the dataset?
-- SQL Query:
	  SELECT COUNT(DISTINCT City) AS Distinct_Cities_Count
      FROM projectcapstone.amazon;
-- Comments:The dataset contains three unique cities: Yangon, Mandalay, and Naypyitaw.
-- Recommendation:If expanding business, consider analyzing city-specific performance.

-- Question 2: For each branch, what is the corresponding city?
-- SQL Query:
      SELECT DISTINCT Branch, City
      FROM projectcapstone.amazon;
-- Comments: contains branch and city 
          -- Branch A → Yangon
	      -- Branch B → Mandalay
          -- Branch C → Naypyitaw
-- Recommendations: Use this info to plan city-specific promotions
 

-- Question 3: What is the count of distinct product lines in the dataset?
-- SQL Query:
     SELECT COUNT(DISTINCT `Product line`) AS Distinct_Product_Lines_Count
     FROM projectcapstone.amazon;
-- Comments:The dataset has six product lines: 1. Health and Beauty/2. Electronic Accessories/3. Home and Lifestyle/4. Sports and Travel
-- 5. Food and Beverages/6.Fashion Accessories
-- Recommendations: Consider adding more product lines based on demand trends.


-- Question 4: Which payment method occurs most frequently?
-- SQL Query:
      SELECT Payment, COUNT(*) AS Frequency
      FROM projectcapstone.amazon
      GROUP BY Payment
      ORDER BY Frequency DESC;
-- Comments:E-wallet is the most frequently used payment method.
-- Recommendations:Offer E-wallet cashback rewards but also promote Cash & Credit Card payments. 


-- Question 5:  Which product line has the highest sales?
-- SQL Query:
	 SELECT 
	`Product line` ,
     SUM(Quantity) AS Total_Sales
     FROM projectcapstone.amazon
     GROUP BY 
    `Product line` 
     ORDER BY Total_Sales DESC;
-- Comments: Electronic accessories sell the most.
-- Recommendations:  Stock more electronic accessories, offer bundle deals, and promote it more.
   
   
-- Question 6:How much revenue is generated each month?
-- SQL Query:
     SELECT Month_of_year, SUM(Total) AS Monthly_Revenue
     FROM projectcapstone.amazon
     GROUP BY Month_of_year
     ORDER BY FIELD(Month_of_year, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
-- Comments: Highest revenue months: January and March , Lowest revenue month: February
-- Recommandation: Offer discounts in February to boost sales.Analyze why March performs well and replicate strategies.


-- Question 7:In which month did the cost of goods sold reach its peak?
-- SQL Query:
      SELECT Month_of_year, SUM(cogs) AS Total_COGS
      FROM projectcapstone.amazon
      GROUP BY Month_of_year
      ORDER BY Total_COGS DESC
      LIMIT 1;
-- Comments:The month with the highest COGS is January.
-- Recommendation: Investigate whether high COGS is due to increased sales or rising supplier costs.
 

-- Question 8: Which product line generated the highest revenue?
-- SQL Query:
	 SELECT `Product line`, SUM(Total) AS Total_Revenue
     FROM projectcapstone.amazon
	 GROUP BY `Product line`
     ORDER BY Total_Revenue DESC
     LIMIT 1;
-- Comments:Comment: Food and Beverages generates the highest revenue.
-- Recommendation: Expand this category further, possibly adding premium or organic options.

-- Question9:In which city was the highest revenue recorded?
-- SQL Query:
     SELECT City, SUM(Total) AS Total_Revenue
     FROM projectcapstone.amazon
     GROUP BY City
     ORDER BY Total_Revenue DESC
     LIMIT 1;
-- Comments: Naypyitaw has the highest total revenue.
-- Recommendation: Continue investing in marketing and customer retention efforts in Naypyitaw.


-- Question10: Which product line incurred the highest Value Added Tax?
-- SQL Query:
     SELECT `Product line` , SUM(`Tax 5%`) AS Total_Tax
     FROM projectcapstone.amazon
     GROUP BY `Product line`
     ORDER BY Total_Tax DESC
	 LIMIT 1;
-- Comments:Food and Beverages pays the highest VAT.
-- Recommendation: Consider price adjustments or promotions to balance value added tax expenses.


-- Question11: For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
-- SQL Query:
      SELECT 
      `Product line`, 
	  SUM(Total) AS Total_Revenue,
      CASE 
	  WHEN SUM(Total) > (SELECT AVG(Total) FROM projectcapstone.amazon) THEN 'Good'
	  ELSE 'Bad'
	 END AS Performance
     FROM projectcapstone.amazon
	GROUP BY `Product line`;
-- Comments :all product line are above average
-- Recommendation: Improve underperforming product lines through targeted marketing.

    
-- Question12: Identify the branch that exceeded the average number of products sold.
-- SQLQuery:
      SELECT 
      Branch, 
      SUM(Quantity) AS Total_Products_Sold
      FROM projectcapstone.amazon
      GROUP BY Branch
      HAVING Total_Products_Sold > (SELECT AVG(Quantity) FROM projectcapstone.amazon);
-- Comments: Branches A (Yangon) and  C (Naypyitaw)  exceed average product sales.
-- Recommendation:Expand high-performing branches.

-- Question13: Which product line is most frequently associated with each gender?
-- SQL Query:
      SELECT 
      Gender, 
     `Product line`, 
      COUNT(*) AS Frequency
      FROM projectcapstone.amazon
	  GROUP BY Gender, `Product line`
      ORDER BY Gender, Frequency DESC;
-- Comments :Females prefer: Fashion Accessories & Health and Beauty/Males prefer: Sports and Travel & Electronic Accessories
-- Recommendation: Offer gender-specific promotions based on preferences.


-- Question14: Calculate the average rating for each product line.
-- SQL Query:
      SELECT 
     `Product line`, 
      AVG(Rating) AS Average_Rating
      FROM projectcapstone.amazon
      GROUP BY `Product line`
      ORDER BY Average_Rating DESC;
-- Comments:Highest-rated: Fashion Accessories,Lowest-rated: Electronic Accessories
-- Recommendation:Investigate negative reviews for low-rated categories.Improve customer experience for Electronics.


-- Question15:Count the sales occurrences for each time of day on every weekday.
-- SQL Query:
      SELECT 
	  Day_of_week, 
      Time_of_day, 
      COUNT(*) AS Sales_Count
	  FROM projectcapstone.amazon
      GROUP BY Day_of_week, Time_of_day
      ORDER BY Day_of_week, Time_of_day;
-- Comments:Afternoon and Evening have the highest sales.
-- Recommendation: Focus marketing efforts on peak hours to maximize revenue.

 
-- Question16:Identify the customer type contributing the highest revenue.
-- SQL Query:
      SELECT 
     `Customer type`, 
      SUM(Total) AS Total_Revenue
      FROM projectcapstone.amazon
	  GROUP BY `Customer type`
      ORDER BY Total_Revenue DESC
      LIMIT 1;
-- Comments:Members contribute the most revenue.
-- Recommendation: Encourage more customers to sign up as Members.


-- Question17:Determine the city with the highest VAT percentage.
-- SQL Query:
      SELECT 
	  City, 
      AVG(`gross margin percentage`) AS Average_VAT_Percentage
      FROM projectcapstone.amazon
      GROUP BY City
      ORDER BY Average_VAT_Percentage DESC
      LIMIT 1;
-- Comments:  yangon pay the highest total value added tax.
-- Recommendation: Offer VAT-inclusive discounts to improve loyalty.
   

-- Question18:Identify the customer type with the highest VAT payments.
-- SQL Query:
       SELECT 
      `Customer type`, 
       SUM(`Tax 5%`) AS Total_VAT
       FROM projectcapstone.amazon
       GROUP BY `Customer type`
       ORDER BY Total_VAT DESC
       LIMIT 1;
-- Comments: Members pay the highest total VAT.
-- Recommendation: Offer VAT-inclusive discounts to improve loyalty.


--  Question19.What is the count of distinct customer types in the dataset?
-- SQL Query:
       SELECT COUNT(DISTINCT `Customer type`) AS Distinct_Customer_Types
       FROM projectcapstone.amazon;
-- Comment: The dataset has two customer types: Member and Normal
-- Recommendation: Focus on converting Normal customers into Members.


-- Question20:What is the count of distinct payment methods in the dataset?
-- SQL Query:
       SELECT COUNT(DISTINCT Payment) AS Distinct_Payment_Methods
       FROM projectcapstone.amazon;
-- Comment: Three payment methods exist: Cash,Credit Card,E-wallet
-- Recommendation: Cont inue promoting E-wallet benefits but also incentivize other payment methods.

 
-- Question21:Which customer type occurs most frequently?
-- SQL Query:
        SELECT 
	   `Customer type`, 
		COUNT(*) AS Frequency
        FROM projectcapstone.amazon
        GROUP BY `Customer type`
        ORDER BY Frequency DESC
        LIMIT 1;
-- Comments :Membercustomers are more frequent.
-- Recommendation: Increase conversion strategies to make them Members.

        
-- Question22:Identify the customer type with the highest purchase frequency.
-- SQL Query:
       SELECT 
       `Customer type`, 
	   COUNT(*) AS Purchase_Frequency
       FROM projectcapstone.amazon
       GROUP BY `Customer type`
       ORDER BY Purchase_Frequency DESC
       LIMIT 1;
  -- Comments:  Member customers make more frequent purchases.
  -- Recommendation: Implement loyalty programs to retain these customers.
    
  

-- Question23: Determine the predominant gender among customers.
-- SQL Query:
      SELECT 
      Gender, 
      COUNT(*) AS Frequency
      FROM projectcapstone.amazon
      GROUP BY Gender
      ORDER BY Frequency DESC
      LIMIT 1;
-- Comments :Females make more purchases than males.
-- Recommendation: Target female shoppers with personalized offers.


-- Question24:Examine the distribution of genders within each branch.
-- SQL Query:
       SELECT 
       Branch, 
       Gender, 
       COUNT(*) AS Gender_Distribution
       FROM projectcapstone.amazon
       GROUP BY Branch, Gender
       ORDER BY Branch, Gender_Distribution DESC;
-- Comments:Branch A (Yangon) → More Female Customers
	     -- Branch B (Mandalay) → More Male Customers
		 -- Branch C (Naypyitaw) → Even Distribution
-- Recommendation:Customize marketing based on branch-specific demographics.


-- Question25:Identify the time of day when customers provide the most ratings.
-- SQL Query:
       SELECT 
       Time_of_day, 
       COUNT(Rating) AS Rating_Count
       FROM projectcapstone.amazon
       GROUP BY Time_of_day
       ORDER BY Rating_Count DESC
       LIMIT 1;
-- Comments:Afternoon has the most customer ratings.
-- Recommendation: Run promotions during high-rating hours to increase customer engagement.


-- Question26:Determine the time of day with the highest customer ratings for each branch.
-- SQL Query:
      SELECT 
      Branch, 
      Time_of_day, 
      AVG(Rating) AS Average_Rating
      FROM projectcapstone.amazon
      GROUP BY Branch, Time_of_day
      ORDER BY Branch, Average_Rating DESC;
-- Comments or Recommendations:
-- Best ratings occur in the Afternoon.Branch A has the highest evening ratings.
-- Recommendation: Encourage customer reviews during peak Afternoon hours.


-- Question27:Identify the day of the week with the highest average ratings.
-- SQL Query:
       SELECT 
       Day_of_week, 
       AVG(Rating) AS Average_Rating
       FROM projectcapstone.amazon
       GROUP BY Day_of_week
       ORDER BY Average_Rating DESC
       LIMIT 1;
-- Comments:monday has the highest average rating.
-- Recommendation: Use monday to launch new promotions or campaigns.


-- Question28:Determine the day of the week with the highest average ratings for each branch.
-- SQL Query:
       SELECT 
    Branch, Day_of_week, AVG(Rating) AS Average_Rating
    FROM
    projectcapstone.amazon
    GROUP BY Branch , Day_of_week
    ORDER BY Branch , Average_Rating DESC;
-- Yangon: Best ratings on Sunday , Mandalay: Best ratings on Friday , Naypyitaw: Best ratings on Saturday
-- Recommendation: Adjust marketing and promotions according to each branch's peak days.



