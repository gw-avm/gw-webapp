locals {
  # The platform's central privatelink.postgres.database.azure.com zone. Built
  # from a secret subscription ID so the ID isn't kept in this public repo.
  postgres_private_dns_zone_id = coalesce(var.postgres_private_dns_zone_id, "/subscriptions/${var.connectivity_subscription_id}/resourceGroups/rg-connectivity-dns-prod-eastasia-001/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com")

  # CAF: <type>-<workload>-<component>-<environment>-<region>-<###>,
  # e.g. rg-webapp-nonprod-eastasia-001, vm-webapp-api-nonprod-eastasia-001
  suffix = "${var.environment}-${var.location}-001"

  tags = var.tags
}

data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet.name
  resource_group_name = var.spoke_vnet.resource_group_name
}

resource "azurerm_resource_group" "app" {
  name     = "rg-${var.app_name}-${local.suffix}"
  location = var.location
  tags     = local.tags
}
