from textwrap import dedent

import boto3
from django.conf import settings
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        bucket = settings.AWS_STORAGE_BUCKET_NAME
        region = settings.AWS_S3_REGION_NAME
        acl = "public-read"
        endpoint_url = settings.AWS_S3_ENDPOINT_URL
        use_ssl = settings.AWS_S3_USE_SSL

        print(
            dedent(
                f"""
                You are about to create an S3 bucket with the following configuration:

                AWS_STORAGE_BUCKET_NAME: {bucket}
                AWS_S3_REGION_NAME: {region}
                ACL: {acl}
                AWS_S3_ENDPOINT_URL: {endpoint_url}
                AWS_S3_USE_SSL: {use_ssl}

                Press any key to proceed.
                """
            )
        )

        input()

        client = boto3.client("s3", endpoint_url=endpoint_url, use_ssl=use_ssl)

        client.create_bucket(
            ACL=acl,
            Bucket=bucket,
            CreateBucketConfiguration={
                "LocationConstraint": region,
            },
        )
