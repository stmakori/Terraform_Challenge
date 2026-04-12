#!/bin/bash

terraform init
terraform plan -out=day20.tfplan
terraform apply day20.tfplan
