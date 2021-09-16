# Deploy an AWS EKS cluster with Enforcer

These Terraform templates will deploy an AWS EKS cluster with Enforcer installed and connected to the Prisma Cloud Console.



## Prequisites:
1. Create a new microsegmentation namespace

2. Create a cloud auto-registration policy on Prisma Cloud Console
    - Navigate to the namespace where you will deploy the Enforcer
    - Go to Network Security -> Namespaces -> Authorizations
    - click on the "+" sign and create a cloud auto-registration policy
    - Under "Auto-registration":
        - For Cloud Provider, choose AWS
        - For Claims, enter the key=value pairs:
            - "account=<Your_AWS_Account_Number>"
            - "rolename=microseg-node-iam-role"

3. Terraform v1.0 and above

4. Install AWS CLI
    - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

5. Configure AWS CLI
    - Require AWS Access Key and AWS Secret Key
    - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config

6. Install kubectl
    - https://kubernetes.io/docs/tasks/tools/



## Deployment

### Deploy EKS Cluster

1. cd into the "deploy_eks_cluster" directory

2. Update the "terraform.tfvars" file with the necessary information.

3. Run "terraform init"

4. Run "terraform apply"

5. The EKS cluster will be deployed. It takes about 20-30 minutes for it to be fully ready.

6. The kubeconfig file will be in the same directory where you run the Terraform commands.

7. Run "kubectl --kubeconfig kubeconfig get nodes" to list the nodes in the EKS cluster.



### Deploy Enforcer

1. cd into the "deploy_enforcer" directory

2. Update the "terraform.tfvars" file with the necessary information.

3. Run "terraform init"

4. Run "terraform apply"

5. On the Prisma Cloud console, go to Network Security -> Agent -> Enforcers to check that the Enforcer is connected to the Console

6. Run "kubectl --kubeconfig ../deploy_eks_cluster/kubeconfig get all -n aporeto" to list the microsegmentation pods and service.



## Removing The Demo Environment

1. cd into the "deploy_enforcer" directory

2. Run "terraform destroy"

3. cd into the "deploy_eks_cluster" directory

4. Run "terraform destroy"



## Note
The enforcerd.tf file is based on the enforcerd yaml file from https://github.com/aporeto-se/aporeto-k8s-enforcerd-builder
