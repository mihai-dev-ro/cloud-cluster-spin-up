output "masters_ip" {
  value = "${module.dcos001.internal_ip}"#,${module.dcos002.internal_ip},${module.dcos003.internal_ip}"
}

output "public_agents_ip" {
  value = "${module.dcos101.internal_ip}"
}

output "private_agents_ip" {
  value = "${module.dcos201.internal_ip}"#,${module.dcos202.internal_ip},${module.dcos203.internal_ip}"
}