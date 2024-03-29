from django.contrib.auth import get_user_model
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from datetime import datetime
from rest_framework.response import Response
from rest_framework.views import APIView

from PlantItApp.models import Plant, Disease
from PlantItApp.models import UserPlants as UserPlantsModel
from PlantItApp.serializers import UserPlantsSerializer


class UserPlants(APIView):
    authentication_classes = [TokenAuthentication]

    def get(self, request, email):
        # Check if the user is anonymous or if the user is not the same as the email.
        if request.user.is_anonymous or request.user.email != email:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
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
        # Check if the user is anonymous or if the user is not the same as the email.
        if request.user.is_anonymous or request.user.email != email:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        # Get the plant id.
        plant_id = request.data.get('plant_id')
        plant_nickname = request.data.get('plant_nickname', None)
        if not plant_nickname:
            plant = get_object_or_404(Plant, id=plant_id)
            plant_nickname = plant.latin
        # Get the user.
        user_model = get_user_model()
        user = get_object_or_404(user_model, email=email)
        # Get the unknown disease entry.
        disease = Disease.objects.get(disease='Unknown')
        # Add the plant to the user.
        current_date = datetime.today().strftime('%Y-%m-%d')
        # Check if the user already has a plant with this nickname.
        plant = user.user_plants.filter(nickname=plant_nickname).first()
        if plant:
            return Response(status=status.HTTP_409_CONFLICT)
        user.user_plants.create(plant_id=plant_id, nickname=plant_nickname, last_watering=current_date, disease=disease)
        # Return created.
        return Response(status=status.HTTP_201_CREATED)

    def delete(self, request, email):
        # Check if the user is anonymous or if the user is not the same as the email.
        if request.user.is_anonymous or request.user.email != email:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        # Get the user_plant id.
        user_plant_id = request.data.get('user_plant_id')
        # Get the user.
        user_plant = get_object_or_404(UserPlantsModel, id=user_plant_id)
        # Remove the plant from the user.
        user_plant.delete()
        # Return no content.
        return Response(status=status.HTTP_204_NO_CONTENT)
