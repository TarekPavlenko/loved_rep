connection: "redshift"

# include all views in this project
include: "*.view"

# include all dashboards in this project

explore: accounts_number_evolution {
  hidden: yes
  view_label: "accounts_number_evolution"
  label: "accounts_number_evolution"

}
