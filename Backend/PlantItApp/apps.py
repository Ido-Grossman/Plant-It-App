import torch
from django.apps import AppConfig
from django.conf import settings


class PlantitappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'PlantItApp'

    def ready(self):
        settings.MODEL.load_state_dict(torch.load("C:\\Users\\idodd\\PycharmProjects\\Plant-It-App\\Backend"
                                                  "\\PlantItApp\\plant-disease-model.pth", map_location=torch.device(
                                                    "cpu")))
        settings.MODEL.eval()
