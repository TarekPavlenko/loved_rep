view: accounts_cummulative {
  derived_table: {
    sql: with a1 as
      (select
             date(cc1.timestamp) as event_date,
             cc1.user_id,
             count (distinct cc2.id) as event_cnt


              from
                  prod.account_create_click cc1
                  inner join
                  prod.account_create_click cc2
                  on cc1.user_id=cc2.user_id and cc1.timestamp>=cc2.timestamp


                  group by event_date, cc1.user_id)
         ,
         a2 as(
          select
          event_date,
         user_id,
         case when event_cnt = 1 then '1'
                    when event_cnt = 2 then '2'
                    when event_cnt = 3 then '3'
                    when event_cnt = 4 then '4'
                    when event_cnt = 5 then '5'
                    when event_cnt > 5 then '5+' end as account_group
          from a1
          )
      select
      a.event_date
      ,b.account_group

      ,count (distinct b.user_id) as user_cnt_cumm
      from a2 a
      left join a2 b
      on a.event_date>=b.event_date
      group by a.event_date, b.account_group
      order by a.event_date, b.account_group desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: event_date {
    type: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: account_group {
    type: string
    sql: ${TABLE}.account_group ;;
  }

  measure: user_cnt_cumm {
    type: number
    sql: ${TABLE}.user_cnt_cumm ;;
  }

  set: detail {
    fields: [event_date, account_group, user_cnt_cumm]
  }
}
