import torch
from django.apps import AppConfig
from django.conf import settings
import os


class PlantitappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'PlantItApp'

    def ready(self):
        path = os.path.join(".", 'PlantItApp', 'plant-disease-model.pth')
        settings.MODEL.load_state_dict(torch.load(path, map_location=torch.device("cpu")))
        settings.MODEL.eval()
