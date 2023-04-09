from django.urls import path
from . import LoginController, RegisterController, PasswordController, UsernameController, AuthenticationController


urlpatterns = [
    path('login/', LoginController.signin),
    path('register/', RegisterController.register),
    path('google-auth/', AuthenticationController.authenticate_user),
    path('forgot-password/', PasswordController.forgot_password),
    path('set-username/', UsernameController.set_username),
]
