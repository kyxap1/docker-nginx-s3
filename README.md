# docker-nginx-s3
An nginx image with [ngx_aws_auth](https://github.com/anomalizer/ngx_aws_auth)

## Example nginx configuration

```
server {
  listen     80;

  location / {
    proxy_pass http://your_s3_bucket.s3.amazonaws.com;

    aws_access_key your_aws_access_key;
    aws_secret_key the_secret_associated_with_the_above_access_key;
    s3_bucket your_s3_bucket;

    proxy_set_header Authorization $s3_auth_token;
    proxy_set_header x-amz-date $aws_date;
  }

  # This is an example that does not use the server root for the proxy root
  location /myfiles {

    rewrite /myfiles/(.*) /$1 break;
    proxy_pass http://your_s3_bucket.s3.amazonaws.com/$1;

    aws_access_key your_aws_access_key;
    aws_secret_key the_secret_associated_with_the_above_access_key;
    s3_bucket your_s3_bucket;
    chop_prefix /myfiles; # Take out this part of the URL before signing it, since '/myfiles' will not be part of the URI sent to Amazon  


    proxy_set_header Authorization $s3_auth_token;
    proxy_set_header x-amz-date $aws_date;
  }

}
```
