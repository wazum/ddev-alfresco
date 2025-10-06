# ddev-alfresco

[![tests](https://github.com/wazum/ddev-alfresco/actions/workflows/tests.yml/badge.svg)](https://github.com/wazum/ddev-alfresco/actions/workflows/tests.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Minimal Alfresco Community Edition integration for DDEV projects.

## What is this?

This add-on provides a lightweight Alfresco Community Edition setup optimized for local development of applications that integrate with Alfresco's REST API, CMIS API, or WebDAV interface. Perfect for developing custom connectors, file management integrations, or document-centric applications without the overhead of a full Alfresco deployment.

The setup runs Alfresco Content Repository with PostgreSQL, with search indexing and transform services disabled for minimal resource usage. This gives you a fast, API-ready Alfresco instance that starts in minutes and uses 4-6GB RAM instead of 16GB+.

## Installation

```bash
ddev add-on get ddev/ddev-alfresco
ddev restart
ddev alfresco-wait
```

The first startup takes 3-5 minutes while Alfresco initializes.

## Access

**Web Interface:**
```bash
ddev launch :8081/alfresco
```

**API Endpoints (external):**
- REST API: `https://<project>.ddev.site:8081/alfresco/api/-default-/public/alfresco/versions/1`
- CMIS: `https://<project>.ddev.site:8081/alfresco/api/-default-/public/cmis/versions/1.1/browser`
- WebDAV: `https://<project>.ddev.site:8081/alfresco/webdav`

**API Endpoints (internal, from web container):**
- REST API: `http://alfresco:8080/alfresco/api/-default-/public/alfresco/versions/1`
- CMIS: `http://alfresco:8080/alfresco/api/-default-/public/cmis/versions/1.1/browser`

**Default credentials:**
- Username: `admin`
- Password: `admin`

**Default groups:**
- `ALFRESCO_ADMINISTRATORS` - Full system administration
- `SITE_ADMINISTRATORS` - Site management
- `EMAIL_CONTRIBUTORS` - Email integration access

## Commands

```bash
ddev alfresco-wait              # Wait for Alfresco to be ready
ddev alfresco-status            # Check service health
ddev alfresco [command]         # Execute command in Alfresco container
ddev logs -s alfresco           # View Alfresco logs (standard DDEV command)
ddev logs -s postgres-alfresco  # View PostgreSQL logs (standard DDEV command)
```

## Integration Example

Connect to Alfresco from your application using internal endpoints:

```php
$config = [
    'alfresco_endpoint' => 'http://alfresco:8080/alfresco/api/-default-/public/alfresco/versions/1',
    'cmis_endpoint' => 'http://alfresco:8080/alfresco/api/-default-/public/cmis/versions/1.1/browser',
    'username' => 'admin',
    'password' => 'admin',
];
```

## Configuration

Override default versions using environment variables in `.ddev/config.yaml`:

```yaml
web_environment:
  - ALFRESCO_IMAGE=alfresco/alfresco-content-repository-community:23.2.0
  - POSTGRES_IMAGE=postgres:15
```

Then restart: `ddev restart`

## Automatic Initialization

To ensure Alfresco is ready after every `ddev start` or `ddev restart`, add this hook to your `.ddev/config.yaml`:

```yaml
hooks:
  post-start:
    - exec-host: ddev alfresco-wait
```

This automatically waits for Alfresco to fully initialize before returning control, so your application can immediately connect to the API.

## System Requirements

- DDEV v1.21 or higher
- 4GB RAM minimum (6GB recommended)
- Port 8081 available

## Services

- **Alfresco Content Repository** v23.1.0 (Community Edition)
- **PostgreSQL** v14.4

Search indexing (Solr), document transformation, and message queue services are disabled for minimal resource usage. These can be added later if needed.

## Removal

```bash
ddev add-on remove ddev-alfresco
```

This removes the add-on and deletes all Alfresco data.

## License

Apache License 2.0 - Copyright © 2025 Wolfgang Klinger <wolfgang@wazum.com>
