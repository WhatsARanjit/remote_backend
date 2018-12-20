# Random number generator
resource "random_id" "random" {
  keepers {
    uuid = "${uuid()}"
  }

  byte_length = 8
}

# Dummy resource with attributes
resource "null_resource" "test" {
  provisioner "local-exec" {
    command = "echo '${random_id.random.dec}'"
  }
}

# Output random number
output "random_number" {
  value = "${random_id.random.dec}"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "clever_idea" {
  bucket = "catch_me"
  acl    = "private"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
