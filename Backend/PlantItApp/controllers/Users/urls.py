from django.urls import path
from . import UserController, PlantsController


urlpatterns = [
    path('<str:email>/', UserController.get_specific_user),
    path('<str:email>/plants/', PlantsController.UserPlants.as_view()),
]
