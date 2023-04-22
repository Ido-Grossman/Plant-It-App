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
    category = request.GET.get('category')
    climate = request.GET.get('climate')
    use = request.GET.get('use')
    celsiusmin = request.GET.get('celsiusmin')
    celsiusmax = request.GET.get('celsiusmax')
    # Make the initial search by the plant name.
    plants = Plant.objects.all()
    plants = Plant.objects.filter(Q(latin__icontains=plant_name) | Q(common__common__icontains=plant_name)).distinct()
    # If the plant is not found, returns 404 Not Found.
    if not plants:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # if one at least one of the parameters is not None, filter the plants by the parameters.
    if category or climate or use or celsiusmin or celsiusmax:
        if category:
            plants = plants.filter(category__icontains=category)
        if climate:
            plants = plants.filter(climate__icontains=climate)
        if use:
            plants = plants.filter(use__use__icontains=use)
        if celsiusmin is not None and celsiusmax is not None:
            plants = plants.filter(Q(mincelsius__lte=celsiusmax) & Q(maxcelsius__gte=celsiusmin))
    serializer = PlantSearchSerializer(plants, many=True)
    return Response(data=serializer.data, status=status.HTTP_200_OK)
