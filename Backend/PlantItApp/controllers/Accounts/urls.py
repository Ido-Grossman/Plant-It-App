from django.urls import path
from . import LoginController, RegisterController, PasswordController, UsernameController, ProfilepictureController, LogoutController

urlpatterns = [
    path('login/', LoginController.login, name='login'),
    path('google-login/', LoginController.google_login, name='google_login'),
    path('register/', RegisterController.register, name='register'),
    path('google-register/', RegisterController.google_register, name='google_register'),
    path('logout/', LogoutController.logout, name='logout'),
    path('forgot-password/', PasswordController.forgot_password, name='forgot_password'),
    path('set-username/', UsernameController.set_username, name='set_username'),
    path('upload-profile-picture/', ProfilepictureController.upload_profile_picture, name='upload_profile_picture')
]
