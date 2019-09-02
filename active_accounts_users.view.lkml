view: active_accounts_users {
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
      ,uu.email
      ,replace(replace(replace(replace(
      case when u.phone_number is not null then
      u.phone_number else u.phone end, '(','+1'),' - ',''),')',''),' ','') as phone
      from yy y left join users u on y.account_id=u.account_id
      left join prod.users uu on u.user_id=uu.id
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date_datetime {
    type: date
    sql: ${TABLE}.date_datetime ;;
  }
  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: balance {
    type: number
    sql: ${TABLE}.balance ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  set: detail {
    fields: [
      date_datetime,
      date,
      account_id,
      amount,
      balance,
      user_id
    ]
  }
}
