# Consent Manager

The Prometheus-X Consent Manager is a service for managing consent within the Prometheus-X ecosystem. It empowers ecosystem administrators to oversee and enforce consent agreements, data/service providers to adhere to consent regulations, and users to manage their consent preferences seamlessly.

## Installation

### Locally

```sh
git clone https://github.com/Prometheus-X-association/consent-manager.git
cd consent-manager
npm install
cp .env.sample .env
# Configure your environment variables in .env
```

### Docker

1. Clone the repository from GitHub: `git clone https://github.com/Prometheus-X-association/consent-manager.git`
2. Navigate to the project directory: `cd consent-manager` and copy the .env.sample to .env `cp .env.sample .env`
3. Configure the application by setting up the necessary environment variables. You will need to specify database connection details and other relevant settings.
4. Generate the needed key with `npm run generatePrivateKey && npm run generateAES && npm run generatePublicKey`
5. Create a docker network using `docker network create ptx`
6. Start the application: `docker-compose up -d`
7. If you need to rebuild the image `docker-compose build` and restart with: `docker-compose up -d`
8. If you don't want to use the mongodb container from the docker compose you can use the command `docker run -d -p your-port:your-port --name consent-manager consent-manager` after running `docker-compose build`

The consent manager is a work in progress, evolving alongside developments of the Contract and Catalog components of the Prometheus-X Ecosystem.

## Terraform

1. Install Terraform: Ensure Terraform is installed on your machine.
2. Configure Kubernetes: Ensure you have access to your Kubernetes cluster and kubectl is configured.
3. Initialize Terraform: Run the following commands from the terraform directory.

```sh
cd terraform
terraform init
```

4. Apply the Configuration: Apply the Terraform configuration to create the resources.

```sh
terraform apply
```

5. Retrieve Service IP: After applying the configuration, retrieve the service IP.

```sh
terraform output consent_manager_service_ip
```

> - Replace placeholder values in the `kubernetes_secret` resource with actual values from your `.env`.
> - Ensure the `server_port` value matches the port used in your application.
> - Adjust the `host_path` in the `kubernetes_persistent_volume` resource to an appropriate path on your Kubernetes nodes.

### Deployment with Helm

1. **Install Helm**: Ensure Helm is installed on your machine. You can install it following the instructions [here](https://helm.sh/docs/intro/install/).

2. **Package the Helm chart**:

   ```sh
   helm package ./path/to/consent-manager
   ```

3. **Deploy the Helm chart**:

   ```sh
   helm install consent-manager ./path/to/consent-manager
   ```

4. **Verify the deployment**:

   ```sh
   kubectl get all -n consent-manager
   ```

5. **Retrieve Service IP**:

   ```sh
   kubectl get svc -n consent-manager
   ```

> - Replace placeholder values in the `values.yaml` file with actual values from your `.env`.
> - Ensure the `port` value matches the port used in your application.
> - Configure your MongoDB connection details in the values.yaml file to point to your managed MongoDB instance.

## Endpoints

For a complete list of all available endpoints, along with their request and response schemas, refer to the [JSON Swagger Specification](./docs/swagger.json) provided or visit the [github-pages](https://prometheus-x-association.github.io/consent-manager/) of this repository which displays the swagger specification with the Swagger UI.

## Consent Agent

The Consent Agent is a component of Prometheus-X that handles the preferences and recommendations of the users. It is integrated into the Consent Manager through the `ConsentAgent` class, which is responsible for setting up the agent and retrieving the service.

All endpoints, including those related to the Consent Agent, are documented in the JSON Swagger Specification provided in this repository, in the profile section.

For more information on the Consent Agent and its integration with the Consent Manager, please refer to the [Consent Agent documentation](https://github.com/Prometheus-X-association/contract-consent-agent/blob/main/README.md).

### Configuration

To use the consent agent you must configure the `consent-agent.config.sample.json`

```bash
cp consent-agent.config.sample.json consent-agent.config.json
```

After copying this file and filling in your information, the Consent Agent will be configured at startup.

#### Configuring a DataProvider (`consent-agent.config`)

The configuration file is a JSON document consisting of sections, where each section describes the configuration for a specific **DataProvider**. Below is a detailed explanation of the available attributes:

- **`source`**: The name of the target collection or table that the DataProvider connects to.
- **`url`**: The base URL of the database host.
- **`dbName`**: The name of the database to be used.
- **`watchChanges`**: A boolean that enables or disables change monitoring for the DataProvider. When enabled, events will be fired upon detecting changes.
- **`hostsProfiles`**: A boolean indicating whether the DataProvider hosts the profiles.
- **`existingDataCheck`**: A boolean that enables the creation of profiles when the module is initialized.

#### Example Configuration

Here’s an example of a JSON configuration:

```json
{
  "source": "profiles",
  "url": "mongodb://localhost:27017",
  "dbName": "contract_consent_agent_db",
  "watchChanges": false,
  "hostsProfiles": true,
  "existingDataCheck": true
}
```

#### Consent Agent Tests

1. Run tests:

```bash
pnpm test-agent
```

This command will run your tests using Mocha, with test files located at `./src/tests/*.agent.test.ts`.

## Contributing

We welcome contributions to the Prometheus-X Consent Manager. If you encounter a bug or wish to propose a new feature, kindly open an issue in the GitHub repository. For code contributions, fork the repository, create a new branch, make your changes, and submit a pull request.

## License

The Prometheus-X Consent Manager is open-source software licensed under the [MIT License](LICENSE).
