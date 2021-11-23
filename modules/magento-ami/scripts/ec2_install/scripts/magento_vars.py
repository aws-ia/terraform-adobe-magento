#!/usr/bin/python3

import os
import boto3

REGION = os.environ.get('REGION')

session = boto3.Session(region_name=REGION)
ssm = session.client('ssm')

try:
  magento_database_host = ssm.get_parameter(Name="magento_database_host", WithDecryption=True)
  print("magento_database_host: {}".format(magento_database_host['Parameter']['Value']))
except:
  print("magento_database_host: NotFound")

try:
  magento_database_username = ssm.get_parameter(Name="magento_database_username", WithDecryption=True)
  print("magento_database_username: {}".format(magento_database_username['Parameter']['Value']))
except:
  print("magento_database_username: NotFound")

try:
  magento_database_password = ssm.get_parameter(Name="magento_database_password", WithDecryption=True)
  print("magento_database_password: {}".format(magento_database_password['Parameter']['Value']))
except:
  print("magento_database_password: NotFound")

try:
  magento_elasticsearch_host = ssm.get_parameter(Name="magento_elasticsearch_host", WithDecryption=True)
  print("magento_elasticsearch_host: {}".format(magento_elasticsearch_host['Parameter']['Value']))
except:
  print("magento_elasticsearch_host: NotFound")

try:
  magento_cache_host = ssm.get_parameter(Name="magento_cache_host", WithDecryption=True)
  print("magento_cache_host: {}".format(magento_cache_host['Parameter']['Value']))
except:
  print("magento_cache_host: NotFound")

try:
  magento_session_host = ssm.get_parameter(Name="magento_session_host", WithDecryption=True)
  print("magento_session_host: {}".format(magento_session_host['Parameter']['Value']))
except:
  print("magento_session_host: NotFound")

try:
  magento_rabbitmq_host = ssm.get_parameter(Name="magento_rabbitmq_host", WithDecryption=True)
  print("magento_rabbitmq_host: {}".format(magento_rabbitmq_host['Parameter']['Value']))
except:
  print("magento_rabbitmq_host: NotFound")

try:
  magento_rabbitmq_username = ssm.get_parameter(Name="magento_rabbitmq_username", WithDecryption=True)
  print("magento_rabbitmq_username: {}".format(magento_rabbitmq_username['Parameter']['Value']))
except:
  print("magento_rabbitmq_username: NotFound")

try:
  rabbitmq_password = ssm.get_parameter(Name="rabbitmq_password", WithDecryption=True)
  print("rabbitmq_password: {}".format(rabbitmq_password['Parameter']['Value']))
except:
  print("rabbitmq_password: NotFound")

try:
  cloudfront_domain = ssm.get_parameter(Name="cloudfront_domain", WithDecryption=True)
  print("cloudfront_domain: {}".format(cloudfront_domain['Parameter']['Value']))
except:
  print("cloudfront_domain: NotFound")

try:
  magento_crypt_key = ssm.get_parameter(Name="magento_crypt_key", WithDecryption=True)
  print("magento_crypt_key: {}".format(magento_crypt_key['Parameter']['Value']))
except:
  print("magento_crypt_key: NotFound")

try:
  magento_efs_id = ssm.get_parameter(Name="magento_efs_id", WithDecryption=True)
  print("magento_efs_id: {}".format(magento_efs_id['Parameter']['Value']))
except:
  print("magento_efs_id: NotFound")

try:
  magento_files_s3 = ssm.get_parameter(Name="magento_files_s3", WithDecryption=True)
  print("magento_files_s3: {}".format(magento_files_s3['Parameter']['Value']))
except:
  print("magento_files_s3: NotFound")

try:
  magento_admin_password = ssm.get_parameter(Name="magento_admin_password", WithDecryption=True)
  print("magento_admin_password: {}".format(magento_admin_password['Parameter']['Value']))
except:
  print("magento_admin_password: NotFound")

try:
  magento_admin_email = ssm.get_parameter(Name="magento_admin_email", WithDecryption=True)
  print("magento_admin_email: {}".format(magento_admin_email['Parameter']['Value']))
except:
  print("magento_admin_email: NotFound")

try:
  smtp_user = ssm.get_parameter(Name="smtp_user", WithDecryption=True)
  print("smtp_user: {}".format(smtp_user['Parameter']['Value']))
except:
  print("smtp_user: NotFound")

try:
  smtp_pass = ssm.get_parameter(Name="smtp_pass", WithDecryption=True)
  print("smtp_pass: {}".format(smtp_pass['Parameter']['Value']))
except:
  print("smtp_pass: NotFound")

try:
  magento_admin_firstname = ssm.get_parameter(Name="magento_admin_firstname", WithDecryption=True)
  print("magento_admin_firstname: {}".format(magento_admin_firstname['Parameter']['Value']))
except:
  print("magento_admin_firstname: NotFound")

try:
  magento_admin_lastname = ssm.get_parameter(Name="magento_admin_lastname", WithDecryption=True)
  print("magento_admin_lastname: {}".format(magento_admin_lastname['Parameter']['Value']))
except:
  print("magento_admin_lastname: NotFound")

try:
  magento_admin_username = ssm.get_parameter(Name="magento_admin_username", WithDecryption=True)
  print("magento_admin_username: {}".format(magento_admin_username['Parameter']['Value']))
except:
  print("magento_admin_username: NotFound")

try:
  magento_autoscale_name = ssm.get_parameter(Name="magento_autoscale_name", WithDecryption=True)
  print("magento_autoscale_name: {}".format(magento_autoscale_name['Parameter']['Value']))
except:
  print("magento_autoscale_name: NotFound")