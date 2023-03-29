from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth import authenticate, login
from rest_framework import status
from django.contrib.auth.models import User
from django.core.mail import send_mail


@api_view(['Post'])
def login(request):
    # Makes sure the user tried to do a post request.
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    # Get the username and password from the post request, or return 400 if one of them is not present.
    user_name = request.data.get('username', None)
    if not user_name:
        return Response("No username parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    password = request.data.get('password', None)
    if not password:
        return Response("No password parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    # Check if the username and password are correct.
    user = authenticate(request, username=user_name, password=password)
    # If they are correct login the user and return 200, else return 401.
    if user is not None:
        login(request, user)
        return Response("User logged in.", status=status.HTTP_200_OK)
    else:
        return Response("The username or password are incorrect.", status=status.HTTP_401_UNAUTHORIZED)


@api_view(['Post'])
def register(request):
    # Makes sure the user tried to do a post request.
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    # Get the username and password from the post request, or return 400 if one of them is not present.
    email = request.data.get('email', None)
    if not email:
        return Response("No email parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    user_name = request.data.get('username', None)
    if not user_name:
        return Response("No username parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    password = request.data.get('password', None)
    if not password:
        return Response("No password parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    # Create the user in the DB.
    User.objects.create_user(user_name, email, password)
    subject = "Welcome to Plant-It-App"
    email_template_name = "registration_email.txt"
    c = {
        "username": user_name,
    }
    # Renders the email to a string and sends it to the user email.
    message = render_to_string(email_template_name, c)
    send_mail(subject, message, 'idoddii@gmail.com', [email], fail_silently=False)
    return Response(status=status.HTTP_201_CREATED)


@api_view(['Post'])
def forgot_password(request):
    # Makes sure the user tried to do a post request.
    if request.method != "POST":
        return Response(status=status.HTTP_405_METHOD_NOT_ALLOWED)
    # Tries to get the username from the post request, or returns 400 if it doesn't exist.
    user_name = request.data.get('username', None)
    if not user_name:
        return Response("No username parameter was sent.", status=status.HTTP_400_BAD_REQUEST)
    # Returns the user from the DB or returns 404 if the user doesn't exist.
    user = get_object_or_404(User, username=user_name)
    # Defines the email parameters.
    subject = "Password Reset Requested"
    email_template_name = "password_reset_email.txt"
    c = {
        "email": user.email,
        "username": user_name,
        'domain': '127.0.0.1:8000',
        'site_name': 'Plant-It-App',
        "uid": urlsafe_base64_encode(force_bytes(user.pk)),
        'token': default_token_generator.make_token(user),
        'protocol': 'http',
    }
    # Renders the email to a string and sends it to the user email.
    email = render_to_string(email_template_name, c)
    send_mail(subject, email, 'idoddii@gmail.com', [user.email], fail_silently=False)
    return Response()

