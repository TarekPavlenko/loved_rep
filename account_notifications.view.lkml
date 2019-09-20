view: account_notifications {
  derived_table: {
    sql: select
      bae.account_id
      ,bae.account_status
      ,bae.user_id
      ,u.email
      ,max(bae.timestamp) as last_event_time
      ,min(bae.timestamp) as first_event_time
      from prod.bd_account_event as bae
      left join prod.users as u on u.id=bae.user_id
      where  bae.account_id in (select account_id from prod.bd_account_event where account_status = 'rejected'
      or account_status = 'indeterminate')

      group by bae.account_id, bae.account_status, bae.user_id, u.email
      order by last_event_time desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_rejected {
    type: count
    filters: {
      field: account_status
      value: "rejected"
    }
  }

  measure: count_indeterminate {
    type: count
    filters: {
      field: account_status
      value: "indeterminate"
    }
  }

  measure: count_approved {
    type: count
    filters: {
      field: account_status
      value: "approved"
    }
  }

  measure: status_ratio {
    type: number
    sql: ${count_approved}/${count_rejected}/${count_indeterminate} ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_status {
    type: string
    sql: ${TABLE}.account_status ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: last_event_time {
    type: time
    sql: ${TABLE}.last_event_time ;;
  }
  dimension_group: first_event_time {
    type: time
    sql: ${TABLE}.last_event_time ;;
  }

  set: detail {
    fields: [account_id, account_status, user_id, email, last_event_time_time]
  }
}
