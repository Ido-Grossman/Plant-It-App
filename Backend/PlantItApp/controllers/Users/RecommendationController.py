from rest_framework.decorators import api_view, authentication_classes
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
import pandas as pd

# from google.cloud import language_v1
# def analyze_sentiment(text):
#     client = language_v1.LanguageServiceClient()
#
#     # The text to analyze
#     document = language_v1.Document(content=text, type_=language_v1.Document.Type.PLAIN_TEXT)
#
#     # Detects the sentiment of the text
#     sentiment = client.analyze_sentiment(request={'document': document}).document_sentiment
#
#     return sentiment.score


# def generate_sentiment_dictionary(user_posts):
#     # Initialize a dictionary to hold the sum of sentiment scores
#     sentiment_scores = {}
#     for post in user_posts:
#         # Add the sentiment score of each of the user's posts to the correct plant.
#         if post.plant.id not in sentiment_scores:
#             sentiment_scores[post.plant.id] = analyze_sentiment(post.content)
#         else:
#             sentiment_scores[post.plant.id] += analyze_sentiment(post.content)
#     return sentiment_scores


# def update_similarity_by_sentiment(user_posts, similarity_scores, similarity_df):
#     # Get the sentiment scores for each plant.
#     sentiment_dictionary = generate_sentiment_dictionary(user_posts)
#
#     for plant, sentiment_score in sentiment_dictionary.items():
#         # Add the sentiment score to the similarity score.
#         plant_similarities = similarity_df[str(plant)]
#
#         # Add the sentiment score to the similarity score.
#         adjusted_similarity_score = plant_similarities * abs(sentiment_score)
#
#         # If the sentiment score is negative, subtract the similarity score.
#         # otherwise, add the similarity score.
#         if sentiment_score < 0:
#             similarity_scores -= adjusted_similarity_score
#         else:
#             similarity_scores += adjusted_similarity_score
#
#     return similarity_scores

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




@api_view(['GET'])
@authentication_classes([TokenAuthentication])
def get_recommendation(request, email):
    # Make sure the user is authenticated and is the same as the one in the request.
    user = request.user
    if user.is_anonymous or user.email != email:
        return Response(status=status.HTTP_401_UNAUTHORIZED)

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
    return Response(recommended_plants.index[:settings.RECOMMENDATIONS_AMOUNT], status=status.HTTP_200_OK)

