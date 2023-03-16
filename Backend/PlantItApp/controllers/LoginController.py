from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import authenticate, login
from rest_framework import status


@api_view(['Post'])
def Login(request):
    user_name = request.data['username']
    password = request.data['password']
    user = authenticate(request, username=user_name, password=password)
    if user is not None:
        login(request, user)
        return Response(status=status.HTTP_200_OK)
    else:
        return Response(status=status.HTTP_404_NOT_FOUND)