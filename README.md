<div align="center">

# NodeApp CI/CD Pipeline

[[ STATUS BADGE WILL GO HERE ]]

<h2>
    GitHub Actions CI/CD pipeline for automated testing and deployment of a Node.js app to AWS ECS.
</h2>

</div>

## Overview

The workflow is triggered on every push to the `main` branch. It consists of two jobs:

1. **Test**: Checks out the code, sets up Node.js, installs dependencies, runs an audit fix, and executes the tests using Jest.
2. **Deploy**: Executes only if the test job succeeds. It checks out the code, sets up Node.js, configures AWS credentials, logs into Amazon ECR (Elastic Container Registry), builds and pushes a Docker image, updates the ECS task definition, and deploys the updated task definition to ECS.

**Accomplishments:**
- Improved deployment speed and reliability by automating the entire build and release process.
- Reduced manual intervention and potential errors, leading to more consistent and stable releases.
<!-- - Leveraged cloud infrastructure for scalable and reliable deployments.
- Ensured code quality and security by running `npm audit fix` and automated tests. -->

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
1. Ensure your code is pushed to the branch specified in the `on push` or `on pull request` section of the workflow.
2. Enusre your app uses jest for testing or you can change the ```npm test``` command flags for your use case.

3. create ecs cluster, serivce and task definatinon adn iam user with limited permission in your aws account and fill and add all the env vars and secrets metioned below in the workflow file.
   secrets:
   > note: to get secrets create access key from the im users security credentials section in aws
   envs:

4. The pipeline will automatically run the tests and, upon success, deploy the application to AWS ECS.





<!-- 
---
limit iam user
   test needed with custom policy


imporve md more

give me Accomplishments section with every imroved suggestion 
because im not happy with it now





https://stackedit.io/app
diagram like in above -->