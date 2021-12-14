## Prerequisites

Create the following files in `test/` directory:

- `test.tfvars` file with the values for integration tests
- `no_vpc_create.tfvars` which has all `*vpc*` variables removed.

### Install

```bash
go get ./...
```

### Run tests

```bash
go test -timeout 2h
```

### Notes

#### If something did not get destroyed after the tests:

See your temp dirs for the terraform state and destroy it manually.
(e.g., `<temp dir path>/region_us-east-123456789/quickstart-magento-terraform/examples/integration_test` and run `terraform destroy`)
