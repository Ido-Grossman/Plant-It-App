from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.response import Response

from PlantItApp.models import UserPlants, Disease


@api_view(['PUT'])
@authentication_classes([TokenAuthentication])
def set_disease(request, user_plant_id):
    # Check if the user is authenticated.
    if not request.user.is_authenticated:
        return Response('User not authenticated', status=status.HTTP_401_UNAUTHORIZED)
    # Check if the user provided a disease name.
    disease_name = request.data.get('disease')
    if not disease_name:
        return Response('No disease name provided', status=status.HTTP_400_BAD_REQUEST)
    # Check if the user has a plant with the given id.
    user_plant = get_object_or_404(UserPlants, pk=user_plant_id)
    # Check if the user has permission to edit the plant.
    if user_plant.user != request.user:
        return Response('User does not have permission to edit this plant', status=status.HTTP_401_UNAUTHORIZED)
    # Check if the disease exists.
    disease = get_object_or_404(Disease, disease=disease_name)
    # Set the disease
    user_plant.disease = disease
    user_plant.save()
    # Return a success message.
    return Response('Disease set', status=status.HTTP_200_OK)
