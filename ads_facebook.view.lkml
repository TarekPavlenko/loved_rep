view: ads_facebook {
  derived_table: {
    sql: select * from loved_facebook_data."ads_insights"
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: _sdc_batched_at {
    type: time
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_extracted_at {
    type: time
    sql: ${TABLE}._sdc_extracted_at ;;
  }

  dimension_group: _sdc_received_at {
    type: time
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}.account_name ;;
  }

  dimension: ad_id {
    type: string
    sql: ${TABLE}.ad_id ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}.ad_name ;;
  }

  dimension: adset_id {
    type: string
    sql: ${TABLE}.adset_id ;;
  }

  dimension: adset_name {
    type: string
    sql: ${TABLE}.adset_name ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: cost_per_inline_link_click {
    type: number
    sql: ${TABLE}.cost_per_inline_link_click ;;
  }

  dimension: cost_per_inline_post_engagement {
    type: number
    sql: ${TABLE}.cost_per_inline_post_engagement ;;
  }

  dimension: cost_per_unique_click {
    type: number
    sql: ${TABLE}.cost_per_unique_click ;;
  }

  dimension: cost_per_unique_inline_link_click {
    type: number
    sql: ${TABLE}.cost_per_unique_inline_link_click ;;
  }

  dimension: cpc {
    type: number
    sql: ${TABLE}.cpc ;;
  }

  dimension: cpm {
    type: number
    sql: ${TABLE}.cpm ;;
  }

  dimension: cpp {
    type: number
    sql: ${TABLE}.cpp ;;
  }

  dimension: ctr {
    type: number
    sql: ${TABLE}.ctr ;;
  }

  dimension_group: date_start {
    type: time
    sql: ${TABLE}.date_start ;;
  }

  dimension_group: date_stop {
    type: time
    sql: ${TABLE}.date_stop ;;
  }

  dimension: frequency {
    type: number
    sql: ${TABLE}.frequency ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: inline_link_click_ctr {
    type: number
    sql: ${TABLE}.inline_link_click_ctr ;;
  }

  dimension: inline_link_clicks {
    type: number
    sql: ${TABLE}.inline_link_clicks ;;
  }

  dimension: inline_post_engagement {
    type: number
    sql: ${TABLE}.inline_post_engagement ;;
  }

  dimension: objective {
    type: string
    sql: ${TABLE}.objective ;;
  }

  dimension: reach {
    type: number
    sql: ${TABLE}.reach ;;
  }

  dimension: relevance_score__status {
    type: string
    sql: ${TABLE}.relevance_score__status ;;
  }

  dimension: social_spend {
    type: number
    sql: ${TABLE}.social_spend ;;
  }

  dimension: spend {
    type: number
    sql: ${TABLE}.spend ;;
  }

  dimension: unique_clicks {
    type: number
    sql: ${TABLE}.unique_clicks ;;
  }

  dimension: unique_ctr {
    type: number
    sql: ${TABLE}.unique_ctr ;;
  }

  dimension: unique_inline_link_click_ctr {
    type: number
    sql: ${TABLE}.unique_inline_link_click_ctr ;;
  }

  dimension: unique_inline_link_clicks {
    type: number
    sql: ${TABLE}.unique_inline_link_clicks ;;
  }

  dimension: unique_link_clicks_ctr {
    type: number
    sql: ${TABLE}.unique_link_clicks_ctr ;;
  }

  dimension: relevance_score__score {
    type: number
    sql: ${TABLE}.relevance_score__score ;;
  }

  measure: average_cpc {
    type: average
    sql:  ${TABLE}.cpc ;;
    value_format_name: decimal_2
  }
  measure: average_cost_per_unique_click {
    type: average
    sql:  ${TABLE}.cost_per_unique_click ;;
    value_format_name: decimal_2
  }
  measure: average_cpm {
    type: average
    sql:  ${TABLE}.cpm ;;
    value_format_name: decimal_2
  }
  measure: average_ctr {
    type: average
    sql:  ${TABLE}.ctr ;;
    value_format_name: decimal_2
  }
  measure: average_unique_ctr {
    type: average
    sql:  ${TABLE}.unique_ctr ;;
    value_format_name: decimal_2
  }
  measure: average_relevance_score {
    type: average
    sql:  ${TABLE}.relevance_score__score ;;
    value_format_name: decimal_2
  }
  measure: total_cost {
    type: number
    sql:  ${average_cpc}*1.00*sum(${clicks})*1.00 ;;
    value_format_name: decimal_2
  }
  measure: total_impressions {
    type: sum
    sql:  (${impressions})*1.00 ;;
  }
  measure: total_clicks {
    type: sum
    sql:  (${clicks})*1.00 ;;
  }
  measure: total_unique_clicks {
    type: sum
    sql:  (${unique_clicks})*1.00 ;;
  }
  measure: total_spend {
    type: sum
    sql:  (${spend})*1.00 ;;
    value_format_name: decimal_2
  }
  measure: total_reach {
    type: sum
    sql:  (${reach})*1.00 ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [
      _sdc_batched_at_time,
      _sdc_extracted_at_time,
      _sdc_received_at_time,
      _sdc_sequence,
      _sdc_table_version,
      account_id,
      account_name,
      ad_id,
      ad_name,
      adset_id,
      adset_name,
      campaign_id,
      campaign_name,
      clicks,
      cost_per_inline_link_click,
      cost_per_inline_post_engagement,
      cost_per_unique_click,
      cost_per_unique_inline_link_click,
      cpc,
      cpm,
      cpp,
      ctr,
      date_start_time,
      date_stop_time,
      frequency,
      impressions,
      inline_link_click_ctr,
      inline_link_clicks,
      inline_post_engagement,
      objective,
      reach,
      relevance_score__status,
      social_spend,
      spend,
      unique_clicks,
      unique_ctr,
      unique_inline_link_click_ctr,
      unique_inline_link_clicks,
      unique_link_clicks_ctr,
      relevance_score__score
    ]
  }
}
