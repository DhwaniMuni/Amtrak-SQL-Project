--. States with the Highest Percentage Change in Guest Rewards  members form 2021 to 2023
SELECT 
    G1.stateName AS "State Name",
    ROUND(((CAST(G2.countOfMembers AS FLOAT) - G1.countOfMembers) / NULLIF(G1.countOfMembers, 0)) * 100, 2) AS "Percent Increase"
FROM GuestRewards$ G1
JOIN GuestRewards$ G2 ON G1.stateID = G2.stateID
WHERE G1.year = 2021 
  AND G2.year = 2023
ORDER BY "Percent Increase" DESC;


--State With The lowest amount of riders that are a part of the guest rewards program  
SELECT Top 10
    G.stateName AS "State Name",
	ROUND((CAST(AVG(G.countOfMembers) AS FLOAT) / NULLIF(SUM(R.totalRidership) / COUNT(DISTINCT R.year), 0)) * 100, 2) AS "Guest Member To Rider Percentage"
FROM GuestRewards$ G
JOIN (
    SELECT 
        S.stateID,
        R.year,
        SUM(R.ridership) AS totalRidership
    FROM Station$ S
    JOIN Ridership$ R ON S.stationCityCode = R.stationCityCode
    WHERE R.year BETWEEN 2021 AND 2023
    GROUP BY S.stateID, R.year
) R ON G.stateID = R.stateID AND G.year = R.year
WHERE G.year BETWEEN 2021 AND 2023
GROUP BY G.stateID, G.stateName
ORDER BY "Guest Member To Rider Percentage" ASC;


--Top ten states with the highest employee salary to ridership ratio
SELECT Top 10
    E.stateName AS "State Name",
    ROUND((CAST(AVG(E.employeeSalary) AS FLOAT) / NULLIF(SUM(R.totalRidership) / COUNT(DISTINCT R.year), 0)), 2) AS "Salary to Ridership Ratio"
FROM Employee$ E
JOIN (
    SELECT 
        S.stateID,
        R.year,
        SUM(R.ridership) AS totalRidership
    FROM Station$ S
    JOIN Ridership$ R ON S.stationCityCode = R.stationCityCode
    WHERE R.year BETWEEN 2021 AND 2023
    GROUP BY S.stateID, R.year
) R ON E.stateID = R.stateID AND E.year = R.year
WHERE E.year BETWEEN 2021 AND 2023
GROUP BY E.stateID, E.stateName
ORDER BY "Salary to Ridership Ratio" DESC;


-- What is the average number of employees and average salary for states in each region?
SELECT 
    CASE 
        WHEN E.stateID IN ('CA', 'WA', 'OR', 'NV', 'AZ') THEN 'West'
        WHEN E.stateID IN ('TX', 'OK', 'AR', 'LA', 'NM') THEN 'Southwest'
        WHEN E.stateID IN ('IL', 'IN', 'OH', 'MI', 'WI', 'MN', 'IA', 'MO') THEN 'Midwest'
        WHEN E.stateID IN ('NY', 'NJ', 'PA', 'CT', 'MA', 'RI', 'VT', 'NH', 'ME') THEN 'Northeast'
        WHEN E.stateID IN ('FL', 'GA', 'AL', 'MS', 'SC', 'NC', 'TN', 'KY') THEN 'Southeast'
    END AS "Region",
    ROUND(AVG(CAST(E.employeeSalary AS FLOAT)), 2) AS "Average Total Salary",
    ROUND(AVG(CAST(E.employeeSalary AS FLOAT)) / NULLIF(AVG(CAST(E.employeeCount AS FLOAT)), 0), 2) AS "Average Salary Per Employee"
FROM Employee$ E
WHERE E.year BETWEEN 2021 AND 2023
  AND E.stateID IN ('CA', 'WA', 'OR', 'NV', 'AZ', -- West
                    'TX', 'OK', 'AR', 'LA', 'NM', -- Southwest
                    'IL', 'IN', 'OH', 'MI', 'WI', 'MN', 'IA', 'MO', -- Midwest
                    'NY', 'NJ', 'PA', 'CT', 'MA', 'RI', 'VT', 'NH', 'ME', -- Northeast
                    'FL', 'GA', 'AL', 'MS', 'SC', 'NC', 'TN', 'KY') -- Southeast
GROUP BY 
    CASE 
        WHEN E.stateID IN ('CA', 'WA', 'OR', 'NV', 'AZ') THEN 'West'
        WHEN E.stateID IN ('TX', 'OK', 'AR', 'LA', 'NM') THEN 'Southwest'
        WHEN E.stateID IN ('IL', 'IN', 'OH', 'MI', 'WI', 'MN', 'IA', 'MO') THEN 'Midwest'
        WHEN E.stateID IN ('NY', 'NJ', 'PA', 'CT', 'MA', 'RI', 'VT', 'NH', 'ME') THEN 'Northeast'
        WHEN E.stateID IN ('FL', 'GA', 'AL', 'MS', 'SC', 'NC', 'TN', 'KY') THEN 'Southeast'
    END
ORDER BY "Average Total Salary" DESC;