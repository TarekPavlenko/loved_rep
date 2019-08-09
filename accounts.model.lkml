connection: "redshift"

# include all views in this project
include: "*.view"

# include all dashboards in this project

explore: accounts_redshift {
  view_label: "accounts_redshift"
  label: "accounts_redshift"

}
