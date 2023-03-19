from django.urls import path
from .controllers import LoginController, RegisterController, PhotoController

urlpatterns = [
    path('register/', RegisterController.Register),
    path('login/', LoginController.Login),
    path('photo-upload/', PhotoController.PhotoUploadView.as_view(), name='photo_upload'),
]
