package test

import (
  "fmt"
  "testing"
  "time"

  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestWebserverClusterValidation(t *testing.T) {
  uniqueID := time.Now().Unix()

  terraformOptions := &terraform.Options{
    TerraformDir: "../modules/services/webserver-cluster",
    Vars: map[string]interface{}{
      "cluster_name":  fmt.Sprintf("test-%d", uniqueID),
      "instance_type": "t2.micro",
      "min_size":      1,
      "max_size":      2,
      "environment":   "dev",
      "vpc_id":        "vpc-027dd13e0c66a0a61",
      "subnet_ids": []string{
        "subnet-0b5f0957bcd16a351",
        "subnet-09e74ac0f265e2afe",
      },
    },
    NoColor: true,
  }

  defer terraform.DestroyE(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)

  albDNS := terraform.Output(t, terraformOptions, "alb_dns_name")
  if albDNS == "" {
    t.Fatal("expected non-empty alb_dns_name output")
  }
}