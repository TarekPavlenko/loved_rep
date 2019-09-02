view: user_balance_accounts_2 {
  derived_table: {
    sql: with
      digit as (
          select 0 as d union all
          select 1 union all select 2 union all select 3 union all
          select 4 union all select 5 union all select 6 union all
          select 7 union all select 8 union all select 9
      ),
      seq as (
          select a.d + (10 * b.d) + (100 * c.d)  as num
          from digit a
              cross join
              digit b
              cross join
              digit c
          order by 1
      ),
      day  as (
      select ( current_date::date - seq.num)::date as date_datetime
      from seq)

      , t as(
      select
          account_id
          ,event
          ,goal_id
          ,id as event_id
          ,sprout_id
          ,user_id
          ,transfer_amount*1 as amount
          ,'deposit' as type
          ,transfer_status as status
          ,date(timestamp) as timestamp
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
          ,date(timestamp) as timestamp
          from
          prod.bd_transfer_event_withdrawal)
      ,temp_2 as (
      select

      account_id,

      cast(timestamp as date) as date,
      type,

      amount
      from
      t)

      ,
      users as (select distinct account_id, user_id from t)
,
      yy as (select date_datetime,date,account_id, amount,
      sum(amount) over(partition by account_id order by date_datetime asc rows between unbounded preceding
      and current row) balance
      from (select d.date_datetime, t.date, i.account_id,
            sum(coalesce(t.amount,0)) amount
            from day d
            cross join (select distinct account_id from temp_2) i
            left join temp_2 t on t.date=d.date_datetime and i.account_id=t.account_id

            group by d.date_datetime, i.account_id,t.date
            ) x

      order by 2,1
      )
      select
      y.*,u.user_id
      from yy y left join users u on y.account_id=u.account_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: date_datetime {
    label: "Date_datetime"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_datetime ;;
  }

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: balance {
    type: number
    sql: ${TABLE}.balance ;;
  }
  measure: balance_on_date {
    type: sum
    sql: ${TABLE}.balance ;;
    value_format_name: usd
  }
  measure: amount_on_date {
    type: sum
    sql: ${TABLE}.amount ;;
    value_format_name: usd
  }
  measure: active_accounts_num{
    type: count_distinct
    sql: ${TABLE}.account_id ;;
    filters: {
      field: balance
      value: ">0"
    }
  }
  measure: active_users_num{
    type: count_distinct
    sql: ${TABLE}.user_id ;;
    filters: {
      field: balance
      value: ">0"
    }
  }
  measure: total_accounts_num{
    type: count_distinct
    sql: ${TABLE}.account_id ;;
  }
  measure: balance_per_active_account{
    label: "Balance per active account"
    group_label: "Accounts Counts"
    type: number
    sql:
    case when ${active_accounts_num}  is null or ${active_accounts_num} = 0 then 0 else
    sum(${balance}*1.00)/ (${active_accounts_num}*1.00) end ;;
    value_format_name: usd_0
  }
  measure: active_accounts_per_user{
    label: "Active accounts per user"
    group_label: "Accounts Counts"
    type: number
    sql:
    case when ${active_accounts_num}  is null or ${active_accounts_num} = 0 then 0 else
    (${active_accounts_num}*1.00)/ (${active_users_num}*1.00) end ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [ date, account_id, balance]
  }
}
