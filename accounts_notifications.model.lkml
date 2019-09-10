connection: "redshift"

# include all views in this project
include: "*.view"


# include all dashboards in this project
datagroup: status_alert {
sql_trigger: WITH account_notifications AS (select
      bae.account_id
      ,bae.account_status
      ,bae.user_id
      ,u.email
      ,max(bae.timestamp) as last_event_time
      from prod.bd_account_event as bae
      left join prod.users as u on u.id=bae.user_id
      where  bae.account_id in (select account_id from prod.bd_account_event where account_status = 'rejected' or account_status = 'indeterminate')
      and bae.account_id not in (select account_id from prod.bd_account_event where account_status = 'approved')
      group by bae.account_id, bae.account_status, bae.user_id, u.email
      order by last_event_time desc
       )
SELECT
  ((COUNT(CASE WHEN (account_notifications.account_status = 'rejected') THEN 1 ELSE NULL END))+12793)
  /(COUNT(CASE WHEN (account_notifications.account_status = 'indeterminate') THEN 1 ELSE NULL END))  AS "account_notifications.status_ratio"
FROM account_notifications

LIMIT 500;;
}




explore: account_notifications {
  view_label: "accounts_notifications"
  label: "accounts_notifications"

}
