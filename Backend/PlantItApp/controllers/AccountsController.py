from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import authenticate, login
from rest_framework import status
from django.core.mail import send_mail
from django.contrib.auth import get_user_model

from ..serializers import UserSerializer


@api_view(['Post'])
def signin(request):
    # Makes sure the user tried to do a post request.
    email = request.data.get('email')
    password = request.data.get('password')
    if email is None or password is None:
        return Response({'error': 'Please provide both email and password'}, status=status.HTTP_400_BAD_REQUEST)
    user = authenticate(request._request, email=email, password=password)
    # If they are correct login the user and return 200, else return 401.
    if user is not None:
        login(request._request, user)
        return Response("User logged in.", status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['Post'])
def signin_google(request):
    # Makes sure the user tried to do a post request.
    email = request.data.get('email', None)
    uid = request.data.get('uid', None)
    if email is None or uid is None:
        return Response({'error': 'Please provide both email and uid'}, status=status.HTTP_400_BAD_REQUEST)
    user = authenticate(request._request, email=email, uid=uid)
    # If they are correct login the user and return 200, else return 401.
    if user is not None:
        login(request._request, user)
        return Response("User logged in.", status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['Post'])
def register(request):
    # Makes sure the user tried to do a post request.
    serializer = UserSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    User = get_user_model()
    User.objects.create_user(email, password)
    return Response(status=status.HTTP_201_CREATED)


@api_view(['Post'])
def register_google(request):
    # Makes sure the user tried to do a post request.
    serializer = UserSerializer(data=request.data, context={'require_uid': True})
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    uid = serializer.validated_data['uid']
    User = get_user_model()
    User.objects.create_user(email, uid=uid, password=password)
    return Response(status=status.HTTP_201_CREATED)


@api_view(['Post'])
def set_username(request):
    email = request.data.get('email')
    username = request.data.get('username')
    User = get_user_model()
    if email is None or username is None:
        return Response({'error': 'Please provide both email and username'}, status=status.HTTP_400_BAD_REQUEST)
    try:
        User.objects.get(username=username)
        return Response("Username already exists", status=status.HTTP_409_CONFLICT)
    except User.DoesNotExist:
        try:
            user = User.objects.get(email=email)
            user.username = username
            user.save()
        except User.DoesNotExist:
            return Response("User doesn't exist.", status=status.HTTP_404_NOT_FOUND)
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
    # Tries to get the username from the post request, or returns 400 if it doesn't exist.
    email = request.data.get('email', None)
    if not email:
        return Response("No email parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    # Returns the user from the DB or returns 404 if the user doesn't exist.
    User = get_user_model()
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
