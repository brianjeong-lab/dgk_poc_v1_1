view: bank_category_daily {
  sql_table_name: `kb-daas-dev.mart_200723.bank_category_daily`
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

  dimension: keyword {
    type: string
    sql: ${TABLE}.KEYWORD ;;
  }

  dimension: type {
    type: number
    sql: ${TABLE}.TYPE ;;
  }

  dimension: mydate {
    type: date
    sql: TIMESTAMP(PARSE_DATE('%Y%m%d', FORMAT('%08d',${TABLE}.WRITE_DAY)));;
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
