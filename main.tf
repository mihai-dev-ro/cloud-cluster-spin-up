# configure the authentication credentials for 
# accessing the provider of the cloud resources
provider "scaleway" {
    access_key      = var.provider_access_key
    secret_key      = var.provider_secret_key
    organization_id = var.organization_id
    region          = "nl-ams"
    zone            = "nl-ams-1"    
}