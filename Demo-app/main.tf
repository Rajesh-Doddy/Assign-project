terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

resource "google_container_cluster" "gke_cluster" {
  name     = "my-cluster"
  location = "us-central1-a"  

  initial_node_count = 1  # Start with 2 nodes for initial scalability

  node_config {  
    machine_type = "e2-medium"  
    disk_size_gb = 20          
  }
}



resource "google_container_node_pool" "scaling_pool" {
  cluster  = google_container_cluster.gke_cluster.name
  location = google_container_cluster.gke_cluster.location

  name             = "scaling-node-pool"
  initial_node_count = 0  # Start with 0 nodes in the scaling pool



  autoscaling {
    min_node_count = 1    # Minimum number of nodes in the pool
    max_node_count = 5    # Maximum number of nodes in the pool (adjust based on needs)
  } 
    
  node_config {
    machine_type = "e2-medium"  
    disk_size_gb = 20          
    disk_type    = "pd-standard"  
 }


}