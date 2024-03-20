# Random number generator
resource "random_id" "random" {
  keepers {
    uuid = "${uuid()}"
  }
  byte_length = 8
}

# Dummy resource with attributes
resource "null_resource" "test" {
  count = 3
  provisioner "local-exec" {
    command = "echo '${random_id.random.dec}'"
  }
}

# Output random number
output "random_number" {
  value = "${random_id.random.dec}"
}

# Dummy data source
#data "null_data_source" "test" {
#  inputs = {
#    hex = "${random_id.random.hex}"
#  }
#}
