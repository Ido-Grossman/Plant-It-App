from django.urls import path
from . import PlantController


urlpatterns = [
    path('<int:plant_id>/', PlantController.get_plant_details, name='get_specific_plant'),
    path('<str:plant_name>/', PlantController.search_plants, name='get_plants'),
]
