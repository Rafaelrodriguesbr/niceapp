

#### answer_1 ####
output "answer_1" {
  value = "${
    formatlist(
      "Vulnerability report available in ≅10 minutes in bucket (vulerability-reportniceapp-2019) :::::: %s ",
      aws_s3_bucket.bucket_report.arn ,   
    )}"

}

## answer_2 ####
output "answer_2" {
  value = "${
    formatlist(
      "Web Application Deploy on ELB :::::: %s:8080/ ",
      aws_elb.elb-web.dns_name      
    )}"

}
## answer_2.1 ####
output "answer_2-1" {
  value = "${
    formatlist(
      "API Application Deploy on ELB :::::: %s:5000/ ",
     aws_elb.elb-web.dns_name 
    )}"

}

## answer_3 ####
output "answer_3" {
  value = "${
    formatlist(
      "Log structure available at:::::: (cloudtraill-niceapp) ARN :::::: %s",
      aws_s3_bucket.traill.arn,
      
    )}"

}

output "answer_3-1" {
  value = "${
    formatlist(
      "AWS Config Enabled - To view configuration changes history for all resources in the account:::::: https://console.aws.amazon.com/config/home?region=us-east-1#/welcome",
           
    )}"

}

