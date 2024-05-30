<div align="center">

# NodeApp CI/CD Pipeline

[![test and deploy nodeapp](https://github.com/vikashraj1/node-backend-pipeline/actions/workflows/main.yml/badge.svg)](https://github.com/vikashraj1/node-backend-pipeline/actions/workflows/main.yml)

<h3>
    GitHub Actions CI/CD pipeline for automated testing and deployment of a Node.js app to AWS ECS.
</h3>

</div>

## Overview

The workflow is triggered on every push to the `main` branch. It consists of two jobs:

1. **Test**: Checks out the code, sets up Node.js, installs dependencies, runs an audit fix, and executes the tests using Jest.
2. **Deploy**: Executes only if the test job succeeds. It checks out the code, sets up Node.js, configures AWS credentials, logs into Amazon ECR (Elastic Container Registry), builds and pushes a Docker image, updates the ECS task definition, and deploys the updated task definition to ECS.

**Accomplishments:**
- Improved deployment speed and reliability by automating the entire build and release process.
- Reduced manual intervention and potential errors, leading to more consistent and stable releases.
- Improved Code Quality by Regular testing and security checks helping maintain high code quality and prevent issues from reaching production.

**Technologies Used:**
- Node.js, GitHub Actions, Docker, Amazon ECR, Amazon ECS, AWS IAM

> This pipeline uses [integration_testing_degraphe_youtube](https://github.com/debaosuidecl/integration_testing_degraphe_youtube.git) as a sample Node.js application.


## Workflow Details

### Test Job

1. **Checkout code**: Uses the `actions/checkout@v4` action to clone the repository.
2. **Setup Node.js**: Uses the `actions/setup-node@v4` action to install Node.js version 20.
3. **Install Dependencies**: Runs `npm ci` to install dependencies.
4. **Run audit fix**: Executes `npm audit fix` to automatically fix vulnerabilities.
5. **Run tests**: Runs the test suite with `npm run test -- --no-watchAll --ci --runInBand --detectOpenHandles`.

### Deploy Job

1. **Checkout code**: Clones the repository again to ensure the latest code is used.
2. **Setup Node.js**: Installs Node.js version 20.
3. **Configure AWS credentials**: Uses `aws-actions/configure-aws-credentials@v4` to set up AWS credentials.
4. **Login to Amazon ECR**: Logs into Amazon ECR using `aws-actions/amazon-ecr-login@v2`.
5. **Build, tag, and push image to Amazon ECR**:
   - Builds the Docker image.
   - Tags the image with the commit SHA.
   - Pushes the image to the ECR repository.
6. **Fill in the new image ID in the Amazon ECS task definition**: Uses `aws-actions/amazon-ecs-render-task-definition@v1` to update the task definition with the new image ID.
7. **Deploy Amazon ECS task definition**: Uses `aws-actions/amazon-ecs-deploy-task-definition@v1` to deploy the updated task definition to the specified ECS service and cluster.

## Usage

To use this workflow:
1. Ensure your code is pushed to the `main` branch or the branch specified in the `on push` or `on pull request` section of the workflow.
2. Ensure your app uses Jest for testing, or adjust the `npm test` command flags for your testing framework.
3. Create an ECS cluster, service, task definition, and an IAM user with limited permissions in your AWS account.
4. Add the required secrets and environment variables to your GitHub repository settings.

### Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

  > Note: Create access keys from the IAM user's security credentials section in AWS.

### Environment Variables:
- `AWS_REGION`: us-example-1
- `ECR_REPOSITORY`: ecsreponame
- `ECS_SERVICE`: ecs-service-name
- `ECS_CLUSTER`: ecs-cluster-name
- `ECS_TASK_DEFINITION`: .aws/task-definition.json
- `CONTAINER_NAME`: containername

The pipeline will automatically run the tests and, upon success, deploy the application to AWS ECS.


## Graph


```mermaid
graph LR
A[Push to Main Branch] --> B[Test Job]
B --> C{Tests Pass?}
C --> |Yes| D[Deploy Job]
C --> |No| E[Abort]

subgraph Test Job
    B1[Checkout Code]
    B2[Setup Node.js]
    B3[Install Dependencies]
    B4[Run Audit Fix]
    B5[Run Tests]
    B1 --> B2 --> B3 --> B4 --> B5
end

subgraph Deploy Job
    D1[Checkout Code]
    D2[Setup Node.js]
    D3[Configure AWS Credentials]
    D4[Login to Amazon ECR]
    D5[Build, Tag, and Push Docker Image]
    D6[Update ECS Task Definition]
    D7[Deploy to ECS]
    D1 --> D2 --> D3 --> D4 --> D5 --> D6 --> D7
end