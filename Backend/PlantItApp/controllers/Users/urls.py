from django.urls import path
from . import UserController, UserPlantsController, RecommendationController


urlpatterns = [
    path('<str:email>/', UserController.get_specific_user),
    path('<str:email>/plants/', UserPlantsController.UserPlants.as_view()),
    path('<str:email>/recommendation/', RecommendationController.get_recommendation),
]
