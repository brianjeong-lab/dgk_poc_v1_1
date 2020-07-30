view: sentence {
  sql_table_name: `kb-daas-dev.mart_200723.sentence`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.CHANNEL ;;
  }

  dimension: s_name {
    type: string
    sql: ${TABLE}.S_NAME ;;
  }

  dimension: sb_name {
    type: string
    sql: ${TABLE}.SB_NAME ;;
  }

  dimension: sentence1 {
    type: string
    sql: ${TABLE}.SENTENCE1 ;;
  }

  dimension: sentence2 {
    type: string
    sql: ${TABLE}.SENTENCE2 ;;
  }

  dimension: sentence3 {
    type: string
    sql: ${TABLE}.SENTENCE3 ;;
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
    drill_fields: [id, s_name, sb_name]
  }
}
