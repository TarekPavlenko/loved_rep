view: investment_name {
  derived_table: {
    sql: select
      timestamp as investment_time
      ,user_id
      ,id as event_id
      ,dream as name
      ,event
      from prod.dream_created

      union all
select
      timestamp as investment_time
      ,user_id
      ,id as event_id
      ,case when name is not null then name else investment_name end as name
      ,event
      from prod.investment_selected
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: investment_time {
    type: time
    sql: ${TABLE}.investment_time ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  set: detail {
    fields: [investment_time_time, user_id, event_id, name, event]
  }
}
