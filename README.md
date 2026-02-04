# MuleSoftForge Connector Playground

A comprehensive MuleSoft application demonstrating integration with various AI and data connectors including MuleSoft Inference, Agentforce, Einstein AI, MCP (Model Context Protocol), and more.

## 🚀 Features

- **AI Integration**: MuleSoft Inference, Einstein AI, Agentforce connectors
- **MCP Protocol**: Model Context Protocol for AI agent interactions
- **Agent-to-Agent (A2A)**: Inter-agent communication capabilities
- **IDP Support**: Intelligent Document Processing integration
- **Vector Storage**: PGVector integration for embeddings
- **Database**: PostgreSQL with LangChain4j support
- **WebSocket**: Real-time communication support
- **REST API**: Comprehensive API with APIkit scaffolding

## 📋 Prerequisites

- **Mule Runtime**: 4.10.1 or higher
- **Java**: JDK 8 or higher
- **Maven**: 3.8.x or higher
- **Anypoint Platform Account**: For Exchange and deployment
- **PostgreSQL**: For database operations (if using DB features)

## 🛠️ Setup Instructions

### Step 1: Publish API Specification to Your Exchange

Before deploying this application to your organization, you need to publish the API specification to your Anypoint Exchange:

1. Navigate to the `api/1.0.0/` directory in this project
2. Log into your Anypoint Platform account
3. Go to **Exchange** in your organization
4. Click **Publish new asset**
5. Upload the `mulesoftforge-connector-playground.yaml` file
6. Note your **Organization ID** from the Exchange URL or your profile

   Your Organization ID can be found in:
   - Exchange URL: `https://anypoint.mulesoft.com/exchange/YOUR-ORG-ID/`
   - Or in Anypoint Platform → Settings → Organization

### Step 2: Update API Properties in pom.xml

Update the API properties in `app/pom.xml` with your organization's details:

```xml
<properties>
    <!-- API Specification Properties -->
    <!-- IMPORTANT: Update these values for your organization -->
    <api.groupId>YOUR-ORG-ID-HERE</api.groupId>
    <api.artifactId>mulesoftforge-connector-playground</api.artifactId>
    <api.version>1.0.0</api.version>
</properties>
```

**Replace:**
- `YOUR-ORG-ID-HERE` with your Anypoint Platform Organization ID
- Update `api.artifactId` if you changed the artifact name in Exchange
- Update `api.version` to match the version you published

### Step 3: Configure Dependencies

Ensure you have access to all required repositories in your `settings.xml`:

```xml
<servers>
    <server>
        <id>anypoint-exchange-v3</id>
        <username>YOUR-USERNAME</username>
        <password>YOUR-PASSWORD</password>
    </server>
</servers>
```

Or use connected apps credentials for CI/CD:

```xml
<server>
    <id>anypoint-exchange-v3</id>
    <username>~~~Client~~~</username>
    <password>CLIENT_ID~?~CLIENT_SECRET</password>
</server>
```

### Step 4: Configure Application Properties

Create or update `app/src/main/resources/config/config.properties`:

```properties
# Database Configuration (if using PostgreSQL features)
db.host=localhost
db.port=5432
db.database=playground
db.user=postgres
db.password=password

# Anypoint Platform Configuration
anypoint.platform.apiAutoDiscovery=YOUR-API-ID

# Connector Configurations (optional)
# Add your connector-specific properties here
```

### Step 5: Build the Application

```bash
cd app
mvn clean package
```

### Step 6: Deploy

**Local Deployment:**
```bash
mvn mule:deploy
```

**CloudHub Deployment:**
```bash
mvn deploy -DmuleDeploy \
    -Dmule.version=4.10.1 \
    -Dusername=YOUR-USERNAME \
    -Dpassword=YOUR-PASSWORD \
    -DapplicationName=mulesoftforge-connector-playground \
    -Denvironment=Sandbox \
    -Dregion=us-east-2 \
    -Dworkers=1 \
    -DworkerType=MICRO
```

## 📁 Project Structure

```
mulesoftforge-connector-playground/
├── api/
│   └── 1.0.0/
│       ├── mulesoftforge-connector-playground.yaml  # OpenAPI Specification
│       └── exchange.json                            # Exchange metadata
├── app/
│   ├── src/main/
│   │   ├── mule/
│   │   │   ├── mulesoft-connector-playground.xml   # Main API flows
│   │   │   ├── a2a.xml                              # Agent-to-Agent flows
│   │   │   ├── mcp.xml                              # MCP protocol flows
│   │   │   └── idp.xml                              # IDP flows
│   │   └── resources/
│   │       ├── config/                              # Configuration files
│   │       ├── database/                            # SQL scripts
│   │       └── webapp/                              # Frontend assets
│   └── pom.xml                                      # Maven dependencies
└── README.md
```

## 🔌 Included Connectors

### AI & Machine Learning
- **MuleSoft Inference Connector** (v1.2.0) - Multi-provider AI inference
- **Einstein AI Connector** (v1.2.1) - Salesforce Einstein AI
- **Agentforce Connector** (v1.2.0) - Salesforce Agentforce
- **Amazon Bedrock Connector** (v0.6.0) - AWS Bedrock models
- **OpenAI Connector** (v0.1.0) - OpenAI integration
- **Gemini Connector** (v1.0.0) - Google Gemini AI

### Data & Storage
- **Vectors Connector** (v1.0.0) - Vector database operations
- **DB Connector** (v1.15.0) - Database connectivity
- **File Connector** (v1.5.5) - File system operations
- **ObjectStore Connector** (v1.2.5) - Object storage

### Communication
- **MCP Connector** (v1.3.1) - Model Context Protocol
- **A2A Connector** (v1.0.1) - Agent-to-Agent communication
- **WebSockets Connector** (v1.0.2) - Real-time communication
- **HTTP Connector** (v1.11.1) - HTTP operations

### Identity & Security
- **IDP Connector** (v1.0.6) - Intelligent Document Processing
- **OAuth Module** (v1.1.25) - OAuth authentication

## 🔧 Configuration Reference

### Key Properties

| Property | Description | Default | Required |
|----------|-------------|---------|----------|
| `api.groupId` | Your Anypoint Organization ID | - | ✅ Yes |
| `api.artifactId` | API artifact name in Exchange | `mulesoftforge-connector-playground` | ✅ Yes |
| `api.version` | API version | `1.0.0` | ✅ Yes |
| `app.runtime` | Mule Runtime version | `4.10.1` | ✅ Yes |

## 🌐 API Endpoints

Once deployed, the application exposes:

- **API Console**: `http://localhost:8081/console` (when running locally)
- **Main API**: `http://localhost:8081/*`
- **WebSocket**: `ws://localhost:8081/ws/*`
- **Operations**: Various connector operation endpoints (see API spec)

## 🧪 Testing

1. **Start the application locally**:
   ```bash
   mvn mule:run
   ```

2. **Access API Console**: Navigate to `http://localhost:8081/console`

3. **Execute Operations**: Use the console to test various connector operations

## 📚 Additional Resources

- [MuleSoft Documentation](https://docs.mulesoft.com/)
- [Anypoint Exchange](https://www.mulesoft.com/exchange/)
- [MuleSoft Connectors](https://docs.mulesoft.com/connectors/)
- [APIkit Module](https://docs.mulesoft.com/apikit/)

## 🤝 Contributing

This is a demonstration/playground project. Feel free to:
1. Fork the repository
2. Experiment with different connectors
3. Add new integrations
4. Share your findings

## 📝 License

[Specify your license here]

## ⚠️ Important Notes

### For Users Deploying to Their Own Organization

**You MUST update the following before deploying:**

1. ✅ **API Properties in `app/pom.xml`**:
   - Change `<api.groupId>` to your Organization ID
   - Verify `<api.artifactId>` matches your Exchange asset name
   - Update `<api.version>` to match your published version

2. ✅ **Publish API to Your Exchange**:
   - Upload `api/1.0.0/mulesoftforge-connector-playground.yaml` to your Exchange
   - The asset must be accessible in your organization

3. ✅ **Update Configuration Properties**:
   - Review and update all configuration files in `app/src/main/resources/config/`
   - Add necessary credentials and connection details

### Version Compatibility

This project uses:
- Mule Runtime 4.10.1
- Latest stable versions of MuleSoft connectors
- Java 8 compatible libraries

Ensure your environment meets these requirements.

## 🆘 Troubleshooting

### ⚠️ Expected Error: "Missing artifact" in pom.xml

**Error Message**:
```
Missing artifact eca25329-9592-4ff1-9054-1b08d103b991:mulesoftforge-connector-playground:zip:oas:1.0.0
```

**Status**: ✅ **This is EXPECTED and OK for a template project**

This error appears because the API artifact doesn't exist in your Exchange yet. It will automatically resolve once you:

1. Publish the API specification to your Anypoint Exchange
2. Update the `<api.groupId>` property in `app/pom.xml` with your Organization ID
3. Run `mvn clean install` again

**This error serves as a helpful reminder that initial setup is required.**

#### Alternative: Bundle API as Local Resource

If you want to avoid the Exchange dependency entirely, you can bundle the API specification directly in your project:

1. Copy `api/1.0.0/mulesoftforge-connector-playground.yaml` to `app/src/main/resources/api/`
2. Update the APIkit config in `mulesoft-connector-playground.xml`:
   ```xml
   <apikit:config name="mulesoftforge-connector-playground-config" 
       api="resource::api/mulesoftforge-connector-playground.yaml" 
       outboundHeadersMapName="outboundHeaders" 
       httpStatusVarName="httpStatus" />
   ```
3. Remove the API dependency from `pom.xml` (lines 137-143)

**⚠️ Trade-offs:**
- ✅ **Pros**: No Exchange dependency, works immediately, no org-specific configuration
- ❌ **Cons**: Loses API versioning, API Manager integration, Exchange documentation, and governance features

**Recommendation**: Only use this approach for quick prototyping or demos. For production use, publish to Exchange to leverage the full Anypoint Platform capabilities.

### Build Fails with "Artifact not found"

**Problem**: Maven cannot find the API specification dependency after setup.

**Solution**:
1. Verify you've published the API to your Exchange
2. Check your Organization ID is correct in `pom.xml` (lines 22-24)
3. Ensure your `settings.xml` has correct credentials for `anypoint-exchange-v3`
4. Verify the artifact name matches what you published to Exchange

### Application Fails to Start

**Problem**: Configuration errors or missing properties.

**Solution**:
1. Review logs for specific error messages
2. Verify all required properties are set in `config.properties`
3. Check connector configurations in XML files

### Database Connection Issues

**Problem**: Cannot connect to PostgreSQL.

**Solution**:
1. Verify PostgreSQL is running
2. Check database credentials in configuration
3. Ensure PostgreSQL driver is properly loaded as shared library

## 📧 Support

For issues, questions, or contributions, please [open an issue](../../issues) in the repository.

---

**Built with ❤️ by MuleSoftForge Community**
