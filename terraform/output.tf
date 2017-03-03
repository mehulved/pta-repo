output "instance_ip" {
  value = "${google_compute_instance.pythonapp.network_interface.0.address}"
}
