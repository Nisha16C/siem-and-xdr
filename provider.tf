terraform {
  required_version = ">= 0.13"
  required_providers {
    cloudstack = {
      source  = "registry.terraform.io/cloudstack/cloudstack"
      version = "~> 0.4.0"
    }
  }
}


provider "cloudstack" {
  api_url      = "http://10.0.0.114:8080/client/api"
  api_key      = "jy8zQRHMk9ZExUfoXFxLYONREN8OSMCWXmcuJIQKad7ICAaxt65ONwRFZmNi2W3uIJyVUTbzzN2h3jriG-jQuQ"
  secret_key   = "Sv1Vjw-e7V6OaYQRyUIOGzdibZvpoabGKGI1fO1afO-3zm0Y-ANmTXxSnZTPwCWyIZ2pjHOE3xeRxdg9RqPSnQ"
}
