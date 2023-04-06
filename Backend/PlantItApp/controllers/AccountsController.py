from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import authenticate, login, get_user_model
from rest_framework import status
from django.contrib.auth.models import User
from django.core.mail import send_mail

from ..serializers import UserSerializer


@api_view(['Post'])
def signin(request):
    # Makes sure the user tried to do a post request.
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    email = request.data.get('email')
    password = request.data.get('password')
    if email is None or password is None:
        return Response({'error': 'Please provide both email and password'}, status=status.HTTP_400_BAD_REQUEST)
    UserModel = get_user_model()
    user = UserModel.objects.get(email=email)
    username = user.username
    user = authenticate(request._request, username=username, password=password)
    # If they are correct login the user and return 200, else return 401.
    if user is not None:
        login(request._request, user)
        return Response("User logged in.", status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['Post'])
def register(request):
    # Makes sure the user tried to do a post request.
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    serializer = UserSerializer(data=request.data, context={'require_username': True})
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    User.objects.create_user(email, password)
    return Response(status=status.HTTP_201_CREATED)


@api_view(['Get'])
def set_username(request):
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    username = request.data.get('username')
    if not username:
        return Response(status=status.HTTP_400_BAD_REQUEST)
    email = request.data.get('email')
    if not username:
        return Response(status=status.HTTP_400_BAD_REQUEST)
    user = User.objects.get(email=email)
    if not user:
        return Response("User doesn't exist.", status=status.HTTP_404_NOT_FOUND)
    user.email = email
    subject = "Welcome to Plant-It-App"
    email_template_name = "registration_email.txt"
    c = {
        "username": username,
    }
    # Renders the email to a string and sends it to the user email.
    message = render_to_string(email_template_name, c)
    send_mail(subject, message, 'idoddii@gmail.com', [email], fail_silently=False)
    return Response(status=status.HTTP_200_OK)



@api_view(['Post'])
def forgot_password(request):
    # Makes sure the user tried to do a post request.
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    # Tries to get the username from the post request, or returns 400 if it doesn't exist.
    email = request.data.get('email', None)
    if not email:
        return Response("No email parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    # Returns the user from the DB or returns 404 if the user doesn't exist.
    user = get_object_or_404(User, email=email)
    # Defines the email parameters.
    subject = "Password Reset Requested"
    email_template_name = "password_reset_email.txt"
    c = {
        "email": user.email,
        "username": user.username,
        'domain': '127.0.0.1:8000',
        'site_name': 'Plant-It-App',
        "uid": urlsafe_base64_encode(force_bytes(user.pk)),
        'token': default_token_generator.make_token(user),
        'protocol': 'http',
    }
    # Renders the email to a string and sends it to the user email.
    message = render_to_string(email_template_name, c)
    send_mail(subject, message, 'idoddii@gmail.com', [email], fail_silently=False)
    return Response()
