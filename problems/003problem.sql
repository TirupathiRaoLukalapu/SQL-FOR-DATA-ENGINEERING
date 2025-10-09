/*Problem: Crypto Market Algorithm Report

Question (summarized):
You have two tables:

coins — with columns including code and algorithm

transactions — with columns including coin_code, dt (date/time), and volume

For each algorithm, compute the total transaction volume in each quarter (Q1, Q2, Q3, Q4) of the year 2020. If an algorithm had no transactions in a quarter, it should show zero (or null) for that quarter.

Return:

algorithm

transactions_Q1, transactions_Q2, transactions_Q3, transactions_Q4 (each being sum of volume for that quarter, precise to 6 decimal places)

Sort by algorithm name ascending

Approach / Explanation

Here’s how you break it down:

Filter only year 2020 transactions
Focus on transactions where YEAR(dt) = 2020.

Join coins and transactions
To know which algorithm each transaction belongs to.

Aggregate volumes by algorithm and quarter
Use SUM(volume) grouping by algorithm + quarter number.

Pivot quarters into columns
From rows like (algorithm, quarter, sum_volume) into columns Q1, Q2, etc.

Ensure algorithms with no transactions in a quarter still appear
Use LEFT JOINs or pivot functions so that missing quarters don’t eliminate the algorithm.

Format numeric precision
Depending on SQL dialect, use ROUND(..., 6) or formatting functions.
*/

SELECT
  c.algorithm,
  SUM(CASE WHEN QUARTER(t.dt) = 1 THEN t.volume ELSE 0 END) AS transactions_Q1,
  SUM(CASE WHEN QUARTER(t.dt) = 2 THEN t.volume ELSE 0 END) AS transactions_Q2,
  SUM(CASE WHEN QUARTER(t.dt) = 3 THEN t.volume ELSE 0 END) AS transactions_Q3,
  SUM(CASE WHEN QUARTER(t.dt) = 4 THEN t.volume ELSE 0 END) AS transactions_Q4
FROM coins c
JOIN transactions t
  ON c.code = t.coin_code
WHERE YEAR(t.dt) = 2020
GROUP BY c.algorithm
ORDER BY c.algorithm;
