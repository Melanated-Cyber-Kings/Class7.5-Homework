 resource "google_compute_instance" "vm" {
   name         = "wk8-hw-vm"
   machine_type = "n2-standard-2"
   zone         = "us-central1-a"

   # Create a new disk from an image and set as boot disk
   boot_disk {
     initialize_params {
       image = "centos-cloud/centos-stream-10" 
       size  = 100
     }
   }

   # Network Configurations 
   network_interface {
     subnetwork = google_compute_subnetwork.hqinternal.name
     access_config {
       
     }
   }

   metadata_startup_script = file("${path.module}/../startup.sh")

   tags = ["http-server"]

 }