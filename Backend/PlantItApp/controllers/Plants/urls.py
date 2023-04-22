from django.urls import path, re_path
from . import PlantController


urlpatterns = [
    path('<int:plant_id>/', PlantController.get_plant_details, name='get_specific_plant'),
    re_path(r'^search/(?P<plant_name>[\w\-]*)/$', PlantController.search_plants, name='search_plants')
]
