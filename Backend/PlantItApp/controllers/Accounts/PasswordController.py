from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.contrib.auth import get_user_model


@api_view(['Post'])
def forgot_password(request):
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
        'domain': 'https://plant-it-app-384117.lm.r.appspot.com/',
        'site_name': 'Plant-It-App',
        "uid": urlsafe_base64_encode(force_bytes(user.pk)),
        'token': default_token_generator.make_token(user),
        'protocol': 'http',
    }
    # Renders the email to a string and sends it to the user email.
    message = render_to_string(email_template_name, c)
    send_mail(subject, message, 'idoddii@gmail.com', [email], fail_silently=False)
    return Response()
