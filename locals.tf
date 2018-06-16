locals {
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  ]

  name_kebab           = "${replace(var.display_name, " ", "-")}"
  name_kebab_lowercase = "${lower(local.name_kebab)}"
  name_CamelCase       = "${replace(title(var.display_name), " ", "")}"
  name                 = "${local.name_kebab_lowercase}-${local.pet}"

  pet           = "${random_pet.this.id}"
  pet_title     = "${title(replace(local.pet, "-", " "))}"
  pet_CamelCase = "${replace(local.pet_title, " ", "")}"

  id                = "${random_id.this.id}"
  bootstrap_nix_key = "${aws_s3_bucket_object.bootstrap_nix.key}"
  user_nix_key      = "${aws_s3_bucket_object.user_nix.key}"
  s3_prefix         = "${var.s3_prefix}/${local.name}"
}
