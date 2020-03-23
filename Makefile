# Get a timestamp for right now
export DATE_NOW := $(shell date +%F.%H%M%S)

# Set Docker repository name
export ECR_REPO_NAME := ecs-edge-connector

# Set the stack name
export STACK_NAME := docker-$(ECR_REPO_NAME)

# Get AWS account number
# (interesting hack to get the account ID as long as the credentials allow it)
# (https://stackoverflow.com/questions/33791069/quick-way-to-get-aws-account-number-from-the-aws-cli-tools)
AWS_ACCOUNT = $(shell aws ec2 describe-security-groups --query 'SecurityGroups[0].OwnerId' --output text)

# Get default AWS region
AWS_REGION = $(shell aws configure get region)

# Generate an image tag
export IMAGE_TAG := $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_REPO_NAME):$(DATE_NOW)

docker-image-build:
	@echo "$(IMAGE_TAG)" > .lastimage
	@docker build -t $(IMAGE_TAG) .

docker-image: docker-image-build
	@docker push `cat .lastimage`

docker-test-local: docker-image-build
	@docker run -dit --rm -p 22:22 -e LISTENER_PORT=22 $(shell cat .lastimage)

ecr-repository:
	@aws ecr create-repository --repository-name $(ECR_REPO_NAME)

image-tag:
	@echo "$(IMAGE_TAG)"