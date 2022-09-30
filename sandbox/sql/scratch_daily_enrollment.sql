SELECT a.days_to_class_start,
       a.student_id,
       a.term_id,
       a.term_desc,
       a1.term_id AS previous_year_term_id,
       a1.term_desc AS previous_year_term_desc,
       p.college_abbrv AS college,
       p.department_id AS department,
       b.primary_program_id AS program,
       c.gender_code AS gender,
       c.ipeds_race_ethnicity AS race_ethnicity
FROM export.daily_enrollment a
LEFT JOIN export.term a1
       ON a.season = a1.season
      AND ( a.academic_year_code::INTEGER - 1 ) = a1.academic_year_code::INTEGER
LEFT JOIN export.student_term_level b
       ON a.student_id = b.student_id
      AND a.term_id = b.term_id
      AND b.is_primary_level
LEFT JOIN export.student c
       ON c.student_id = a.student_id
LEFT JOIN export.academic_programs p
       ON p.program_id = b.primary_program_id
WHERE a.is_enrolled;


SELECT COUNT(a.student_id) AS headcount,
       a.days_to_class_start,
       a.term_id
FROM export.daily_enrollment a
LEFT JOIN export.student_term_level b
       ON a.student_id = b.student_id
      AND a.term_id = b.term_id
      AND b.is_primary_level
LEFT JOIN export.student c
       ON c.student_id = a.student_id
LEFT JOIN export.academic_programs p
       ON p.program_id = b.primary_program_id
WHERE a.is_enrolled
GROUP BY (a.days_to_class_start, a.term_id)
ORDER BY a.days_to_class_start DESC;