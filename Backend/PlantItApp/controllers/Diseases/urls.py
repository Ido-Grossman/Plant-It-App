from django.urls import path
from . import PhotoController


urlpatterns = [
    path('photo-upload/', PhotoController.photo_upload, name='photo_upload'),
    path('set-disease/', PhotoController.photo_upload, name='set_disease'),
]
