resource "azurerm_resource_group" "main" {
    name     = "rg-cosmosdb-main"
    location = "East US"
}

resource "azurerm_cosmosdb_account" "main" {
    name                = "${var.cosmosdb_name}"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    offer_type          = "Standard"
    kind                = "GlobalDocumentDB"

    consistency_policy {
        consistency_level = "Session"
    }

    geo_location {
        location          = azurerm_resource_group.main.location
        failover_priority = 0
    }
}

resource "azurerm_cosmosdb_sql_database" "main" {
    name                = "main-db"
    resource_group_name = azurerm_resource_group.main.name
    account_name        = azurerm_cosmosdb_account.main.name
}

resource "azurerm_cosmosdb_sql_container" "main" {
    name                = "main-container"
    resource_group_name = azurerm_resource_group.main.name
    account_name        = azurerm_cosmosdb_account.main.name
    database_name       = azurerm_cosmosdb_sql_database.main.name
    partition_key_path  = "/id"
}