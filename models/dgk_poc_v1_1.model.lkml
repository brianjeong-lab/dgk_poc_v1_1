connection: "kb-daas-dev"

# include all the views
include: "/views/**/*.view"

datagroup: dgk_poc_v1_1_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: dgk_poc_v1_1_default_datagroup




explore: bank_category_daily {}

explore: category {}

explore: category_daily_top_100 {}

explore: category_keyword_daily_top_100 {}

explore: keyword {}

explore: keyword_daily_top_100 {}

explore: keyword_id {}

explore: keyword_list {}

explore: sentence {}

explore: keyword_relation_lv1 {}

explore: keyword_relation_lv2 {}

explore: keyword_relation_lv2_hist {}

explore: sentence_poc {}

explore: keyword_bank {}

explore: keyword_bank_result {}

explore: keyword_corona {}

explore: big4_bank_wo {}

explore: keyword_corona_result {}

explore: keyword_buzz_channel {}

explore: bank_buzz {}

explore: category_buzz {}

explore: bank_sh {}

explore: bank_kb {}

explore: bank_hana {}

explore: bank_wo{}

explore: bank_nh{}

explore: keyword_bank_bypress {}

explore: bodo {}
