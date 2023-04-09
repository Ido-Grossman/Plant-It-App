from django.urls import path, include
from .controllers import PhotoController


urlpatterns = [
    path('accounts/', include('PlantItApp.controllers.Accounts.urls')),
    path('photo-upload/', PhotoController.PhotoUploadView.as_view(), name='photo_upload'),
]
