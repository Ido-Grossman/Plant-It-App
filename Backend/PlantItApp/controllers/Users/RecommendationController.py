from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from PlantItApp.models import Use, Plant
import pandas as pd
from sklearn.preprocessing import OneHotEncoder
from sklearn.metrics.pairwise import cosine_similarity

from django.db.models import Prefetch
from sklearn.preprocessing import MultiLabelBinarizer


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_recommendation(request, email):
    user = request.user
    if user.email != email:
        return Response(status=status.HTTP_401_UNAUTHORIZED)

    return Response(status=status.HTTP_200_OK)

