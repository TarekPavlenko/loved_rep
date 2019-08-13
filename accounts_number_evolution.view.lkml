view: accounts_number_evolution {
  derived_table: {
    sql: with a as (select
             date(cc1.timestamp) as event_date,
             min(date(cc1.timestamp)) as min_date,
             cc1.user_id,
             count (distinct cc1.id) as event_cnt


              from
                  prod.account_create_click cc1
                  inner join
                  prod.account_create_click cc2
                  on cc1.user_id=cc2.user_id and cc1.timestamp>=cc2.timestamp

                  group by event_date, cc1.user_id)
,digit as (
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
, aa as (select d.date_datetime, t.min_date, t.event_date, i.user_id,
      t.event_cnt
      from day d
      cross join (select distinct user_id from a) i
      left join a t on t.event_date=d.date_datetime and i.user_id=t.user_id
)
,aaa as (
select date_datetime
,event_date
,user_id
,event_cnt
,sum(event_cnt) over(partition by user_id order by date_datetime asc rows between unbounded preceding and current row) event_balance
from aa
)

select date_datetime,
event_balance,
 user_id
from aaa
where event_balance is not null



 ;;
  }

  dimension: date_datetime {
    type: date
    sql: ${TABLE}.date_datetime ;;
  }

  dimension: event_balance {
    type: number
    sql: ${TABLE}.event_balance ;;
  }

  dimension: user_id {
    type: string
    sql: (${TABLE}.user_id) ;;
  }
  measure: user_cnt {
    type: count_distinct
    sql: ${user_id}  ;;
  }

  set: detail {
    fields: [date_datetime, event_balance, user_id]
  }
}
