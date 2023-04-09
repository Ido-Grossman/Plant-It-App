from django.urls import path
from . import LoginController, RegisterController, PasswordController, UsernameController


urlpatterns = [
    path('login/', LoginController.signin),
    path('google-login/', LoginController.signin_google),
    path('register/', RegisterController.register),
    path('google-register/', RegisterController.register_google),
    path('forgot-password/', PasswordController.forgot_password),
    path('set-username/', UsernameController.set_username),
]
