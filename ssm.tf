resource "aws_ssm_document" "nixos_rebuild_switch" {
  name          = "${local.name_CamelCase}-${local.pet_CamelCase}-NixOS-RebuildSwitch"
  document_type = "Command"
  content       = "${file("${path.module}/ssm.json")}"
}

resource "aws_ssm_association" "nixos_rebuild_switch" {
  name                = "${aws_ssm_document.nixos_rebuild_switch.name}"
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "tag:ssm-path"
    values = ["${local.ssm_path}"]
  }
}
