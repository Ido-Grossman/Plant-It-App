from django.urls import path
from .controllers import AccountsController, PhotoController
from . import views


urlpatterns = [
    path('accounts/register/', AccountsController.register),
    path('accounts/login/', AccountsController.login),
    path('accounts/forgot-password/', AccountsController.forgot_password),
    path('photo-upload/', PhotoController.PhotoUploadView.as_view(), name='photo_upload'),
]
