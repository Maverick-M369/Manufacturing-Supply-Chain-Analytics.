SELECT COUNT(*) FROM public."R_manufacturing";

1. Overall Production Efficiency (%)
SELECT 
    ROUND(AVG(production_efficiency)::Numeric, 2) AS avg_production_efficiency_pct
FROM public."r_manufacturing";

SELECT
    ROUND(
        (SUM(units_produced) * 100.0) / NULLIF(SUM(planned_units), 0),
        2
    ) AS production_efficiency_percent
FROM public.r_manufacturing;


2. Plant-wise Production Efficiency
SELECT 
    Plant_ID,
    ROUND(AVG(Production_Efficiency)::Numeric, 2) AS plant_efficiency_pct
FROM public."r_manufacturing"
GROUP BY Plant_ID
ORDER BY plant_efficiency_pct DESC;


3. Planned vs Actual Production
SELECT
    Plant_ID,
    SUM(Planned_Units) AS total_planned_units,
    SUM(Units_Produced) AS total_actual_units,
    SUM(Planned_Units - Units_Produced) AS production_gap
FROM public."r_manufacturing"
GROUP BY Plant_ID;

4. Shift-wise Production Output
SELECT
    Shift,
    SUM(Units_Produced) AS units_produced
FROM public."r_manufacturing"
GROUP BY Shift
ORDER BY units_produced DESC;


5. Overall Defect Rate
SELECT
    ROUND(AVG(Defect_Rate)::Numeric, 2) AS avg_defect_rate_pct
FROM public."r_manufacturing"


6. Plant-wise Defect Rate
SELECT
    Plant_ID,
    ROUND(AVG(Defect_Rate)::Numeric, 2) AS avg_defect_rate_pct
FROM public."r_manufacturing"
GROUP BY Plant_ID
ORDER BY avg_defect_rate_pct DESC;


7. Defect Distribution by Type
SELECT
    Defect_Type,
    SUM(Defective_Units) AS total_defective_units
FROM public."r_manufacturing"
WHERE Defect_Type <> 'No Defect'
GROUP BY Defect_Type
ORDER BY total_defective_units DESC;


8. Shift-wise Quality Impact
SELECT
    Shift,
    ROUND(AVG(Defect_Rate)::Numeric, 2) AS avg_defect_rate_pct
FROM public."r_manufacturing"
GROUP BY Shift;


9. Total Downtime
SELECT
    SUM(Downtime_Minutes) AS total_downtime_minutes,
    ROUND(SUM(Downtime_Minutes)/60.0, 2) AS total_downtime_hours
FROM public."r_manufacturing";

10. Downtime by Reason
SELECT
    Downtime_Reason,
    SUM(Downtime_Minutes) AS downtime_minutes
FROM public."r_manufacturing"
GROUP BY Downtime_Reason
ORDER BY downtime_minutes DESC;

11. Downtime Impact by Plant
SELECT
    Plant_ID,
    ROUND(AVG(Downtime_Minutes)::Numeric, 2) AS avg_downtime_minutes
FROM public."r_manufacturing"
GROUP BY Plant_ID
ORDER BY avg_downtime_minutes DESC;


12. Supplier Lead Time Performance
SELECT
    Supplier_ID,
    ROUND(AVG(Lead_Time_Days)::Numeric, 2) AS avg_lead_time_days
FROM public."r_manufacturing"
GROUP BY Supplier_ID
ORDER BY avg_lead_time_days DESC;

13. Raw Material Lead Time Risk
SELECT
    Raw_Material,
    ROUND(AVG(Lead_Time_Days), 2) AS avg_lead_time_days
FROM public."r_manufacturing"
GROUP BY Raw_Material
ORDER BY avg_lead_time_days DESC;

14. Delivery Delay Analysis
SELECT
    COUNT(*) AS delayed_shipments
FROM public."r_manufacturing"
WHERE Delivery_Delay_Days > 0;

15. Average Delivery Delay Days
SELECT
    ROUND(AVG(Delivery_Delay_Days), 2) AS avg_delivery_delay_days
FROM public."r_manufacturing"
WHERE Delivery_Delay_Days > 0;

16. Inventory Risk Days
SELECT
    COUNT(*) AS inventory_risk_days
FROM public."r_manufacturing"
WHERE Inventory_Status = 'Below Reorder';


17. Plant-wise Inventory Risk
SELECT
    Plant_ID,
    COUNT(*) AS risk_days
FROM public."r_manufacturing"
WHERE Inventory_Status = 'Below Reorder'
GROUP BY Plant_ID
ORDER BY risk_days DESC;


18. Inventory vs Reorder Level Gap
SELECT
    Plant_ID,
    ROUND(AVG(Inventory_Level - Reorder_Level), 2) AS avg_inventory_gap
FROM public."r_manufacturing"
GROUP BY Plant_ID;

19. Average Production Cost per Unit
SELECT
    ROUND(AVG(Production_Cost_Per_Unit)::Numeric, 2) AS avg_cost_per_unit
FROM public."r_manufacturing";

20. Plant-wise Cost Analysis
SELECT
    Plant_ID,
    ROUND(AVG(Production_Cost_Per_Unit)::Numeric, 2) AS avg_cost_per_unit
FROM public."r_manufacturing"
GROUP BY Plant_ID
ORDER BY avg_cost_per_unit DESC;

21. Monthly Production Trend
SELECT
    DATE_TRUNC('month', production_date::DATE) AS month,
    SUM(units_produced) AS units_produced
FROM public."r_manufacturing"
GROUP BY month
ORDER BY month;


22. Monthly Defect Trend
SELECT
    DATE_TRUNC('month', Production_Date::DATE) AS month,
    ROUND(AVG(Defect_Rate)::Numeric, 2) AS avg_defect_rate
FROM public."r_manufacturing"
GROUP BY month
ORDER BY month;


23. Monthly Efficiency Trend
SELECT
    DATE_TRUNC('month', Production_Date::DATE) AS month,
    ROUND(AVG(Production_Efficiency)::Numeric, 2) AS avg_efficiency
FROM public."r_manufacturing"
GROUP BY month
ORDER BY month;


24. KPI Snapshot
SELECT
    ROUND(AVG(production_efficiency)::Numeric,2) AS avg_efficiency_pct,
    ROUND(AVG(defect_rate)::Numeric,2) AS avg_defect_rate_pct,
    ROUND(AVG(production_cost_per_unit)::Numeric,2) AS avg_cost_per_unit,
    ROUND(SUM(downtime_minutes)/60.0,2) AS total_downtime_hours,
    COUNT(*) FILTER (WHERE Inventory_Status='Below Reorder') AS inventory_risk_days
FROM public."r_manufacturing";

25. Plant Efficiency
SELECT
    plant_id,
    ROUND(AVG(production_efficiency)::Numeric, 2) AS avg_efficiency_pct
FROM public.r_manufacturing
GROUP BY plant_id
ORDER BY avg_efficiency_pct DESC;

26. Total Production Cost 
SELECT
    SUM(units_produced * production_cost_per_unit) AS total_production_cost
FROM public.r_manufacturing;


27. Monthly Units Produced
SELECT
    DATE_TRUNC('month', production_date::date) AS month,
    SUM(units_produced) AS monthly_units_produced
FROM public.r_manufacturing
GROUP BY month
ORDER BY month;

28. FIRST PASS YIELD
SELECT
    ROUND(
        ((SUM(units_produced) - SUM(defective_units)) * 100.0)
        / NULLIF(SUM(units_produced), 0),
        2
    ) AS first_pass_yield_percent
FROM public.r_manufacturing;

29. Manufacturing Health Score
WITH kpis AS (
    SELECT
        (SUM(units_produced) * 1.0 / NULLIF(SUM(planned_units), 0)) AS efficiency,
        ((SUM(units_produced) - SUM(defective_units)) * 1.0
            / NULLIF(SUM(units_produced), 0)) AS fpy,
        (SUM(defective_units) * 1.0
            / NULLIF(SUM(units_produced), 0)) AS defect_rate
    FROM public.r_manufacturing
)
SELECT
    ROUND(
        (
            (efficiency * 0.4) +
            (fpy * 0.4) -
            (defect_rate * 0.2)
        ) * 100,
        2
    ) AS manufacturing_health_score_percent
FROM kpis;

30. Inventory Risk Indicator
SELECT
    plant_id,
    ROUND(
        (SUM(inventory_level) * 100.0)
        / NULLIF(SUM(reorder_level), 0),
        2
    ) AS inventory_risk_percent,
    CASE
        WHEN SUM(inventory_level) <= SUM(reorder_level) THEN 'Critical'
        WHEN SUM(inventory_level) <= SUM(reorder_level) * 1.2 THEN 'Warning'
        ELSE 'Safe'
    END AS inventory_status
FROM public.r_manufacturing
GROUP BY plant_id;


31. DEFECT CONTRIBUTION BY TYPE
SELECT
    defect_type,
    SUM(defective_units) AS total_defective_units,
    ROUND(
        (SUM(defective_units) * 100.0)
        / NULLIF(
            (SELECT SUM(defective_units)
             FROM public.r_manufacturing),
            0
        ),
        2
    ) AS defect_contribution_percent
FROM public.r_manufacturing
GROUP BY defect_type
ORDER BY total_defective_units DESC;

32. DOWNTIME ROOT CAUSE ANALYSIS
SELECT
    downtime_reason,
    SUM(downtime_minutes) AS total_downtime_minutes,
    ROUND(
        (SUM(downtime_minutes) * 100.0)
        / NULLIF(
            (SELECT SUM(downtime_minutes)
             FROM public.r_manufacturing),
            0
        ),
        2
    ) AS downtime_contribution_percent
FROM public.r_manufacturing
GROUP BY downtime_reason
ORDER BY total_downtime_minutes DESC;
