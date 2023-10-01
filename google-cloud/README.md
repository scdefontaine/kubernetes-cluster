# kube-cluster


# Setup
  - Create project level service account for terraform deployment and grant Basic Editor role
  - Create and download keys for newly created service account
  - Update the .zshrc (Mac), .bashrc (Linux), or add to environment variables (Windows)
    ```
      GOOGLE_APPLICATION_CREDENTIALS = '$HOME/.gcp/keys/project/service-account-keys.json'
    ```

# Deployment
  - Navigate to scripts folder
  ```
    cd scripts
  ```

  - Deploy the cluster using terraform
  ```
    sh create.sh
  ```

  - Initialize the proxy tunnel from localhost to the cluster
  ```
    sh proxy.sh
  ```

