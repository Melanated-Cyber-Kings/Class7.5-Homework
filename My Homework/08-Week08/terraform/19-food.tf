# Create a local file with your favorite food
resource "local_file" "favorite_food" {
  # Newline character is added to the end of the content to ensure that the file ends
  #  with a newline, which is a common convention for text files. 
  # So when you open the file with a command like `cat`, the output will
  #  be displayed correctly without any formatting issues.
  content  = "${var.favorite_food}\n"
  filename = "${path.module}/favorite_food.txt"
}