view: category {
  sql_table_name: `kb-daas-dev.mart_200723.category`
    ;;

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.CHANNEL ;;
  }

  dimension: cnt {
    type: number
    sql: ${TABLE}.CNT ;;
  }

  dimension: cnt_doc {
    type: number
    sql: ${TABLE}.CNT_DOC ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.KEYWORD ;;
  }

  dimension: sum_score {
    type: number
    sql: ${TABLE}.SUM_SCORE ;;
  }

  dimension: type {
    type: number
    sql: ${TABLE}.TYPE ;;
  }

  dimension: write_day {
    type: number
    sql: ${TABLE}.WRITE_DAY ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
