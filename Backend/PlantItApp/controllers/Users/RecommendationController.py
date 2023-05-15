from django.contrib.auth import get_user_model
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
import pandas as pd


def user_plants_list(user):
    # Fetch the plants for this user
    user_plants = user.user_plants.all()

    # Return the plant IDs
    return [user_plant.plant_id for user_plant in user_plants]


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_recommendation(request, email):
    # Make sure the user is authenticated and is the same as the one in the request.
    user = request.user
    if user.is_anonymous or user.email != email:
        return Response(status=status.HTTP_401_UNAUTHORIZED)
    similarity_df = settings.SIMILARITY_DF

    # Initialize a series to hold the sum of similarity scores
    similarity_scores = pd.Series(0, index=similarity_df.index)

    user_plants = user_plants_list(user)

    for plant in user_plants:
        # Add the similarity score of each of the user's plants
        similarity_scores += similarity_df[str(plant)]

    # Sort the scores in descending order
    similarity_scores = similarity_scores.sort_values(ascending=False)

    # Remove plants the user already has
    recommended_plants = similarity_scores.drop(user_plants)
    return Response(recommended_plants.index[:3], status=status.HTTP_200_OK)

