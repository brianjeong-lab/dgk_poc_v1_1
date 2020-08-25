view: keyword_relation_lv2 {
  derived_table: {
    sql:
          #for 2020-08-18
          SELECT
            LV1_keyword, LV1_scr, LV1_cnt,
            LV2_keyword, LV2_scr, LV2_cnt,
          FROM (
            SELECT
              BBBB.LV1_keyword,
              BBBB.LV1_scr,
              BBBB.LV1_cnt,
              (CASE WHEN AAAB.keyword = "KBALBERT" OR AAAB.keyword = "ALBERT" THEN "KB알버트" ELSE AAAB.keyword END) as LV2_keyword,
              SUM(AAAB.score) AS LV2_scr,
              COUNT(AAAB.keyword) AS LV2_cnt,
              ROW_NUMBER() OVER (PARTITION BY BBBB.LV1_keyword ORDER BY SUM(AAAB.score) DESC) AS rownum
            FROM
              `kb-daas-dev.master_200729.keyword_bank_result` AAAA,
              UNNEST(AAAA.KPE) AS AAAB,
              (
                SELECT
                  BBB.LV1_keyword,
                  BBB.LV1_scr,
                  BBB.LV1_cnt,
                  AAA.docid
                FROM
                  `kb-daas-dev.master_200729.keyword_bank_result` AAA,
                  UNNEST(AAA.KPE) AS AAB,
                  (
                  SELECT
                    TB.keyword AS LV1_keyword,
                    SUM(TB.score) AS LV1_scr,
                    COUNT(TB.keyword) AS LV1_cnt
                  FROM
                    `kb-daas-dev.master_200729.keyword_bank_result` TA,
                    UNNEST(TA.KPE) AS TB
                  WHERE
                    TA.DOCID IN (
                      SELECT
                        distinct A.DOCID
                      FROM
                        `kb-daas-dev.master_200729.keyword_bank_result` A,
                        UNNEST(A.KPE) K
                      WHERE
                        A.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                            AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                        AND DATE(A.WRITESTAMP, 'Asia/Seoul') >= {% parameter prmfrom %}
                        AND DATE(A.WRITESTAMP, 'Asia/Seoul') <= {% parameter prmto %}
                        AND K.keyword = {% parameter prmkeyword %}
                        AND A.DOCID not in (SELECT docid from `kb-daas-dev.mart_200729.keyword_bank_result_agg_remove_docid`)
                    )
                    AND TA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                          AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                    AND DATE(TA.WRITESTAMP, 'Asia/Seoul') >= {% parameter prmfrom %}
                    AND DATE(TA.WRITESTAMP, 'Asia/Seoul') <= {% parameter prmto %}
                    AND TB.keyword != {% parameter prmkeyword %}
                    AND LENGTH(TB.keyword) < 10
                    AND TB.keyword not in (SELECT keyword from `kb-daas-dev.mart_200729.filter`)
                  GROUP BY
                    TB.keyword
                  ORDER BY
                    SUM(TB.score) DESC,
                    TB.keyword
                  LIMIT
                    10 ) BBB
                WHERE
                  AAB.keyword = BBB.LV1_keyword
                  AND LENGTH(AAB.keyword) < 10
                  AND AAA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                          AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                  AND DATE(AAA.WRITESTAMP, 'Asia/Seoul') >= {% parameter prmfrom %}
                  AND DATE(AAA.WRITESTAMP, 'Asia/Seoul') <= {% parameter prmto %}
                GROUP BY
                  BBB.LV1_keyword,
                  BBB.LV1_scr,
                  BBB.LV1_cnt,
                  AAA.docid
              ) BBBB
            WHERE
              AAAA.docid = BBBB.docid
              AND AAAB.keyword != BBBB.LV1_keyword
              AND AAAB.keyword != {% parameter prmkeyword %}
              AND LENGTH(AAAB.keyword) < 10
              AND AAAA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                          AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
              AND DATE(AAAA.WRITESTAMP, 'Asia/Seoul') >= {% parameter prmfrom %}
              AND DATE(AAAA.WRITESTAMP, 'Asia/Seoul') <= {% parameter prmto %}
              AND AAAA.docid IN (
                SELECT
                  distinct A.DOCID
                FROM
                  `kb-daas-dev.master_200729.keyword_bank_result` A,
                  UNNEST(A.KPE) K
                WHERE
                  A.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
                      AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
                  AND DATE(A.WRITESTAMP, 'Asia/Seoul') >= {% parameter prmfrom %}
                  AND DATE(A.WRITESTAMP, 'Asia/Seoul') <= {% parameter prmto %}
                  AND K.keyword = {% parameter prmkeyword %}
                  AND A.DOCID not in (SELECT docid from `kb-daas-dev.mart_200729.keyword_bank_result_agg_remove_docid`)
              )
            GROUP BY
              LV1_keyword,
              LV1_scr,
              LV1_cnt,
              LV2_keyword
          )
            WHERE rownum <= 10
          ORDER BY
            LV1_scr DESC, LV2_scr DESC
       ;;

# for 2020-08-18
#           SELECT
#             LV1_keyword, LV1_scr, LV1_cnt,
#             LV2_keyword, LV2_scr, LV2_cnt,
#           FROM (
#             SELECT
#               BBBB.LV1_keyword,
#               BBBB.LV1_scr,
#               BBBB.LV1_cnt,
#               AAAB.keyword as LV2_keyword,
#               SUM(AAAB.score) AS LV2_scr,
#               COUNT(AAAB.keyword) AS LV2_cnt,
#               ROW_NUMBER() OVER (PARTITION BY BBBB.LV1_keyword ORDER BY SUM(AAAB.score) DESC) AS rownum
#             FROM
#               `kb-daas-dev.master_200729.keyword_bank_result` AAAA,
#               UNNEST(AAAA.KPE) AS AAAB,
#               (
#                 SELECT
#                   BBB.LV1_keyword,
#                   BBB.LV1_scr,
#                   BBB.LV1_cnt,
#                   AAA.docid
#                 FROM
#                   `kb-daas-dev.master_200729.keyword_bank_result` AAA,
#                   UNNEST(AAA.KPE) AS AAB,
#                   (
#                   SELECT
#                     TB.keyword AS LV1_keyword,
#                     SUM(TB.score) AS LV1_scr,
#                     COUNT(TB.keyword) AS LV1_cnt
#                   FROM
#                     `kb-daas-dev.master_200729.keyword_bank_result` TA,
#                     UNNEST(TA.KPE) AS TB
#                   WHERE
#                     TA.DOCID IN (
#                     SELECT
#                       A.DOCID
#                     FROM
#                       `kb-daas-dev.master_200729.keyword_bank_result` A
#                     WHERE
#                       A.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
#                           AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
#                       AND DATE(A.WRITESTAMP) >= {% parameter prmfrom %}
#                       AND DATE(A.WRITESTAMP) <= {% parameter prmto %}
#                       AND EXISTS (
#                       SELECT
#                         *
#                       FROM
#                         UNNEST(A.KPE)
#                       WHERE
#                         keyword = {% parameter prmkeyword %} ) )
#                     AND TA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
#                           AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
#                     AND DATE(TA.WRITESTAMP) >= {% parameter prmfrom %}
#                     AND DATE(TA.WRITESTAMP) <= {% parameter prmto %}
#                     AND TB.keyword != {% parameter prmkeyword %}
#                     AND LENGTH(TB.keyword) < 10
#                   GROUP BY
#                     TB.keyword
#                   ORDER BY
#                     SUM(TB.score) DESC,
#                     TB.keyword
#                   LIMIT
#                     10 ) BBB
#                 WHERE
#                   AAB.keyword = BBB.LV1_keyword
#                   AND LENGTH(AAB.keyword) < 10
#                   AND AAA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
#                           AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
#                   AND DATE(AAA.WRITESTAMP) >= {% parameter prmfrom %}
#                   AND DATE(AAA.WRITESTAMP) <= {% parameter prmto %}
#                 GROUP BY
#                   BBB.LV1_keyword,
#                   BBB.LV1_scr,
#                   BBB.LV1_cnt,
#                   AAA.docid
#               ) BBBB
#             WHERE
#               AAAA.docid = BBBB.docid
#               AND AAAB.keyword != BBBB.LV1_keyword
#               AND AAAB.keyword != {% parameter prmkeyword %}
#               AND LENGTH(AAAB.keyword) < 10
#               AND AAAA.CRAWLSTAMP BETWEEN TIMESTAMP_SUB(TIMESTAMP {% parameter prmfrom %}, INTERVAL 1 DAY)
#                           AND TIMESTAMP_ADD(TIMESTAMP {% parameter prmto %}, INTERVAL 2 DAY)
#               AND DATE(AAAA.WRITESTAMP) >= {% parameter prmfrom %}
#               AND DATE(AAAA.WRITESTAMP) <= {% parameter prmto %}
#             GROUP BY
#               LV1_keyword,
#               LV1_scr,
#               LV1_cnt,
#               LV2_keyword
#           )
#             WHERE rownum <= 10
#           ORDER BY
#             LV1_scr DESC, LV2_scr DESC
  }

  filter: prmkeyword {
    type: string
  }

  filter: prmfrom {
    type: string
  }

  filter: prmto {
    type: string
  }

  dimension: lv1 {
    type: string
    sql: CONCAT(${TABLE}.LV1_keyword, " (", CEIL(${TABLE}.LV1_cnt), ")") ;;
  }

  dimension: lv1_keyword {
    type: string
    sql: ${TABLE}.LV1_keyword ;;
  }

  dimension: lv1_scr {
    type: number
    sql: ${TABLE}.LV1_scr ;;
  }

  dimension: lv1_cnt {
    type: number
    sql: ${TABLE}.LV1_cnt ;;
  }

  dimension: lv2 {
    type: string
    sql: CONCAT(${TABLE}.LV2_keyword, " (", CEIL(${TABLE}.LV2_cnt), ")") ;;
  }

  dimension: lv2_keyword {
    type: string
    sql: ${TABLE}.LV2_keyword ;;
  }

  dimension: lv2_scr {
    type: number
    sql: ${TABLE}.LV2_scr ;;
  }

  dimension: lv2_cnt {
    type: number
    sql: ${TABLE}.LV2_cnt ;;
  }

  dimension: sort {
    type: number
    sql: ceil(${TABLE}.LV1_cnt) * 10000 + ceil(${TABLE}.LV2_cnt) ;;
  }

  set: detail {
    fields: [lv1, lv1_keyword, lv1_scr, lv1_cnt, lv2, lv2_keyword, lv2_scr, lv2_cnt, sort]
  }
}
