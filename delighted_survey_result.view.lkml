view: delighted_survey_result {
  derived_table: {
    sql: select * from delighted_surveys_data."data" dsd
      inner join ${active_accounts_users.SQL_TABLE_NAME} aau on dsd.event_data__person__email= aau.email and date(dsd._sdc_received_at)=aau.date_datetime
     where aau.balance >0 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }



  dimension: __sdc_primary_key {
    type: string
    sql: ${TABLE}.__sdc_primary_key ;;
  }

  dimension_group: _sdc_batched_at {
    type: time
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_received_at {
    type: time
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: event_data__created_at {
    type: number
    sql: ${TABLE}.event_data__created_at ;;
  }

  dimension: event_data__id {
    type: string
    sql: ${TABLE}.event_data__id ;;
  }

  dimension: event_data__permalink {
    type: string
    sql: ${TABLE}.event_data__permalink ;;
  }

  dimension: event_data__person__created_at {
    type: number
    sql: ${TABLE}.event_data__person__created_at ;;
  }

  dimension: event_data__person__email {
    type: string
    sql: ${TABLE}.event_data__person__email ;;
  }

  dimension: event_data__person__id {
    type: string
    sql: ${TABLE}.event_data__person__id ;;
  }

  dimension: event_data__person__name {
    type: string
    sql: ${TABLE}.event_data__person__name ;;
  }

  dimension: event_data__person_properties__collection {
    type: string
    sql: ${TABLE}.event_data__person_properties__collection ;;
  }

  dimension: event_data__person_properties__purchase_experience {
    type: string
    sql: ${TABLE}.event_data__person_properties__purchase_experience ;;
  }

  dimension: event_data__score {
    type: number
    sql: ${TABLE}.event_data__score ;;
  }

  dimension: event_data__survey_type {
    type: string
    sql: ${TABLE}.event_data__survey_type ;;
  }

  dimension: event_data__updated_at {
    type: number
    sql: ${TABLE}.event_data__updated_at ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: test {
    type: string
    sql: ${TABLE}.test ;;
  }

  dimension: event_data__person_properties__user_id {
    type: string
    sql: ${TABLE}.event_data__person_properties__user_id ;;
  }

  dimension: event_data__person__phone_number {
    type: string
    sql: ${TABLE}.event_data__person__phone_number ;;
  }

  dimension: event_data__person_properties__delighted_source {
    type: string
    label: "event_data__person_properties__delighted source"
    sql: ${TABLE}."event_data__person_properties__delighted source" ;;
  }

  dimension: event_data__person_properties__bank_account_date {
    type: string
    sql: ${TABLE}.event_data__person_properties__bank_account_date ;;
  }

  dimension: event_data__person_properties__delighted_device_type {
    type: string
    label: "event_data__person_properties__delighted device type"
    sql: ${TABLE}."event_data__person_properties__delighted device type" ;;
  }

  dimension: event_data__person_properties__delighted_browser {
    type: string
    label: "event_data__person_properties__delighted browser"
    sql: ${TABLE}."event_data__person_properties__delighted browser" ;;
  }

  dimension: event_data__person_properties__delighted_operating_system {
    type: string
    label: "event_data__person_properties__delighted operating system"
    sql: ${TABLE}."event_data__person_properties__delighted operating system" ;;
  }

  dimension: event_data__comment {
    type: string
    sql: ${TABLE}.event_data__comment ;;
  }

  dimension: score_range{
    type: string
    sql: case when ${event_data__score}<8 then 'Detractors'
              when ${event_data__score}=8 then 'Passives'
              when ${event_data__score}>8 then 'Promoters'
              end
     ;;
  }

  measure: event_count {
    type: count_distinct
    sql: ${TABLE}.event_data__person__email;;
      }

  measure: promoters_count {
    type: count_distinct
    sql: ${TABLE}.event_data__person__email;;
    filters: {
      field: score_range
      value: "'Promoters'"
  }
}
  measure: detractors_count {
    type: count_distinct
    sql: ${TABLE}.event_data__person__email;;
    filters: {
      field: score_range
      value: "'Detractors'"
    }
  }
  measure: NPS {
    type: number
    sql: (${promoters_count}*1.00 - ${detractors_count}*1.00) / ${event_count}*1.00;;
    value_format_name: percent_2
  }



  set: detail {
    fields: [
      __sdc_primary_key,
      _sdc_batched_at_time,
      _sdc_received_at_time,
      _sdc_sequence,
      _sdc_table_version,
      event_data__created_at,
      event_data__id,
      event_data__permalink,
      event_data__person__created_at,
      event_data__person__email,
      event_data__person__id,
      event_data__person__name,
      event_data__person_properties__collection,
      event_data__person_properties__purchase_experience,
      event_data__score,
      event_data__survey_type,
      event_data__updated_at,
      event_id,
      event_type,
      test,
      event_data__person_properties__user_id,
      event_data__person__phone_number,
      event_data__person_properties__delighted_source,
      event_data__person_properties__bank_account_date,
      event_data__person_properties__delighted_device_type,
      event_data__person_properties__delighted_browser,
      event_data__person_properties__delighted_operating_system,
      event_data__comment
    ]
  }
}
