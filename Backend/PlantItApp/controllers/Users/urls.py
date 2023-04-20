from django.urls import path
from . import UserController


urlpatterns = [
    path('<str:email>/', UserController.get_specific_user),
]
