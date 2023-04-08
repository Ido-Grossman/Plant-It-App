from django.urls import path
from .controllers import AccountsController, PhotoController
from . import views


urlpatterns = [
    path('accounts/register/', AccountsController.register),
    path('accounts/login/', AccountsController.signin),
    path('accounts/forgot-password/', AccountsController.forgot_password),
    path('accounts/set-username/', AccountsController.set_username),
    path('photo-upload/', PhotoController.PhotoUploadView.as_view(), name='photo_upload'),
    path('accounts/google-register/', AccountsController.register_google),
    path('accounts/google-login/', AccountsController.signin_google)
]
