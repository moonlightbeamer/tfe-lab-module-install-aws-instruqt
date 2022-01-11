output "tfe_url" {
  value = module.tfe.url
}

output "tfe_admin_console_url" {
  value = module.tfe.admin_console_url
}

output "tfe_admin_console_password" {
  value       = var.console_password
  description = "Password of TFE (Replicated) Admin Console."
}
