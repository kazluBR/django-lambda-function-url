from storages.backends.s3boto3 import S3Boto3Storage


class SecurityTokenWorkaroundS3Boto3Storage(S3Boto3Storage):
    """
    To solve the error `The provided token is malformed or otherwise invalid` running on lambda
    """

    def _get_security_token(self):
        return None


class PublicMediaStorage(SecurityTokenWorkaroundS3Boto3Storage):
    location = "media"
    file_overwrite = False
