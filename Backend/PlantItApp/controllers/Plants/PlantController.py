from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from django.shortcuts import get_object_or_404
from PlantItApp.serializers import PlantSerializer
from PlantItApp.models import Plant


@api_view(['GET'])
def get_plant_details(request, plant_id):
    plant = get_object_or_404(Plant, id=plant_id)
    serializer = PlantSerializer(plant, context={'request': request})
    return Response(data=serializer.data, status=status.HTTP_200_OK)
