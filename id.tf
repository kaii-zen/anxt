resource "random_id" "this" {
  byte_length = 8
}

resource "random_pet" "this" {
  keepers = {
    id = "${local.id}"
  }
}
