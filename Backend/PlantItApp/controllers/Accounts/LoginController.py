from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import authenticate, login
from rest_framework import status


@api_view(['Post'])
def signin(request):
    # Gets the email and password from the request.
    email = request.data.get('email', None)
    password = request.data.get('password', None)
    # If one of the parameters weren't sent returns 400 Bad request.
    if email is None or password is None:
        return Response({'error': 'Please provide both email and password'}, status=status.HTTP_400_BAD_REQUEST)
    # Makes sure the email and password are correct.
    user = authenticate(request._request, email=email, password=password)
    # If they are correct login the user and return 200, else return 401.
    if user is not None:
        login(request._request, user)
        return Response("User logged in.", status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['Post'])
def signin_google(request):
    # Gets the email and uid from the request.
    email = request.data.get('email', None)
    uid = request.data.get('uid', None)
    # If one of the parameters weren't sent returns 400 Bad request.
    if email is None or uid is None:
        return Response({'error': 'Please provide both email and uid'}, status=status.HTTP_400_BAD_REQUEST)
    # Makes sure the email and uid are correct.
    user = authenticate(request._request, email=email, uid=uid)
    # If they are correct login the user and return 200, else return 401.
    if user is not None:
        login(request._request, user)
        return Response("User logged in.", status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)
