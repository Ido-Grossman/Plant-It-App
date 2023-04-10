from google.oauth2 import id_token
from google.auth.transport import requests
from django.conf import settings
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.contrib.auth import get_user_model


@api_view(['Post'])
def authenticate_user(request):
    access_token = request.data.get('access_token', None)
    if not access_token:
        return Response({'error': 'Please provide access_token'}, status=status.HTTP_400_BAD_REQUEST)
    try:
        # Verify the access token and get the user's Google ID and email
        idinfo = id_token.verify_firebase_token(access_token, requests.Request(), 'plant-it-app-5c251')
        user_email = idinfo['email']
        first_name = idinfo.get('given_name')
        last_name = idinfo.get('family_name')


        # Authenticate the user using the Google ID or email
        try:
            User.objects.get(email=user_email)
        except User.DoesNotExist:
            User.objects.create_user(email=user_email, first_name=first_name, last_name=last_name)
        # Authenticate the user and log them in
        user = authenticate(request, username=email, password=None)
        if user is not None:
            login(request, user)
            return Response("User logged in.", status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)

    except ValueError:
        return Response(status=status.HTTP_400_BAD_REQUEST)
