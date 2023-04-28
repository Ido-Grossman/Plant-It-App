from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.response import Response
from rest_framework import status
from PlantItApp.models import Plant, Use


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_categories(request):
    # Get all the categories from the database.
    categories = Plant.objects.values('category').distinct()
    # Create a list with the categories.
    categories_list = []
    for category in categories:
        categories_list.append(category['category'])
    # Return the list.
    return Response(data=categories_list, status=status.HTTP_200_OK)


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_climates(request):
    # Get all the climates from the database.
    climates = Plant.objects.values('climate').distinct()
    # Create a list with the climates.
    climates_list = []
    for climate in climates:
        climates_list.append(climate['climate'])
    # Return the list.
    return Response(data=climates_list, status=status.HTTP_200_OK)


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_uses(request):
    # Get all the uses from the database.
    uses = Use.objects.values('use')
    # Create a list with the uses.
    uses_list = []
    for use in uses:
        uses_list.append(use['use'])
    # Return the list.
    return Response(data=uses_list, status=status.HTTP_200_OK)
