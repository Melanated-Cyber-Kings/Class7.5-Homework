resource "local_file" "favoritefood" {
  content  = "I love Jerk Chicken with Jollof!"
  filename = "${path.module}/Favorite Food.txt"
}