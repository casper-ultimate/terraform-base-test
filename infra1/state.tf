# terraform {
#   backend "s3" {
#     bucket  = "my-terraform-state-bucket-a-rwerwerwe"
#     dynamodb_table = "terraform-state-lock-dynamo"
#     key     = "terraform.tfstate"
#     region  = "us-east-1"
#     encrypt = true    
#   }
# }