# azure-vm-terraform-stack

# 🚀 Azure Windows VM Deployment with Terraform

This repository contains a modular and production-ready Terraform configuration for deploying **Windows virtual machines** on Microsoft Azure. It provisions secure networking, storage, diagnostics, and access mechanisms, with optional Azure File Share mounting and boot diagnostics. Designed for clarity, reusability, and scalability, this setup is ideal for cloud engineers, DevOps professionals, and infrastructure-as-code enthusiasts.

---

## 📁 Repository Structure

| File Name         | Purpose                                                                 |
|-------------------|-------------------------------------------------------------------------|
| `main2.tf`        | Orchestrates core resource dependencies and VM provisioning             |
| `variable2.tf`    | Defines input variables with defaults and validation rules              |
| `providers2.tf`   | Specifies provider version and optional remote state backend            |
| `output2.tf`      | Exposes VM metadata, IPs, storage info, and connection details          |
| `network2.tf`     | Provisions NSG, NIC, public IP, and associates security rules           |
| `vm2.tf`          | Deploys Windows VM and mounts Azure File Share via VM extension         |
| `README.md`       | Documentation for setup, usage, and architecture                        |

---

## 🧠 Key Features

### 🔐 Secure Access
- Password-based authentication for Windows VMs
- Sensitive credentials are securely handled and excluded from logs

### 🛡️ Network Security
- NSG rules for RDP (3389), HTTP (80), SMB (445), and outbound internet
- NIC-to-NSG association ensures traffic control at the interface level

### 📦 Storage Integration
- Azure File Share mounted to Windows VM as drive `Z:` using PowerShell
- Optional diagnostics storage account for boot logs and troubleshooting

### 🧩 Modular & Reusable
- Parameterized variables for environment, location, VM size, and tags
- Conditional resource creation (e.g., diagnostics) using `count` logic
- Clean separation of concerns across files for scalability and clarity

### 📤 Rich Outputs
- Public and private IPs
- VM metadata and storage identifiers
- Centralized tag output for auditing and cost tracking

---

## 🔧 Configuration Overview

All input variables are defined in [`variable2.tf`](variable2.tf). You can customize your deployment by:

- Editing default values directly in `variable2.tf`
- Overriding variables via CLI:
  ```bash
  terraform apply -var="vm_name=vm-terraformjlp" -var="location=East US"
  ```
- Or using environment variables:
  ```bash
  export TF_VAR_vm_name="vm-terraformjlp"
  export TF_VAR_location="East US"
  ```

### Example Variable Definitions

```hcl
vm_name               = "vm-terraformjlp"
location              = "East US"
vm_size               = "Standard_DS1_v2"
admin_username        = "azureuser"
admin_password        = "SecureP@ssw0rd!"
diagnostics_enabled   = true
tags = {
  environment = "dev"
  owner       = "joshua"
}
```

---

## 🚀 Deployment Instructions

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Validate Configuration**
   ```bash
   terraform validate
   ```

3. **Preview Changes**
   ```bash
   terraform plan
   ```

4. **Apply Infrastructure**
   ```bash
   terraform apply
   ```

5. **Connect to the VM**
   Use Remote Desktop (RDP) with the public IP and credentials:
   - Username: `azureuser`
   - Password: `SecureP@ssw0rd!`
   - IP: Output from `vm_public_ip`

---

## 📌 Notes & Best Practices

- 🔒 **Security**: Never commit sensitive credentials to version control. Use `.gitignore` to exclude secrets and `.terraform` directories.
- 📊 **Diagnostics**: Boot diagnostics are optional and require a storage account. Enable via `diagnostics_enabled = true`.
- 📁 **File Share Mounting**: Ensure outbound port 445 is allowed for SMB traffic. The share is mounted as drive `Z:` on the VM.
- 🧼 **Cleanup**: Use `terraform destroy` to remove all resources when no longer needed.

---

## 🧹 Cleanup

To destroy all resources and release associated Azure costs:

```bash
terraform destroy
```

---

## 📚 License & Contributions

This project is open for contributions. Feel free to fork, improve, or submit issues.

Licensed under the [MIT License](LICENSE).

---

## 🙌 Acknowledgments

Built with ❤️ by Joshua — cloud engineer, infrastructure-as-code advocate, and lifelong learner.  
Special thanks to the Terraform and Azure communities for their documentation and tooling.

---

## 🧭 Next Steps

Want to take this further?

- Add a visual architecture diagram using [draw.io](https://draw.io) or [Diagrams.net](https://www.diagrams.net/)
- Integrate with GitHub Actions for CI/CD deployment
- Split into reusable modules for multi-environment provisioning
- Add Azure Key Vault integration for secret management
- Extend with auto-scaling, monitoring, or domain join features

