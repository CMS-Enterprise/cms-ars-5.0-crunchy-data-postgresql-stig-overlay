# cms-ars-5.0-crunchy-data-postgresql-stig-overlay

InSpec profile overlay to validate the secure configuration of Crunchy Data PostgreSQL against [DISA's](https://iase.disa.mil/stigs/Pages/index.aspx) Crunchy Data PostgreSQL STIG Version 1, Release 1 (Applies to database versions 10, 11, 12 & 13) tailored for CMS ARS 5.0.

#### Container-Ready: Profile updated to adapt checks when the running against a containerized instance of PostgreSQL, based on reference container: (docker pull registry1.dso.mil/ironbank/opensource/postgres/postgresql96:9.6.23)

## Getting Started  
### InSpec (CINC-auditor) setup
For maximum flexibility/accessibility, we’re moving to “cinc-auditor”, the open-source packaged binary version of Chef InSpec, compiled by the CINC (CINC Is Not Chef) project in coordination with Chef using Chef’s always-open-source InSpec source code. For more information: https://cinc.sh/

It is intended and recommended that CINC-auditor and this profile overlay be run from a __"runner"__ host (such as a DevOps orchestration server, an administrative management system, or a developer's workstation/laptop) against the target. This can be any Unix/Linux/MacOS or Windows runner host, with access to the Internet.

__For the best security of the runner, always install on the runner the _latest version_ of CINC-auditor.__ 

__The simplest way to install CINC-auditor is to use this command for a UNIX/Linux/MacOS runner platform:__
```
curl -L https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-auditor
```

__or this command for Windows runner platform (Powershell):__
```
. { iwr -useb https://omnitruck.cinc.sh/install.ps1 } | iex; install -project cinc-auditor
```
To confirm successful install of cinc-auditor:
```
cinc-auditor -v
```
> sample output:  _4.24.32_

Latest versions and other installation options are available at https://cinc.sh/start/auditor/.

## Specify your BASELINE system categization as an environment variable:
### (if undefined defaults to Moderate baseline)

```
# BASELINE (choices: Low, Low-HVA, Moderate, Moderate-HVA, High, High-HVA)
# (if undefined defaults to Moderate baseline)

on linux:
BASELINE=High

on Powershell:
$env:BASELINE="High"
```

## Inputs: Tailoring your scan to Your Environment

The following inputs must be configured in an inputs ".yml" file for the profile to run correctly for your specific environment. More information about InSpec inputs can be found in the [InSpec Profile Documentation](https://www.inspec.io/docs/reference/profiles/).

#### *Note* Windows and Linux Cinc-auditor Runner

There are current issues with how the profiles run when using a windows or linux runner. We have accounted for this in the profile with the `windows_runner` input - which we *default* to `false` assuming a Linux based Cinc-auditor runner.

If you are using a *Windows* based cinc-auditor installation, please set the `windows_runner` input to `true` either via your `inspec.yml` file or via the cli flag via, `--input windows_runner=true`

### Example Inputs You Can Use

```
# Changes checks depending on if using a Windows or Linux-based cinc-auditor Runner (default value = false)
windows_runner: false


# These five inputs are used by any tests needing to query the database:
# Description: 'Postgres database admin user (e.g., 'postgres').'
pg_dba: 'postgres'

# Description: 'Postgres database admin password.'
pg_dba_password: ''

# Description: 'Postgres database hostname'
pg_host: ''

# Description: 'Postgres database name (e.g., 'postgres')'
pg_db: 'postgres'

# Description: 'Postgres database port (e.g., '5432')
pg_port: '5432'



# Description: 'Postgres OS user (e.g., 'postgres').'
pg_owner: 'postgres'

# Description: 'Postgres OS group (e.g., 'postgres').'
pg_group: 'postgres'

# Description: 'Postgres OS user password'
pg_owner_password: ''

# Description: 'Postgres normal user'
pg_user: ''

# Description: 'Postgres normal user password'
pg_user_password: ''

# Description: 'Postgres database table name'
pg_table: ''

# Description: 'User on remote database server'
login_user: ''

# Description: 'Database host ip'
login_host: ''

# Description: 'Database version'
# Change "12.x" to your version (This STIG applies to versions 10.x, 11.x, 12.x, and 13.x)
pg_version: '12.9'

# Description: 'Data directory for database'
# e.g., Default for version 12: '/var/lib/pgsql/12/data'
pg_data_dir: ''

# Description: 'Configuration file for the database' 
# e.g., Default for version 12: '/var/lib/pgsql/12/data/postgresql.conf'
pg_conf_file: ''

# Description: 'User defined configuration file for the database'
# e.g., Default for version 12: '/var/lib/pgsql/12/data/stig-postgresql.conf'
pg_user_defined_conf: ''

# Description: 'Configuration file to enable client authentication'
# e.g., Default for version 12: '/var/lib/pgsql/12/data/pg_hba.conf'
pg_hba_conf_file: ''

# Description: 'Configuration file that maps operating system usernames and database usernames'
# e.g., Default for version 12: '/var/lib/pgsql/12/data/pg_ident.conf'
pg_ident_conf_file: ''

# Description: 'V-233517 uses this input to check permissions of shared directories'
# e.g., Default for version 12: ['/usr/pgsql-12', '/usr/pgsql-12/bin', '/usr/pgsql-12/include', '/usr/pgsql-12/lib', '/usr/pgsql-12/share']
# Change "12" to your version (This STIG applies to versions 10, 11, 12, and 13)
pg_shared_dirs: ['/usr/pgsql-12', '/usr/pgsql-12/bin', '/usr/pgsql-12/include', '/usr/pgsql-12/lib', '/usr/pgsql-12/share']

# Description: 'The location of the postgres log files on the system'
# e.g., Default for version 12: '/var/lib/pgsql/12/data/log'
# Change "12" to your version (This STIG applies to versions 10, 11, 12, and 13)
pg_log_dir: '/var/lib/pgsql/12/data/log'

# Description: 'The location of the postgres audit log files on the system'
# e.g., Default for version 12: '/var/lib/pgsql/12/data/log'
# Change "12" to your version (This STIG applies to versions 10, 11, 12, and 13)
pg_audit_log_dir: '/var/lib/pgsql/12/data/log'

# Description: 'V-233607 uses this location of the pgaudit installation on the system'
# e.g., Default for version 12: '/usr/pgsql-12/share/contrib/pgaudit'
# Change "12" to your version (This STIG applies to versions 10, 11, 12, and 13)
pgaudit_installation: '/usr/pgsql-12/share/contrib/pgaudit'

# Description: 'Database configuration mode (e.g., 0600)'
pg_conf_mode: '0600'

# Description: 'Postgres ssl setting (e.g., 'on').'
pg_ssl: 'on'

# Description: 'Postgres log destination (e.g., 'syslog').'
pg_log_dest: 'syslog'

# Description: 'Postgres syslog facility (e.g., ['local0']).'
pg_syslog_facility: ['local0']

# Description: 'Postgres syslog owner (e.g., 'postgres').'
pg_syslog_owner: 'postgres'

# Description: 'Postgres audit log items (e.g., ['ddl','role','read','write']).'
pgaudit_log_items: ['ddl','role','read','write']

# Description: 'Postgres audit log line items (e.g. ['%m','%u','%c']).'
pgaudit_log_line_items: ['%m','%u','%c']

# Description: 'Postgres super users (e.g., ['postgres']).'
pg_superusers: ['postgres']

# Description: 'Postgres users'
pg_users: []

# Description: 'V-233520, V-233612 use this list of Postgres replicas from pg_hba.conf settings (e.g. ['127.0.0.1/32']).'
pg_replicas: []

# Description: 'Postgres timezone (e.g., 'UTC').'
pg_timezone: 'UTC'

# Description: 'V-233515, V-233520, V-233612 use this list of approved authentication methods (e.g., per STIG: ['gss', 'sspi', 'ldap'] ).'
approved_auth_methods: []

# Description: 'V-233594 uses this list of approved postgres-related packages (e.g., postgresql-server.x86_64, postgresql-odbc.x86_64).'
approved_packages: []

# Description: 'V-233592, V-233593 use this list of approved database extensions (e.g., ['plpgsql']).'
approved_ext: []

```

## Running This Overlay Directly from Github

Against a remote target using ssh as the *postgres* user (i.e., cinc-auditor installed on a separate runner host)
```bash
cinc-auditor exec https://github.com/cms-enterprise/cms-ars-5.0-crunchy-data-postgresql-stig-overlay/archive/main.tar.gz -t ssh://postgres:TARGET_PASSWORD@TARGET_IP:TARGET_PORT --input-file <path_to_your_input_file/name_of_your_input_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json> 
```

Against a remote target using a pem key as the *postgres* user (i.e., cinc-auditor installed on a separate runner host)
```bash
cinc-auditor exec https://github.com/cms-enterprise/cms-ars-5.0-crunchy-data-postgresql-stig-overlay/archive/main.tar.gz -t ssh://postgres@TARGET_IP:TARGET_PORT -i <postgres_PEM_KEY> --input-file <path_to_your_input_file/name_of_your_input_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>  
```

Against a _**locally-hosted**_ instance logged in as the *postgres* user (i.e., cinc-auditor installed on the target hosting the postgresql database)

```bash
cinc-auditor exec https://github.com/cms-enterprise/cms-ars-5.0-crunchy-data-postgresql-stig-overlay/archive/main.tar.gz --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

Against a _**docker-containerized**_ instance (i.e., cinc-auditor installed on the node hosting the postgresql container):
```
cinc-auditor exec https://github.com/cms-enterprise/cms-ars-5.0-crunchy-data-postgresql-stig-overlay/archive/main.tar.gz -t docker://<instance_id> --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

### Different Run Options

  [Full exec options](https://docs.chef.io/inspec/cli/#options-3)

## Running This Overlay from a local Archive copy 

If your runner is not always expected to have direct access to GitHub, use the following steps to create an archive bundle of this overlay and all of its dependent tests:

(Git is required to clone the InSpec profile using the instructions below. Git can be downloaded from the [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) site.)

When the __"runner"__ host uses this profile overlay for the first time, follow these steps: 

```
mkdir profiles
cd profiles
git clone https://github.com/cms-enterprise/cms-ars-5.0-crunchy-data-postgresql-stig-overlay.git
cinc-auditor archive cms-ars-5.0-crunchy-data-postgresql-stig-overlay
cinc-auditor exec <name of generated archive> --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

For every successive run, follow these steps to always have the latest version of this overlay and dependent profiles:

```
cd cms-ars-5.0-crunchy-data-postgresql-stig-overlay
git pull
cd ..
cinc-auditor archive cms-ars-5.0-crunchy-data-postgresql-stig-overlay --overwrite
cinc-auditor exec <name of generated archive> --input-file=<path_to_your_inputs_file/name_of_your_inputs_file.yml> --reporter=cli json:<path_to_your_output_file/name_of_your_output_file.json>
```

## Using Heimdall for Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://heimdall-lite.cms.gov/)__ for a user-interactive, graphical view of the InSpec results. 

The JSON InSpec results file may also be loaded into a __[full heimdall server](https://github.com/mitre/heimdall2)__, allowing for additional functionality such as to store and compare multiple profile runs.

## Authors
* Eugene Aronne - [ejaronne](https://github.com/ejaronne)
* Danny Haynes - [djhaynes](https://github.com/djhaynes)

## Special Thanks
* Aaron Lippold - [aaronlippold](https://github.com/aaronlippold)
* Shivani Karikar - [karikarshivani](https://github.com/karikarshivani)

## Contributing and Getting Help
To report a bug or feature request, please open an [issue](https://github.com/cms-enterprise/cms-ars-5.0-crunchy-data-postgresql-stig-overlay/issues/new).

### NOTICE

© 2018-2022 The MITRE Corporation.

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.

### NOTICE 

MITRE hereby grants express written permission to use, reproduce, distribute, modify, and otherwise leverage this software to the extent permitted by the licensed terms provided in the LICENSE.md file included with this project.

### NOTICE  

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.  

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.

### NOTICE 

DISA STIGs are published by DISA IASE, see: https://iase.disa.mil/Pages/privacy_policy.aspx
