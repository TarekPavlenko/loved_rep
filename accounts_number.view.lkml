view: accounts_number {
  derived_table: {
    sql: select
       date(cc1.timestamp) as event_date,
       cc1.user_id,
       count (distinct cc2.id) as event_cnt


        from
            prod.account_create_click cc1
            inner join
            prod.account_create_click cc2
            on cc1.user_id=cc2.user_id and cc1.timestamp>=cc2.timestamp


            group by event_date, cc1.user_id
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

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: event_cnt {
    type: number
    sql: ${TABLE}.event_cnt ;;
  }
  measure: user_cnt {
    type: count_distinct
    sql: ${TABLE}.user_id;;
  }
  dimension: account_group {
    type: string
    sql: case when ${TABLE}.event_cnt = 1 then '1'
              when ${TABLE}.event_cnt = 2 then '2'
              when ${TABLE}.event_cnt = 3 then '3'
              when ${TABLE}.event_cnt = 4 then '4'
              when ${TABLE}.event_cnt = 5 then '5'
              when ${TABLE}.event_cnt > 5 then '5+' end;;
  }



  set: detail {
    fields: [event_date, user_id, event_cnt]
  }
}
