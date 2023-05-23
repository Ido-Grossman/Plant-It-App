from datetime import datetime
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes
from django.contrib.auth import get_user_model
from rest_framework.response import Response


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
def update_watering(request, email):
    # get the date from the request.
    date_str = request.data.get('date')
    plant_id = request.data.get('plant_id')
    # if the date is not there, return a bad request.
    if not date_str or not plant_id:
        return Response(status=status.HTTP_400_BAD_REQUEST)
    # parse the date.
    date = datetime.strptime(date_str, '%Y-%m-%d')
    # if the user is not the same as the one in the request, return an unauthorized.
    if request.user.email != email:
        return Response(status=status.HTTP_401_UNAUTHORIZED)
    # get the user and update the last_watering field.
    user_model = get_user_model()
    user = get_object_or_404(user_model, email=email)
    user_plant = get_object_or_404(user.user_plants, plant_id=plant_id)
    user_plant.last_watering = date
    user_plant.save()
    return Response(status=status.HTTP_200_OK)
