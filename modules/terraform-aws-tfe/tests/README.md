# Deployment Scenarios
Below is a table of the different configurations that would encompass a _deployment scenario_ encountered in production environments.

| Configuration                   | Options    | Options Description                                            |
|---------------------------------|------------|----------------------------------------------------------------|
| Load Balancer Type              | alb, nlb   | Application Load Balancer (alb) or Network Load Balancer (nlb) |
| Load Balancer Scheme (exposure) | ext, int   | External (ext) or Internal (int)                               |
| DNS service                     | r53, other | Route53 (r53) or Other (other)                                 |
| TLS/SSL Certificate service     | acm, cust  | AWS Certificate Manager (acm) or Custom (cust)                 |
| Installation Method             | ol, ag     | Online (ol) or Airgap (ag)                                     |

\
Here is the naming convention for the deployment scenarios:\
`<Load Balancer Type>-<Load Balancer Scheme>-<DNS>-<TLS/SSL>-<Installation Method>`


## ALB Scenarios
Listed below are deployment scenarios leveraging the AWS Application Load Balancer (ALB). NOTE: in the ALB deployment scenarios, `acm` is the only option for the TLS/SSL certificate service as the ALB HTTPS listeners must be configured with a cert at the time of creation via Terraform (the cert can be created by ACM on the fly or imported into ACM as a prereq and then referenced by ARN - both options are supported).

- [alb-ext-r53-acm-ol](./alb-ext-r53-acm-ol)
- alb-ext-r53-acm-ag

- alb-ext-other-acm-ol
- alb-ext-other-acm-ag

- alb-int-r53-acm-ol
- alb-int-r53-acm-ag

- alb-int-other-acm-ol
- alb-int-other-acm-ag

## NLB Scenarios
Listed below are deployment scenarios leveraging the AWS Network Load Balancer (NLB). NOTE: Custom (`cust`) is the only option for the TLS/SSL certificate service as the load balancer is operating at layer 4 and doing TLS-passthrough so the certificate files need to be on the instance, and ACM does not support the retrieval of the certificate files once the cert is created or imported.

- nlb-ext-r53-cust-ol
- nlb-ext-r53-cust-ag

- nlb-ext-other-cust-ol
- nlb-ext-other-cust-ag

- nlb-int-r53-cust-ol
- [nlb-int-r53-cust-ag](./nlb-int-r53-cust-ag)

- nlb-int-other-cust-ol
- nlb-int-other-cust-ag
