terraform {
  backend "s3" {
    bucket         = "noam-terraform-state-bucket" # השם של ה-Bucket שיצרת
    key            = "eks/terraform.tfstate"       # הנתיב בתוך ה-Bucket
    region         = "eu-central-1"                # ה-Region שבו נמצא ה-Bucket
    encrypt        = true                          # הצפנת הקובץ ב-S3 (חובה לאבטחה)
    # dynamodb_table = "terraform-lock-table"      # אופציונלי: מניעת הרצות כפולות
  }
}