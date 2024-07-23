We should to initialize our S3 remote backend:

terraform init -backend-config="bucket=123terrabucket123" -backend-config="key=terraform.tfstate" -backend-config="region=eu-central-1"

Plan our resource creation:

terraform plan

And finally deploy infrastructure:

terraform apply -auto-approve

We could to copy Dockerfile in EC2 instance and run those commands or push already build image to some Docekr registry (Docker hub or Terraform ECR) and pull it on instance if we need to automate some routine manual steps

Or just run dicrectly on EC2 instance:

sudo docker build --build-arg ENV=dev -t my-node-app .

sudo docker run --name my-static-server -p 5000:5000 my-node-app

And finally we could destroy our small infrastructure if we need:

terraform init -backend-config="bucket=123terrabucket123" -backend-config="key=terraform.tfstate" -backend-config="region=eu-central-1"

terraform destroy -auto-approve

Done.
