from django.urls import path
from . import PhotoController, DiseaseController


urlpatterns = [
    path('photo-upload/', PhotoController.photo_upload, name='photo_upload'),
    path('set-disease/<int:user_plant_id>/', DiseaseController.set_disease, name='set_disease'),
]
