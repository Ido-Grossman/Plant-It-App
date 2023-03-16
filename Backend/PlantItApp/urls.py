from django.urls import path
from controllers import LoginController, RegisterController

urlpatterns = [
    path('register/', RegisterController.Register),
    path('login/', LoginController.Login)
]
