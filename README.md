# terraform-route53-ddns-updater

Make yourself a little DDNS service with the power of amazon route53 and terraform

## How it works

This little terraform script looks up your current external IP address from https://icanhazip.com and sets it to the route53 record of your choice. Just throw it in a scheduled task and you have a DDNS service.

## Setup

### IAM

Find the route53 zone_id for the zone in question. You'll need this in two places. First, for the IAM policy. Create a new one that looks like this, but substitute `ZONE_ID` with yours.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:ListHostedZones",
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "arn:aws:route53:::hostedzone/ZONE_ID"
        }
    ]
}
```

Attach the new policy to an IAM user, and make sure you have the credentials on hand, because you'll need them for the configuration in the next step.

### Terraform variables

Copy variables.tfvars.json.example to variables.tfvars.json.

Replace all the values. `aws_access_key`, `aws_secret_key`, and `zone_id` you should have on hand from the last step. `domain_name` is the address that you want to use for DDNS. Note that the domain name needs to be a subdomain (or equal to, as in the root record) of the zone that you've selected with the zone id.

### Try it out

Use these commands to see if your configuration is set up properly:

```bash
terraform init -get=true -get-plugins=true -upgrade=true
terraform plan -var-file variables.tfvars.json
```

### Add a scheduled task

If everything looks good, you'll want to run `terraform apply -var-file variables.tfvars.json -auto-approve` with your operating system's scheduler.

* Windows: https://superuser.com/a/403597/173153 in combination with the provided batch file: [apply.bat](apply.bat)
	* TODO: If anyone knows how to make this log somewhere useful on windows, let me know or submit a pull request
* UNIX: Add something like this to your crontab `*/5 * * * * /home/user/terraform-route53-ddns-updater/apply.sh`
