// ******
// Exptected parameters for HTTP request to pipeline
// ******
//deployment="client01"
//vm_images_rg="vm-images-RG"
//vmss_rg="vmss_RG"
//image_name="vmimage01"
//vmss_name="testvmss"
//location="northeurope"

podTemplate(label: 'azurevm', containers: [
    containerTemplate(name: 'terraform-az', image: 'demosiniestrosregistrys.azurecr.io/terraform-az', ttyEnabled: true, command: 'cat',envVars: [
       secretEnvVar(key: 'ARM_CLIENT_ID', secretName: 'mysecret', secretKey: 'clientid'),
       secretEnvVar(key: 'ARM_CLIENT_SECRET', secretName: 'mysecret', secretKey: 'clientsecret'),
       secretEnvVar(key: 'ARM_TENANT_ID', secretName: 'mysecret', secretKey: 'tenantid'),
       secretEnvVar(key: 'ARM_SUBSCRIPTION_ID', secretName: 'mysecret', secretKey: 'subscriptionid')
        ]),
  ])   
{
    node('azurevm') {
        def gitRepo = 'https://github.com/diegoSoteloEstupinan24/kubernetes'
        currentBuild.result = "SUCCESS"
        try {
            stage('Checkout'){
                container('terraform-az') {
                    // Get the terraform plan
                    git url: gitRepo, branch: 'master'
                }
            }
            stage('Terraform init'){
                container('terraform-az') {
                    // Initialize the plan 
                    sh  """
                        terraform init -input=false
                    """
                }
            }
            stage('Terraform plan'){
                container('terraform-az') {  
                    
                    sh  """
                        terraform plan -out=tfplan -input=false -var-file='variables/variables.tfvars'
                    """
                }
            }
        
            stage('Terraform apply'){
                container('terraform-az') {
                    // Apply the plan
                    sh  """  
                        terraform apply -input=false tfplan
                    """
                }
            }
        }
        catch (err) {
            currentBuild.result = "FAILURE"
            throw err
        }
    }
}
