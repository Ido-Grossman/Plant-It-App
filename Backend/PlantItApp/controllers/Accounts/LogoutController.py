from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from django.contrib.auth import logout as django_logout
from rest_framework.authtoken.models import Token
from rest_framework.response import Response


@api_view(['Post'])
@authentication_classes([TokenAuthentication])
def logout(request):
    # Delete the user's token
    Token.objects.get(user=request.user).delete()
    # Log out the user
    django_logout(request)
    return Response()
