resource "local_file" "food" {
  content  = "My favorite food is Vietnamese Pho"
  filename = "${path.module}/favoritefood.txt"
}