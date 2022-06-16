# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
packer {
    required_plugins {
      windows-update = {
        version = "0.14.1"
        source = "github.com/rgl/windows-update"
      }
    }
  }

variable "ImageDestRG" {
  type    = string
  default = "My-Image-RG"
}

variable "ImageName" {
  type    = string
  default = "myPackerImage01"
}

variable "ImageOffer" {
  type    = string
  default = "office-365"
}

variable "ImagePublisher" {
  type    = string
  default = "MicrosoftWindowsDesktop"
}

variable "ImageSku" {
  type    = string
  default = "20h2-evd-o365pp"
}

variable "Location" {
  type    = string
  default = "EastUS"
}

variable "SIGDefName" {
  type    = string
  default = ""
}

variable "SIGName" {
  type    = string
  default = ""
}

variable "SIGRG" {
  type    = string
  default = ""
}

variable "StorageAccountInstallersKey" {
  type    = string
  default = " "
}

variable "StorageAccountInstallersName" {
  type    = string
  default = "storageaccountname"
}

variable "StorageAccountInstallersPath" {
  type    = string
  default = "\\\\storageaccountname.file.core.windows.net\\sharename"
}

variable "Subnet" {
  type    = string
  default = ""
}

variable "SubscriptionId" {
  type    = string
  default = "Azure Sub GUID"
}

variable "TempResourceGroup" {
  type    = string
  default = ""
}

variable "TenantId" {
  type    = string
  default = ""
}

variable "VMSize" {
  type    = string
  default = "Standard_D2_v2"
}

variable "VirtualNetwork" {
  type    = string
  default = ""
}

variable "VirtualNetworkRG" {
  type    = string
  default = ""
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "azure-arm" "autogenerated_1" {
  azure_tags = {
    dept = "WVD Labs"
    task = "Image deployment"
  }
  client_id                         = ""
  client_secret                     = ""
  communicator                      = "winrm"
  image_offer                       = "${var.ImageOffer}"
  image_publisher                   = "${var.ImagePublisher}"
  image_sku                         = "${var.ImageSku}"
  location                          = "${var.Location}"
  managed_image_name                = "${var.ImageName}"
  managed_image_resource_group_name = "${var.ImageDestRG}"
  os_type                           = "Windows"
  subscription_id                   = "${var.SubscriptionId}"
  tenant_id                         = ""
  vm_size                           = "${var.VMSize}"
  winrm_insecure                    = true
  winrm_timeout                     = "5m"
  winrm_use_ssl                     = true
  winrm_username                    = "packer"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "powershell" {
    inline = ["$ErrorActionPreference='Stop'", "Import-Module -Name Smbshare -Force -Scope Local", "$Usr='AzureAD\\'+\"${var.StorageAccountInstallersName}\"", "New-SmbMapping -LocalPath Z: -RemotePath \"${var.StorageAccountInstallersPath}\" -Username \"$Usr\" -Password \"${var.StorageAccountInstallersKey}\"", "Write-Host \"'Z:' drive mapped\""]
  }

  provisioner "powershell" {
    inline = ["Write-Host \"Optimizing VM for AVD\"", "Z:\\teams\\Install-TeamsWVD.ps1"]
  }

  provisioner "powershell" {
    inline = ["Write-Host \"Installing Teams\"", "Z:\\teams\\Install-TeamsWVD.ps1"]
  }

  provisioner "powershell" {
    inline = ["Write-Host \"Installing OneDrive\"", "Z:\\teams\\Install-TeamsWVD.ps1"]
  }

  provisioner "powershell" {
    inline = ["& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
  }

}