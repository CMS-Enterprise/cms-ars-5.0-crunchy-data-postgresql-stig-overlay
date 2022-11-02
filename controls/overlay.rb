overlay_controls = input('overlay_controls')
system_categorization = input('system_categorization')

include_controls 'crunchy-data-postgresql-stig-baseline' do

  ## NIST tags updated due to changes between NIST SP 800-53 rev 4 and rev 5 (https://csrc.nist.gov/csrc/media/Publications/sp/800-53/rev-5/final/documents/sp800-53r4-to-r5-comparison-workbook.xlsx)

  control "V-233545" do
    tag nist: ["PL-9"] # PL-9 incorporates withdrawn control AU-3 (2)
  end

  ## NA due to the requirement not included in CMS ARS 5.0
  unless overlay_controls.empty?
    overlay_controls.each do |overlay_control|
      control overlay_control do
        impact 0.0
        desc "caveat", "Not applicable for this CMS ARS 5.0 overlay, since the requirement is not included in CMS ARS 5.0"
      end
    end
  end

  ## Semantic changes
  control	'V-233584' do
      title	"PostgreSQL must use CMS-approved cryptography to protect sensitive information."
      desc	"Use of weak or untested encryption algorithms undermines the purposes of utilizing encryption to protect 
      data. The application must implement cryptographic modules adhering to the higher standards approved by the 
      federal government since this provides assurance they have been tested and validated.

      It is the responsibility of the data owner to assess the cryptography requirements in light of applicable federal 
      laws, Executive Orders, directives, policies, regulations, and standards."
        desc	'check', "If PostgreSQL is not using CMS-approved cryptography to protect sensitive information in accordance with applicable 
      federal laws, Executive Orders, directives, policies, regulations, and standards, this is a finding.

      To check if PostgreSQL is configured to use SSL, as the database administrator (shown here as \"postgres\"), run the 
      following SQL:

      $ sudo su - postgres
      $ psql -c \"SHOW ssl\"

      If SSL is off, this is a finding."
      desc	'fix', "Note: The following instructions use the PGDATA and PGVER environment variables. See 
      supplementary content APPENDIX-F for instructions on configuring PGDATA and APPENDIX-H for PGVER.

      To configure PostgreSQL to use SSL as a database administrator (shown here as \"postgres\"), edit postgresql.conf:

      $ sudo su - postgres
      $ vi ${PGDATA?}/postgresql.conf

      Add the following parameter:

      ssl = on

      Next, as the system administrator, reload the server with the new configuration:

      $ sudo systemctl reload postgresql-${PGVER?}

      For more information on configuring PostgreSQL to use SSL, see supplementary content APPENDIX-G."
  end

end
