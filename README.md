# Terraform Module - AWS VPC

This will deploy a simple VPC Setup on AWS.

## Features
- AWS VPC Resource Creation :laughing:

## Dependencies
- This module depends on the TF Module `@darvein/tf-tags`

## TODOS
- [DONE] VPC resource
- Subnets
    - Public, Private, Internal
    - Routes
    - IGW, NATGW
        - Evaluate Single NATGW and Multiple NATGWs
- NACls
- Default SGs
- Internal Subnets
- VPC Endpoints (s3, rds, ssm, etc)
- VCP logs (cloudwatch, s3, firehose)
- Cloudwatch Alarms?
- Traffic mirroring?
- DNS, DHCP
- Peering?, TGW, Direct Connect?
- VPN?
- ipv6?
- VPC Sharing VPC?
- Tests with terratest?
- CI/CD
- Documentation
- Examples
