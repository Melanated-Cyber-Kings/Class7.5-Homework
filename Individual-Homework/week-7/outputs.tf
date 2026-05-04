output "url" {
  value       = "https://storage.googleapis.com/${google_storage_bucket.static-site.name}/index.html"
  description = "The public URL of our static website"
}