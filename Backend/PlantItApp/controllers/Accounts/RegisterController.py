from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from PlantItApp.serializers import UserSerializer
from django.contrib.auth.models import User


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
    User.objects.create_user(email, password)
    # Returns 201 Created.
    return Response(status=status.HTTP_201_CREATED)
