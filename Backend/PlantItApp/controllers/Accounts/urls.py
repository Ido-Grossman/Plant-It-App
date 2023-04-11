from django.urls import path
from . import LoginController, RegisterController, PasswordController, UsernameController


urlpatterns = [
    path('login/', LoginController.login),
    path('google-login/', LoginController.google_login),
    path('register/', RegisterController.register),
    path('google-register/', RegisterController.google_register),
    path('forgot-password/', PasswordController.forgot_password),
    path('set-username/', UsernameController.set_username),
]
