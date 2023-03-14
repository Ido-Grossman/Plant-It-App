from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth.models import User
from rest_framework import status


@api_view(['Post'])
def Register(request):
    user_name = request.data['username']
    password = request.data['password']
    email = request.data['email']
    user = User.objects.create_user(user_name, email, password)
    return Response(status=status.HTTP_201_CREATED)
