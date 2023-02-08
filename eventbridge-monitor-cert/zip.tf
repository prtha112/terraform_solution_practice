data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./${var.localfile_name}"
  output_path = "./${var.localfile_name}.zip"
}