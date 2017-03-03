provider "google" {
        credentials = "${file("../rootconf_account.json")}"
        region      = "${var.region}"
        project     = "${var.project_name}"
}

resource "google_compute_network" "pythonapp" {
        name = "pythonapp"
}

resource "google_compute_subnetwork" "asia-east1" {
        name          = "asia-east1"
        ip_cidr_range = "192.168.1.0/24"
        network       = "${google_compute_network.pythonapp.self_link}"
        region        = "${var.region}"
}

resource "google_compute_instance" "pythonapp" {
        name         = "pythonapp"
        machine_type = "f1-micro"
        zone         = "${var.region_zone}"

        tags = ["python","http-server"]

        disk {
                image = "pythonapp"
        }

        network_interface {
                subnetwork = "${google_compute_subnetwork.asia-east1.name}"
                access_config {
                        // Ephemeral IP
                }
        }

        service_account {
        scopes = ["compute-rw"]
        }
}

resource "google_compute_firewall" "allow-http" {
        name = "allow-http"
        network = "${google_compute_network.pythonapp.name}"

        allow {
                protocol = "tcp"
                ports    = ["80"]
        }

        target_tags = ["http-server"]
}
