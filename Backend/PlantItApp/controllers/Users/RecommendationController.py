from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
import pandas as pd
from PlantItApp.serializers import PlantSerializer
from PlantItApp.models import Plant


def user_plants_list(user):
    # Fetch the plants for this user
    user_plants = user.user_plants.all()

    # Return the plant IDs
    return [user_plant.plant_id for user_plant in user_plants]


def get_similarity_scores(user_plants, similarity_df):
    # Initialize a series to hold the sum of similarity scores
    similarity_scores = pd.Series(0, index=similarity_df.index)
    for plant in user_plants:
        # Add the similarity score of each of the user's plants
        similarity_scores += similarity_df[str(plant)]
    return similarity_scores


def recommendations(user):
    user_plants = user_plants_list(user)
    user_posts = user.posts.all()

    if user_plants:
        similarity_df = settings.SIMILARITY_DF
        similarity_scores = get_similarity_scores(user_plants, similarity_df)

        # Adjust the similarity scores based on the sentiment of the user's posts.
        # similarity_scores = update_similarity_by_sentiment(user_posts, similarity_scores, similarity_df)

        # Sort the scores in descending order
        similarity_scores = similarity_scores.sort_values(ascending=False)

        # Remove plants the user already has
        recommended_plants = similarity_scores.drop(user_plants)
    else:
        top_plants = settings.TOP_PLANTS_DF

        # Set the index to the plant ID.
        recommended_plants = pd.Series(top_plants.index, index=top_plants['id'])
    return recommended_plants.index[:settings.RECOMMENDATIONS_AMOUNT]


@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_recommendation(request, email):
    # Make sure the user is authenticated and is the same as the one in the request.
    user = request.user
    if user.is_anonymous or user.email != email:
        return Response(status=status.HTTP_401_UNAUTHORIZED)
    # Get the recommendations for this user
    recommended_plants_id = recommendations(user)
    recommended_plants = Plant.objects.filter(id__in=recommended_plants_id)
    # Change the user_id to the username
    serializer = PlantSerializer(recommended_plants, many=True)
    return Response(data=serializer.data, status=status.HTTP_200_OK)

