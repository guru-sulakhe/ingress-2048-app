module "workstation" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "workstation"

  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids#replace your SG
  subnet_id =  var.subnet_id#replace your Subnet
  ami = data.aws_ami.ami_info.id
  user_data = file("workstation.sh")
  tags = {
    Name = "workstation"
  }
}

#After running workstation.sh
# Run below commands
# login to aws account in VMS throught the below command
# $ aws configure
# creating EKS cluster
# $ eksctl create cluster --name demo-cluster-1 --region us-east-1 --fargate 
# Accessing EKS cluster in VM'S
# $ aws eks update-kubeconfig --region us-east-1 --name demo-cluster-1
# Creating fargateprofile at which ec2 instances are not managed
/* $ eksctl create fargateprofile \
    --cluster demo-cluster-1 \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace game-2048 */ 
# run the below command in the VM'S in order to run the application
# $ kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml
# or you can run  these commands $ git clone https://github.com/guru-sulakhe/ingress-2048-app.git
# $ cd ingress-2048-app/helm
# $ helm install game-2048
# $ kubectl get pods -n game-2048 -w
# $ kubectl get svc -n game-2048
# $ kubectl get ingress -n game-2048 
# checking whether any IAM OIDC provider is already configured
# $ aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4\n
# if not run the below command  
# $ eksctl utils associate-iam-oidc-provider --cluster demo-cluster-1 --approve
# We need to create ALB Controller at which pods should access to AWS Services such as ALB, for that we are creating iam-policy,iam-role
# $ curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
# if the iam policy i.,e AWSLoadBalancerControllerIAMPolicy is already created in your AWS account, delete the IAM Policy and create it through the below command
# try to add the below AWSLoadBalancerControllerIAMPolicy
/* $ aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json */
/* AWSLoadBalancerControllerIAMPolicy  
{
    "Effect": "Allow",
    "Action": [
        "elasticloadbalancing:DescribeListenerAttributes",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyRule",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:ModifyLoadBalancerAttributes"
    ],
    "Resource": "*" */
# attaching IAM role to the service account of pod
/* eksctl create iamserviceaccount \
  --cluster=demo-cluster-1 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::637423540068:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve */
#reattaching the iam role policy
/* aws iam attach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonEKSALBIngressControllerPolicy \
    --role-name AmazonEKSLoadBalancerControllerRole */
# Helm chart will create the actual controller and it will use the service account for running the pod
# $ helm repo add eks https://aws.github.io/eks-charts
# $ helm repo update eks
/*helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \            
  --set clusterName=demo-cluster-1 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=<your-vpc-id> */
# in networking tab of demon-cluster-1 of eks you will the vpc_id of your cluster
# Verify that the deployments are running
# $ kubectl get deployment -n kube-system aws-load-balancer-controller
# $ kubectl get pods -n kube-system
# $ kubectl get deploy -n kube-system
# $ kubectl get ingress -n game-2048
# here ingress will create ALB in EC2 resource of AWS
# copy the ADDRESS of the ingress and paste it on chrome 