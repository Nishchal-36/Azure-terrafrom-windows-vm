locals {
  resource_location="North Europe"
  virtual_network={
    name="appynetwork"
    address_prefixes=["10.0.0.0/16"]
  }
  subnet_address_prefix=["10.0.0.0/24","10.0.1.0/24"]
  subnets=[
    {
        name="Anky"
        address_prefixes=["10.0.0.0/24"]
    },
    {
        name="Andy"
        address_prefixes=["10.0.1.0/24"]
    }
  ]
}
