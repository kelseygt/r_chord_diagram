SELECT DISTINCT
    saturn.sfrstcr.sfrstcr_pidm          AS pidm,
    saturn.sfrstcr.sfrstcr_term_code     AS term_code,
    saturn.sgbstdn.sgbstdn_levl_code     AS student_level,
    saturn.sgbstdn.sgbstdn_degc_code_1   AS degree_code_1,
    saturn.stvdegc.stvdegc_desc          AS degree_desc_1,
    saturn.sgbstdn.sgbstdn_coll_code_1   AS college_code_1,
    saturn.stvcoll.stvcoll_desc          AS college_desc_1,
    saturn.sgbstdn.sgbstdn_dept_code     AS dept_code_1,
    saturn.stvdept.stvdept_desc          AS dept_desc_1,
    saturn.sgbstdn.sgbstdn_majr_code_1   AS major_code_1,
    saturn.stvmajr.stvmajr_desc          AS major_desc_1,
    saturn.sgbstdn.sgbstdn_degc_code_2   AS degree_code_2,
    degree2.stvdegc_desc                 AS degree_desc_2,
    saturn.sgbstdn.sgbstdn_dept_code_2   AS dept_code_2,
    dept2.stvdept_desc                   AS dept_desc_2,
    saturn.sgbstdn.sgbstdn_coll_code_2   AS college_code_2,
    college2.stvcoll_desc                AS college_desc_2,
    saturn.sgbstdn.sgbstdn_majr_code_2   AS major_code_2,
    major2.stvmajr_desc                  AS major_desc_2
FROM
    saturn.sfrstcr
    INNER JOIN saturn.sgbstdn ON saturn.sfrstcr.sfrstcr_pidm = saturn.sgbstdn.sgbstdn_pidm
    INNER JOIN saturn.stvmajr ON saturn.sgbstdn.sgbstdn_majr_code_1 = saturn.stvmajr.stvmajr_code
    INNER JOIN saturn.stvcoll ON saturn.sgbstdn.sgbstdn_coll_code_1 = saturn.stvcoll.stvcoll_code
    INNER JOIN saturn.stvcoll   college2 ON saturn.sgbstdn.sgbstdn_coll_code_2 = college2.stvcoll_code
    INNER JOIN saturn.stvmajr   major2 ON saturn.sgbstdn.sgbstdn_majr_code_2 = major2.stvmajr_code
    INNER JOIN saturn.stvdegc ON saturn.sgbstdn.sgbstdn_degc_code_1 = saturn.stvdegc.stvdegc_code
    INNER JOIN saturn.stvdegc   degree2 ON saturn.sgbstdn.sgbstdn_degc_code_2 = degree2.stvdegc_code
    INNER JOIN saturn.stvdept ON saturn.sgbstdn.sgbstdn_dept_code = saturn.stvdept.stvdept_code
    INNER JOIN saturn.stvdept   dept2 ON saturn.sgbstdn.sgbstdn_dept_code_2 = dept2.stvdept_code
WHERE
    saturn.sfrstcr.sfrstcr_term_code = &&term
    AND saturn.sfrstcr.sfrstcr_rsts_code IN (
        'AU',
        'RE',
        'RW',
        'RZ',
        'AW',
        'NB',
        'NC',
        'NX',
        'NZ',
        'W'
    )
    AND saturn.sgbstdn.sgbstdn_term_code_eff = (
        SELECT
            MAX(saturn.sgbstdn.sgbstdn_term_code_eff)
        FROM
            saturn.sgbstdn
        WHERE
            saturn.sgbstdn.sgbstdn_term_code_eff <= &&term
            AND saturn.sgbstdn.sgbstdn_pidm = saturn.sfrstcr.sfrstcr_pidm
    )
ORDER BY
    pidm