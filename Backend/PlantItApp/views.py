import os

from django.http import HttpResponse
from google.cloud import storage
from google.oauth2 import service_account
from django.conf import settings

def show_plant_photo(request, picture_name):
    bucket_name = 'plant-it-app-bucket'
    blob_name = f'profile_pictures/{picture_name}'
    credentials = service_account.Credentials.from_service_account_file(
        os.path.join(settings.BASE_DIR, 'plant-it-app-384117-a7e5ae11ce1d.json'))
    # Download the image file from the Google Cloud Storage bucket
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)
    image_data = blob.download_as_bytes()

    # Create an HttpResponse object with the image data and the correct content type
    response = HttpResponse(image_data, content_type=blob.content_type)

    return response
