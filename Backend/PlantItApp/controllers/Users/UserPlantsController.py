from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from datetime import datetime
from django.utils import timezone
from rest_framework.response import Response
from rest_framework.views import APIView

from PlantItApp.models import Plant
from PlantItApp.models import UserPlants as UserPlantsModel
from PlantItApp.serializers import UserPlantsSerializer


class UserPlants(APIView):
    authentication_classes = [TokenAuthentication]

    def get(self, request, email):
        # Get the user.
        user_model = get_user_model()
        user = get_object_or_404(user_model, email=email)
        # Get the plants of the user from the UserPlants model.
        plants = user.user_plants.all()
        # Serialize the plants.
        serializer = UserPlantsSerializer(plants, many=True)
        # Return the plants.
        return Response(data=serializer.data, status=status.HTTP_200_OK)

    def post(self, request, email):
        if request.user.email != email:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        # Get the plant id.
        plant_id = request.data.get('plant_id')
        plant_nickname = request.data.get('plant_nickname' , None)
        if not plant_nickname:
            plant = get_object_or_404(Plant, id=plant_id)
            plant_nickname = plant.latin
        # Get the user.
        user_model = get_user_model()
        user = get_object_or_404(user_model, email=email)
        # Add the plant to the user.
        current_date = datetime.today().strftime('%Y-%m-%d')
        user.user_plants.create(plant_id=plant_id, nickname=plant_nickname, last_watering=current_date)
        # Return created.
        return Response(status=status.HTTP_201_CREATED)

    def delete(self, request, email):
        if request.user.email != email:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        # Get the user_plant id.
        user_plant_id = request.data.get('user_plant_id')
        # Get the user.
        user_plant = get_object_or_404(UserPlantsModel, id=user_plant_id)
        # Remove the plant from the user.
        user_plant.delete()
        # Return no content.
        return Response(status=status.HTTP_204_NO_CONTENT)
