variable "iam_path" {}
variable "function_name" {} 
variable "event_schedule_cron" {}
variable "access_policy" {}
variable "log_retention" {}
variable "placeholder" { 
    type    = string
    default = "Change" 
} 
variable "application_language" {} 
variable "path_to_zip" {} 
variable "permissions_boundary" {} 
variable "policy_name" {}
variable "cloudwatch_name" {}
variable "role_name" {}
variable "path_to_layer" {
    type    = list(string)
    default = []

}
variable "project" {}
variable "environment" {}
variable "environment_variables" {
    type    = map(string)
    default = {}
}