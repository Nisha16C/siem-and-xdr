terraform init \
    -backend-config="address=http://gitlab.os3.com/api/v4/projects/105/terraform/state/dev" \
    -backend-config="lock_address=http://gitlab.os3.com/api/v4/projects/105/terraform/state/dev" \
    -backend-config="unlock_address=http://gitlab.os3.com/api/v4/projects/105/terraform/state/dev" \
    -backend-config="username=ankit.dwivedi" \
    -backend-config="password=sV5SuDVtjM9uRB7pkDug" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"
