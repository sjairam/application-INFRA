#example showing referencing a secret
AppConfig[:db_url] = "jdbc:mysql://test.test.us-east-1.rds.amazonaws.com:3306/db?user=user&password={{ .secret_in_aws }}&useUnicode=true&characterEncoding=UTF-8"

## Set the maximum number of database connections used by the application.
## Default is derived from the number of indexer threads.
#AppConfig[:db_max_connections] = proc { 20 + (AppConfig[:indexer_thread_count] * 2) }
#
# CAS
AppConfig[:oauth_username_is_email] = true
