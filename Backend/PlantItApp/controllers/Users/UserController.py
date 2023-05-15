from rest_framework.response import Response
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from django.shortcuts import get_object_or_404
from PlantItApp.serializers import UserProfileSerializer
from django.contrib.auth import get_user_model
from rest_framework import status


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_specific_user(request, email):
    # Get the user.
    user_model = get_user_model()
    user = get_object_or_404(user_model, email=email)
    # Serialize the user.
    serializer = UserProfileSerializer(user)
    # Return the user.
    return Response(data=serializer.data, status=status.HTTP_200_OK)
