connection: "redshift"

# include all views in this project
include: "*.view"

# include all dashboards in this project

explore: bank_accounts_number {
  view_label: "accounts_number_evolution"
  label: "bank_accounts_number"

}
