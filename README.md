# Azure Terraform Catalog

Reusable Terraform modules and GitHub Actions workflows for governed Azure provisioning.

## Supported templates

- resource-group
- vm-linux
- storage-account
- aks

## Backend

Use Azure Blob Storage for remote state via `backend.hcl`.

## GitHub Actions

- validate.yml
- plan.yml
- apply-manual.yml
- drift.yml