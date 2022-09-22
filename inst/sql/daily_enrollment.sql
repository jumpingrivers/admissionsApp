SELECT a.days_to_class_start AS days_to_term_start,
       a.is_enrolled,
       a.student_id,
       a.term_id,
       a.year,
       a.season,
       p.college_abbrv AS college,
       p.department_id AS department,
       b.primary_program_id AS program,
       c.gender_code AS gender,
       c.ipeds_race_ethnicity AS race_ethnicity
FROM export.daily_enrollment a
LEFT JOIN export.student_term_level b
       ON a.student_id = b.student_id
      AND a.term_id = b.term_id
      AND b.is_primary_level
LEFT JOIN export.student c
       ON c.student_id = a.student_id
LEFT JOIN export.academic_programs p
       ON p.program_id = b.primary_program_id;