# ddev-alfresco

Minimal Alfresco Community Edition integration for DDEV projects.

## What is this?

This add-on provides a lightweight Alfresco Community Edition setup optimized for API access and development. It runs Alfresco Content Repository with PostgreSQL, with search indexing and transform services disabled for minimal resource usage.

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

## System Requirements

- DDEV v1.21 or higher
- 4GB RAM minimum (6GB recommended)
- Port 8081 available

## Services

- **Alfresco Content Repository** v23.1.0
- **PostgreSQL** v14.4

Search indexing (Solr), document transformation, and message queue services are disabled for minimal resource usage. These can be added later if needed.

## Removal

```bash
ddev add-on remove ddev-alfresco
```

This removes the add-on and deletes all Alfresco data.

## License

Apache License 2.0 - Copyright © 2025 Wolfgang Klinger <wolfgang@wazum.com>
