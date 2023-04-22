from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from django.db.models import Q
from django.shortcuts import get_object_or_404
from PlantItApp.serializers import PlantSearchSerializer
from PlantItApp.models import Plant


@api_view(['GET'])
def get_plant_details(request, plant_id):
    plant = get_object_or_404(Plant, id=plant_id)
    serializer = PlantSerializer(plant)
    return Response(data=serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
def search_plants(request, plant_name):
    # get all the plants the latin name contains the plat_name and or the common name contains the plant_name.
    plants = Plant.objects.filter(Q(latin__icontains=plant_name) | Q(common__common__icontains=plant_name)).distinct()
    # If the plant is not found, returns 404 Not Found.
    if not plants:
        return Response(status=status.HTTP_404_NOT_FOUND)
    serializer = PlantSearchSerializer(plants, many=True)
    return Response(data=serializer.data, status=status.HTTP_200_OK)
