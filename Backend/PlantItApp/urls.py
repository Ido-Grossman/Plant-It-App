from django.urls import path
from controllers import LoginController, RegisterController
from .views import PhotoUploadView

urlpatterns = [
    path('register/', RegisterController.Register),
    path('login/', LoginController.Login),
    path('api/photo-upload/', PhotoUploadView.as_view(), name='photo_upload'),
]
