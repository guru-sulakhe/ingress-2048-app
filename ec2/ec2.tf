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
# $ aws configure
# $ eksctl create cluster --name demo-cluster-1 --region us-east-1 --fargate 
# $ aws eks update-kubeconfig --region us-east-1 --name demo-cluster-1
/* $ eksctl create fargateprofile \
    --cluster demo-cluster-1 \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace game-2048 */ 
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
# if the iam policy i.,e AWSLoadBalancerControllerIAMPolicy is already created in your AWS account delete and create it through the below command
/* $ aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json */
# 
