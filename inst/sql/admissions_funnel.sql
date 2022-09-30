SELECT
    -- Unique identifier for individual
    a.prospect_id,
    a.date,
    a.term_id,
    a1.term_desc,
    a.prospect_status,
    CASE WHEN a.is_melt THEN 'Melt'
        WHEN a.is_enrolled THEN 'Enrolled'
        WHEN a.is_admitted THEN 'Admitted'
        ELSE 'Non-Admit'
    END AS admit_status,
    -- IN ORDER
    a.is_prospect,
    a.is_inquiry,
    a.is_applicant,
    a.is_admitted,
    a.is_enrolled,
    a.is_melt
FROM export.daily_admissions_funnel a
LEFT JOIN export.term a1
       ON a1.term_id = a.term_id
WHERE a.is_latest
AND a.date = (SELECT MAX(a1.date)
              FROM export.daily_admissions_funnel a1)
AND ( a1.is_current_term OR a1.is_next_term OR a1.is_previous_term );