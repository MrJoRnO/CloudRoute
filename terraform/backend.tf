terraform {
  backend "s3" {
    bucket         = "noam-terraform-state-bucket-v3" # השם של ה-Bucket שיצרת
    key            = "eks/terraform.tfstate"       # הנתיב בתוך ה-Bucket
    region         = "eu-central-1"                # ה-Region שבו נמצא ה-Bucket
    encrypt        = true                          # הצפנת הקובץ ב-S3 (חובה לאבטחה)
    # dynamodb_table = "terraform-lock-table"      # אופציונלי: מניעת הרצות כפולות
  }
}
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = "noam-terraform-state-bucket-v3" # השם של הבאקט שלך
  versioning_configuration {
    status = "Enabled"
  }
}

# אופציונלי: חסימת גישה ציבורית (אבטחה חשובה לסטייט!)
resource "aws_s3_bucket_public_access_block" "state_security" {
  bucket = "noam-terraform-state-bucket-v3"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}