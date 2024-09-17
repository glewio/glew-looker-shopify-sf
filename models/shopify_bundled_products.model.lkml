connection: "silo_routing"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: shopify_often_bundled_product {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Bundled Products"
  group_label: "Shopify"
  # description: "View/Report on your Shopify product data including product tags and categories with this explore"
}
