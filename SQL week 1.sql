-- ==============================================
-- 1. Create Jurisdiction_Hierarchy table
-- ==============================================
CREATE TABLE IF NOT EXISTS Jurisdiction_Hierarchy (
    village_id INT PRIMARY KEY,
    village_name VARCHAR(100) NOT NULL,
    district_name VARCHAR(100) NOT NULL,
    region_name VARCHAR(100) NOT NULL
);

-- Example insert (replace with your actual data)
INSERT INTO Jurisdiction_Hierarchy (village_id, village_name, district_name, region_name)
VALUES
(1, 'Village A', 'District X', 'Region 1'),
(2, 'Village B', 'District X', 'Region 1'),
(3, 'Village C', 'District Y', 'Region 1'),
(4, 'Village D', 'District Z', 'Region 2');


-- ==============================================
-- 2. Create Beneficiary_Partner_Data table
-- (assuming it may not exist yet)
-- ==============================================
CREATE TABLE IF NOT EXISTS Beneficiary_Partner_Data (
    partner_id INT,
    partner_name VARCHAR(100),
    village_id INT,
    beneficiaries INT,
    beneficiary_type VARCHAR(50),
    PRIMARY KEY (partner_id, village_id)
);

-- Example insert (replace with actual data)
INSERT INTO Beneficiary_Partner_Data (partner_id, partner_name, village_id, beneficiaries, beneficiary_type)
VALUES
(1, 'Partner 1', 1, 10, 'HH'),
(1, 'Partner 1', 2, 5, 'HH'),
(2, 'Partner 2', 3, 8, 'HH'),
(2, 'Partner 2', 4, 12, 'HH');


-- ==============================================
-- 3. Create District_Population table
-- (needed for coverage calculation)
-- ==============================================
CREATE TABLE IF NOT EXISTS District_Population (
    district_name VARCHAR(100) PRIMARY KEY,
    population INT
);

-- Example insert (replace with actual population)
INSERT INTO District_Population (district_name, population)
VALUES
('District X', 500),
('District Y', 300),
('District Z', 400);


-- ==============================================
-- 4. Create District_Summary view
-- ==============================================
CREATE OR REPLACE VIEW District_Summary AS
SELECT
    j.district_name,
    j.region_name,
    SUM(b.beneficiaries * 6) AS individual_beneficiaries,
    ROUND(SUM(b.beneficiaries * 6) * 1.0 / d.population, 4) AS coverage_ratio
FROM Beneficiary_Partner_Data b
JOIN Jurisdiction_Hierarchy j
    ON b.village_id = j.village_id
JOIN District_Population d
    ON j.district_name = d.district_name
GROUP BY j.district_name, j.region_name, d.population;


-- ==============================================
-- 5. Create Partner_Summary view
-- ==============================================
CREATE OR REPLACE VIEW Partner_Summary AS
SELECT
    b.partner_name,
    COUNT(DISTINCT b.village_id) AS villages_reached,
    COUNT(DISTINCT j.district_name) AS districts_reached
FROM Beneficiary_Partner_Data b
JOIN Jurisdiction_Hierarchy j
    ON b.village_id = j.village_id
GROUP BY b.partner_name;


-- ==============================================
-- 6. Optional: Check your summaries
-- ==============================================
-- District Summary
SELECT * FROM District_Summary;

-- Partner Summary
SELECT * FROM Partner_Summary;












