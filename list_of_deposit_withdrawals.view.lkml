view: list_of_deposit_withdrawals {
  derived_table: {
    sql: select
      account_id
      ,event
      ,goal_id
      ,id as event_id
      ,sprout_id
      ,user_id
      ,transfer_amount*1 as amount
      ,'deposit' as type
      ,transfer_status as status
      ,timestamp
      from
      prod.bd_transfer_event_deposit

      union all
      select
      account_id
      ,event
      ,goal_id
      ,id as event_id
      ,sprout_id
      ,user_id
      ,withdrawal_amount*(-1) as amount
      ,'withdrawal' as type
      ,withdrawal_status as status
      ,timestamp
      from
      prod.bd_transfer_event_withdrawal
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: goal_id {
    type: string
    sql: ${TABLE}.goal_id ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: sprout_id {
    type: string
    sql: ${TABLE}.sprout_id ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  set: detail {
    fields: [
      account_id,
      event,
      goal_id,
      event_id,
      sprout_id,
      user_id,
      amount,
      type,
      status,
      timestamp_time
    ]
  }
}
