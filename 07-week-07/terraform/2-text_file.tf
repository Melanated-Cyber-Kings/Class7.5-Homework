resource "local_file" "foo" {
  content  = "Steak"
  filename = "${path.module}/favorite_food.txt"
}