# Jack_Challenge
Repo for Comcast Challenge

Runs on AWS Free Tier

Steps to start project:
1. "cd terraform/"
2. "aws configure"
    - AWS Access Key ID: {aws_access_key}
    - AWS Secret Access Key : {secrect_key}
    - Default region name: us-east-1 (if using a different region must update line 39 of main_test.go)
    - Deafult output format: json
3. "terraform init"
4. "terraform plan"
5. "terraform apply"

To tear down project: "terraform destroy"


To run automated tests:
1. cd test
2. "go test" or "go test -v -run TestTerraform -timeout 20m"
    - -timeout defaults to 10 minutes, which should be enough, but can be adjusted if needed