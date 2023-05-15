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

    # Fetch all plants with their associated 'uses'
    plants = Plant.objects.prefetch_related(
        Prefetch('use', queryset=Use.objects.all(), to_attr='plant_uses')
    )

    # Create a DataFrame with 'id', 'latin', 'category', 'climate', 'family'
    plant_df = pd.DataFrame.from_records(plants.values('id', 'latin', 'category', 'climate', 'family'))

    # Create a DataFrame with 'id' and 'use' (as a list of uses per plant)
    use_df = pd.DataFrame.from_records([
        {'id': plant.id, 'use': [use.use for use in plant.plant_uses]}
        for plant in plants
    ])

    # One-hot encode the 'use' categories
    use_encoder = MultiLabelBinarizer()
    encoded_uses = use_encoder.fit_transform(use_df['use'])
    encoded_uses_df = pd.DataFrame(encoded_uses, columns=use_encoder.classes_)
    encoded_uses_df['id'] = use_df['id']

    # Merge the one-hot encoded 'use' categories with the plant DataFrame
    df = plant_df.merge(encoded_uses_df, on='id', how='left')

    # Specify categorical features
    categorical_features = ['category', 'climate', 'family']

    # One-hot encode categorical variables
    encoder = OneHotEncoder(sparse=False)
    encoded_features = pd.DataFrame(encoder.fit_transform(df[categorical_features]))

    # Combine encoded and continuous features
    df_prepared = pd.concat([df.drop(categorical_features, axis=1), encoded_features], axis=1)

    # Compute similarity matrix and save it as an attribute
    similarity_matrix = cosine_similarity(df_prepared.drop('id', axis=1))
    similarity_df = pd.DataFrame(similarity_matrix, index=df['id'], columns=df['id'])

    # Save the DataFrame to a CSV file or other storage
    similarity_df.to_csv('similarity_matrix.csv')

    return Response(status=status.HTTP_200_OK)

