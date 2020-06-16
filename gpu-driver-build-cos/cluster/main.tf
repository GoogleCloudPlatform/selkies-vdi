/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
provider "google" {
  region  = local.cluster_region
}

provider "google-beta" {
  region  = local.cluster_region
}


resource "google_container_cluster" "build" {
  provider = google-beta

  project                  = var.project_id
  release_channel {
    channel = "REGULAR"
  }
  name                     = "${var.name}-${var.zone}"
  location                 = var.zone
  network                  = google_compute_network.build.name
  subnetwork               = google_compute_subnetwork.build.name
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "172.${16 + lookup(local.cluster_regions, local.cluster_region)}.0.0/16"
    services_ipv4_cidr_block = "192.168.${lookup(local.cluster_regions, local.cluster_region)}.0/24"
  }

  //create_service_account   = false
  //service_account          = length(var.service_account) == 0 ? "broker@${var.project_id}.iam.gserviceaccount.com" : var.service_account

  initial_node_count = 1

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  node_config {
    preemptible  = true
    machine_type = var.default_pool_machine_type

    //service_account = data.google_service_account.broker_cluster.email

    disk_size_gb = var.default_pool_disk_size_gb
    disk_type    = "pd-ssd"

    image_type = "COS"

    guest_accelerator {
      count = 1
      type  = length(var.default_pool_accelerator_type) == 0 ? lookup(local.accelerator_type_regions, local.cluster_region) : var.default_pool_accelerator_type
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      # updated by node init daemonset when finished.
      "app.broker/initialized" = "false"

      # Used to set pod affinity
      "app.broker/tier" = "gpu-cos"

      # updated by gpu driver installer to true when finished.
      "cloud.google.com/gke-accelerator-initialized" = "false"
    }

    workload_metadata_config {
      node_metadata            = "GKE_METADATA_SERVER"
    }

  }


}
