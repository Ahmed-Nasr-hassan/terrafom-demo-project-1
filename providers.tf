provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files = ["~/.aws/config"]
  region = "us-east-1"
}
