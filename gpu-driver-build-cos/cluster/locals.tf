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

// Built from:
//   gcloud compute accelerator-types list |grep nvidia-tesla- | grep -v vws | sort -k2 -r
locals {
  cluster_regions = {
    "us-west1"                = 0,  # The Dalles, Oregon, USA
    "us-west2"                = 1,  # Los Angeles, California, USA
    "us-central1"             = 2,  # Council Bluffs, Iowa, USA
    "us-east1"                = 3,  # Moncks Corner, South Carolina, USA
    "us-east4"                = 4,  # Ashburn, Northern Virginia, USA
    "northamerica-northeast1" = 5,  # Montréal, Québec, Canada
    "southamerica-east1"      = 6,  # Osasco (São Paulo), Brazil
    "europe-west1"            = 7,  # St. Ghislain, Belgium
    "europe-west2"            = 8,  # London, England, UK
    "europe-west4"            = 9,  # Eemshaven, Netherlands
    "asia-east1"              = 10, # Changhua County, Taiwan
    "asia-northeast1"         = 11, # Tokyo, Japan
    "asia-northeast3"         = 12, # Seoul, South Korea
    "asia-south1"             = 13, # Mumbai, India
    "asia-southeast1"         = 14, # Jurong West, Singapore
    "australia-southeast1"    = 15, # Sydney, Australia
  }

  cluster_region = regex("[a-z]+-[a-z]+[1-9]+", var.zone) 

  // Map of regions to zones that have accelerators available.
  cluster_node_zones = {
    "us-west1"                = ["us-west1-a"],
    "us-west2"                = ["us-west2-b"],
    "us-central1"             = ["us-central1-a"],
    "us-east1"                = ["us-east1-c"],
    "us-east4"                = ["us-east4-a"],
    "northamerica-northeast1" = ["northamerica-northeast1-a"],
    "southamerica-east1"      = ["southamerica-east1-c"],
    "europe-west1"            = ["europe-west1-b"],
    "europe-west2"            = ["europe-west2-a"],
    "europe-west4"            = ["europe-west4-b"],
    "asia-east1"              = ["asia-east1-a"],
    "asia-northeast1"         = ["asia-northeast1-a"],
    "asia-northeast3"         = ["asia-northeast3-b"],
    "asia-south1"             = ["asia-south1-a"],
    "asia-southeast1"         = ["asia-southeast1-b"],
    "australia-southeast1"    = ["australia-southeast1-a"],
  }

  accelerator_type_regions = {
    "us-west1"                = "nvidia-tesla-t4",
    "us-west2"                = "nvidia-tesla-p4",
    "us-central1"             = "nvidia-tesla-t4",
    "us-east1"                = "nvidia-tesla-t4",
    "us-east4"                = "nvidia-tesla-p4",
    "northamerica-northeast1" = "nvidia-tesla-p4",
    "southamerica-east1"      = "nvidia-tesla-t4",
    "europe-west1"            = "nvidia-tesla-p100",
    "europe-west2"            = "nvidia-tesla-t4",
    "europe-west4"            = "nvidia-tesla-t4",
    "asia-east1"              = "nvidia-tesla-p100",
    "asia-northeast1"         = "nvidia-tesla-t4",
    "asia-northeast3"         = "nvidia-tesla-t4",
    "asia-south1"             = "nvidia-tesla-t4",
    "asia-southeast1"         = "nvidia-tesla-t4",
    "australia-southeast1"    = "nvidia-tesla-p4",
  }
}