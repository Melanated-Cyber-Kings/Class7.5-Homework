resource "google_storage_bucket" "static-site" {
  name          = "class-7-5-hw-week7"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  
}


data "google_iam_policy" "admin" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.static-site.name
  policy_data = data.google_iam_policy.admin.policy_data
  timeouts {
    create = "5m"
  }
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  source = "./html/index.html"
  bucket = google_storage_bucket.static-site.name
}

resource "google_storage_bucket_object" "error" {
  name   = "404.html"
  source = "./html/404.html"
  bucket = google_storage_bucket.static-site.name
}

resource "google_storage_bucket_object" "css" {
  name   = "style.css"
  source = "./html/style.css"
  bucket = google_storage_bucket.static-site.name
}

resource "google_storage_bucket_object" "picture" {
  name   = "image.jpg"
  source = "./html/image.jpg"
  bucket = google_storage_bucket.static-site.name
}