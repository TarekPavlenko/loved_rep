view: accounts_redshift {
  derived_table: {
    sql: select * from
      prod.account_create_click
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: received_at {
    type: time
    sql: ${TABLE}.received_at ;;
  }

  dimension: uuid {
    type: number
    sql: ${TABLE}.uuid ;;
  }

  dimension: event_text {
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: date_of_birth {
    type: string
    sql: ${TABLE}.date_of_birth ;;
  }

  dimension_group: sent_at {
    type: time
    sql: ${TABLE}.sent_at ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_ip {
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: context_library_name {
    type: string
    sql: ${TABLE}.context_library_name ;;
  }

  dimension: context_library_version {
    type: string
    sql: ${TABLE}.context_library_version ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: child_id {
    type: string
    sql: ${TABLE}.child_id ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension_group: original_timestamp {
    type: time
    sql: ${TABLE}.original_timestamp ;;
  }

  dimension_group: uuid_ts {
    type: time
    sql: ${TABLE}.uuid_ts ;;
  }
  measure: accounts_cnt {
    type: running_total
    sql: ${TABLE}.id ;;
  }

  measure: user_cnt {
    type: count_distinct
    sql: ${TABLE}.user_id;;
  }

  dimension: account_group {
    type: string
    sql: case when ${TABLE}.user_cnt = 1 then '1'
              when ${TABLE}.user_cnt = 2 then '2'
              when ${TABLE}.user_cnt = 3 then '3'
              when ${TABLE}.user_cnt = 4 then '4'
              when ${TABLE}.user_cnt = 5 then '5'
              when ${TABLE}.user_cnt > 5 then '5+' end;;
  }


  set: detail {
    fields: [
      id,
      received_at_time,
      uuid,
      event_text,
      date_of_birth,
      sent_at_time,
      user_id,
      timestamp_time,
      context_device_type,
      context_ip,
      context_library_name,
      context_library_version,
      firstname,
      lastname,
      child_id,
      event,
      original_timestamp_time,
      uuid_ts_time
    ]
  }
}
