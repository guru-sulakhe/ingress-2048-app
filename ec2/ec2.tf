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