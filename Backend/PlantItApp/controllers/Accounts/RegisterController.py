from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model
from PlantItApp.serializers import UserSerializer


@api_view(['Post'])
def register(request):
    # Getting the userSerializer and validated the data.
    serializer = UserSerializer(data=request.data)
    # If the data is incorrect, returns 400 Bad Request.
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    # Get the user email and password.
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    # Get the correct user model from django and creates the user from email and password.
    User = get_user_model()
    User.objects.create_user(email, password)
    # Returns 201 Created.
    return Response(status=status.HTTP_201_CREATED)


@api_view(['Post'])
def google_register(request):
    # Getting the userSerializer and validated the data.
    serializer = UserSerializer(data=request.data, context={'require_uid': True})
    # If the data is incorrect, returns 400 Bad Request.
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    # Get the user email, password and uid.
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    uid = serializer.validated_data['uid']
    # Get the correct user model from django and creates the user from email, password and uid.
    User = get_user_model()
    User.objects.create_user(email, uid=uid, password=password)
    # Returns 201 Created.
    return Response(status=status.HTTP_201_CREATED)
