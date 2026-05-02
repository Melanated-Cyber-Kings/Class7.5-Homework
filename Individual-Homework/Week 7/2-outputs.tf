output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.week7hw-food.name

}


output "favorite_food" {
  description = "Output showing my favorite food"
  
  value = file("./food.txt")
}