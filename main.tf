resource "azurerm_resource_group" "example" {
    name     = "rg-cosmosdb-example"
    location = "East US"
}

resource "azurerm_cosmosdb_account" "example" {
    name                = "cosmos-db-account-example"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    offer_type          = "Standard"
    kind                = "GlobalDocumentDB"

    consistency_policy {
        consistency_level = "Session"
    }

    geo_location {
        location          = azurerm_resource_group.example.location
        failover_priority = 0
    }
}

resource "azurerm_cosmosdb_sql_database" "example" {
    name                = "example-db"
    resource_group_name = azurerm_resource_group.example.name
    account_name        = azurerm_cosmosdb_account.example.name
}

resource "azurerm_cosmosdb_sql_container" "example" {
    name                = "example-container"
    resource_group_name = azurerm_resource_group.example.name
    account_name        = azurerm_cosmosdb_account.example.name
    database_name       = azurerm_cosmosdb_sql_database.example.name
    partition_key_path  = "/id"
}