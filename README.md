# azure-vm-terraform-stack

# 🚀 Azure Windows VM Deployment with Terraform + File Share Integration

This repository provides a modular, production-ready Terraform configuration for deploying **Windows virtual machines** on Microsoft Azure. It includes secure networking, storage, diagnostics, and access mechanisms, with optional **Azure File Share mounting** and **snapshot/restore functionality**. Designed for clarity, reusability, and scalability, this setup is ideal for cloud engineers, DevOps professionals, and infrastructure-as-code enthusiasts seeking a clean, declarative workflow—from provisioning to teardown.

## 📦 Prerequisites

- Azure subscription
- Admin credentials stored in `terraform.tfvars`
- Terraform installed
- RDP client

---

## 🛠️ Deployment Steps

### 1. Log into Azure and Open Cloud Shell
- Go to [Azure Portal](https://portal.azure.com)
- Select the **Cloud Shell** icon (top-right)

### 2. Create Resource Group
```bash
az group create --resource-group terraformRGjlp --location eastus
```

### 3. Upload Terraform Files
- In Cloud Shell, select **Manage Files** → **Upload**
- Upload all `.tf` and `.tfvars` files
- Run `ls` to verify files are present

### 4. Initialize and Validate Terraform
```bash
terraform init
terraform validate
```

### 5. Plan and Apply Deployment
```bash
terraform plan -out main2tf.plan
terraform apply main2tf.plan
```

---

## 🖥️ Connect to the VM

1. In Azure Portal, go to **terraformvmjlp**
2. Select **Connect** → **Download RDP file**
3. Open the RDP file and log in using the password from `terraform.tfvars`
---

## 🔗 Mount Azure File Share

1. Go to **terrastorageaccountjlp** → **File Shares** → **vmfileshare**
2. Select **Connect** → **Show Script**
3. Copy the PowerShell script and run it inside the VM
4. Confirm `Z:` drive is mounted
---

## 📄 Test File Share + Snapshot

1. Upload a blank Notepad file named `filesharetestfile` to `vmfileshare`
2. Open it from `Z:` in the VM and type:  
   ```
   this is a test file
   ```
3. Save the file
4. In Azure Portal, go to **vmfileshare** → **Operations** → **Snapshots**
5. Select **+ Add snapshot** → **OK**

---

## 🔁 Modify and Restore File

1. Open `filesharetestfile` in VM and delete the text
2. Save the file
3. Add another snapshot
4. Restore the **oldest snapshot**:
   - Select snapshot → **Restore** → **Overwrite original file**
5. Confirm original content is restored in VM

---

## 🧹 Cleanup

### Unmount File Share in VM
```powershell
Remove-PSDrive -Name Z -Force
net use Z: /delete
cmd.exe /C "cmdkey /delete:terrastorageaccountjlp.file.core.windows.net"
```

### Delete Resource Group
```bash
az group delete --resource-group terraformRGjlp
```
---

## ✅ Outcome

- VM and file share deployed successfully
- File snapshot and restore validated
- All resources cleaned up

---
## 📁 File Structure

```
├── main2.tf
├── variables2.tf
├── terraform.tfvars
├── outputs2.tf
├── vm2.tf
├── storage2.tf
├── network2.tf
```


## 🔒 Security Notes

- Credentials are stored securely in `terraform.tfvars`
- File share access uses temporary credentials via `cmdkey`
- All resources are deleted post-validation

## 🧠 Author Notes

This setup is designed for clean, declarative infrastructure testing and teardown. Ideal for learning, demos, and reproducible environments.
