view: survey_list_14_days_after_bank_acc_created {
  derived_table: {
    sql: select
      concat(concat(u.first_name,' '), u.last_name) as name

      ,replace(replace(replace(replace(
      case when u.phone_number is not null then
      u.phone_number else u.phone end, '(','+1'),' - ',''),')',''),' ','') as phone
      ,u.email
      ,bss.id as user_id
      ,bss.timestamp as bank_account_date
      from prod.bank_setup_success bss
      left join prod.users u
      on bss.user_id=u.id

      where timestamp < current_date -interval '14 day'
      and user_id in (select distinct user_id from ${active_accounts_users.SQL_TABLE_NAME} where balance>0)
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: bank_account_date {
    type: time
    sql: ${TABLE}.bank_account_date ;;
  }

  set: detail {
    fields: [name, phone, email, user_id, bank_account_date_time]
  }
}
