# Create and Host a static website on AWS s3 with Terraform

# Step by Step guidelines 
- Full tutorial on my [dev.to/ashraf-minhaj](https://dev.to/ashraf-minha) blog post, [click here](https://dev.to/ashraf-minhaj/static-website-on-s3-using-terraform-16e4). Enjoy.

# Steps
- clone this repository
- add all website related files in the 'app' directory
- run `terraform init`, `terraform apply`

# How to apply
 open the Terraform directory and run these commands -
* Init first 
 ```
 terraform init
 ```
* After that, plan to see all the changes 
 ```
 terraform plan
 ```
* Finally, apply and make it happen on AWS
 ```
 terraform apply
 ```
 if you want to auto approve without manual approval, then -
 ```
 terraform apply -auto-approve
 ```

> make sure to destroy after playing around with 'terraform destroy

## Reference(s)
* [upload with mime type](https://engineering.statefarm.com/blog/terraform-s3-upload-with-mime/)
* From stackoverflow [this](https://stackoverflow.com/questions/76419099/access-denied-when-creating-s3-bucket-acl-s3-policy-using-terraform), and [this](https://stackoverflow.com/questions/18296875/amazon-s3-downloads-index-html-instead-of-serving)

## License

General Public License

**Free Software, Hell Yeah!**

