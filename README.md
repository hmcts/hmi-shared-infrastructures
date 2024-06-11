# hmi-shared-infrastructures

This repository contains the shared common infrastructure per environment for HMI.

- Azure Key Vault
- Azure Storage Account
- Azure APIM Certificate.

### Azure Key Vault
Azure keyvault contains different keyvaults. There is one keyvault which will contains all the secrets which are being used by HMI SDS APIM. It also contains SAS tokens which are being used by ROTA.
There are other keyvaults which are specific to each consumer like SNL. These secrets are being used by each service to connect with HMI SDS APIM. We are not using these keyvaults anywhere in our APIM code.

### Azure Storage Account
We have a code which can generate the SAS token which can be used by ROTA to connect with Azure blob storage

### Azure APIM Certificate
We have a code which can install the Certificate on SDS APIM. For the time being, Certificate is only being used by Crime.