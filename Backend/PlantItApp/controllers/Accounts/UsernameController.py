from django.template.loader import render_to_string
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.contrib.auth import get_user_model


@api_view(['Post'])
def set_username(request):
    # Gets the parameters from the request.
    email = request.data.get('email', None)
    username = request.data.get('username', None)
    User = get_user_model()
    # If one of the parameters wasn't included it returns 400.
    if email is None or username is None:
        return Response({'error': 'Please provide both email and username'}, status=status.HTTP_400_BAD_REQUEST)
    try:
        # Checks if the username already exists and returns 409 if it does.
        User.objects.get(username=username)
        return Response("Username already exists", status=status.HTTP_409_CONFLICT)
    except User.DoesNotExist:
        # If the username doesn't exist it checks if the user email exists.
        try:
            user = User.objects.get(email=email)
            # If it does it save the username.
            user.username = username
            user.save()
        # If the user doesn't exist returns 404
        except User.DoesNotExist:
            return Response("User doesn't exist.", status=status.HTTP_404_NOT_FOUND)
    # Sets the email parameters.
    subject = "Welcome to Plant-It-App"
    email_template_name = "registration_email.txt"
    c = {
        "username": username,
    }
    # Renders the email to a string and sends it to the user email.
    message = render_to_string(email_template_name, c)
    send_mail(subject, message, 'idoddii@gmail.com', [email], fail_silently=False)
    return Response(status=status.HTTP_200_OK)
