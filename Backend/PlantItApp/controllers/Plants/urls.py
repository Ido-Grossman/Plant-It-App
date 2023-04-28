from django.urls import path
from . import PlantController, FiltersGetController


urlpatterns = [
    path('<int:plant_id>/', PlantController.get_plant_details, name='get_specific_plant'),
    path('search/<str:plant_name>/', PlantController.search_plants, name='search_plants'),
    path('search//', PlantController.search_plants, name='search_plants'),
    path('categories/', FiltersGetController.get_categories, name='categories'),
    path('uses/', FiltersGetController.get_uses, name='uses'),
    path('climates/', FiltersGetController.get_climates, name='climates'),
]

