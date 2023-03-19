from rest_framework.decorators import api_view
import base64
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import PhotoSerializer
from django.core.files.base import ContentFile


@api_view(['Post'])
def Register(request):
    user_name = request.data['username']
    password = request.data['password']
    email = request.data['email']
    user = User.objects.create_user(user_name, email, password)
    return Response(status=status.HTTP_201_CREATED)


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


def save_base64_as_image(data, filename):
    format, imgstr = data.split(';base64,')
    ext = format.split('/')[-1]
    data = ContentFile(base64.b64decode(imgstr), name=filename + '.' + ext)
    return data


class PhotoUploadView(APIView):
    @api_view(['POST'])
    def post(self, request):
        serializer = PhotoSerializer(data=request.data)
        if serializer.is_valid():
            image_data = serializer.validated_data['image']
            # save the image to a directory on the server
            image_file = save_base64_as_image(image_data, 'myimage')
            # do something with the saved image file
            return Response({'message': 'Photo uploaded successfully.'})
        else:
            return Response(serializer.errors, status=400)

