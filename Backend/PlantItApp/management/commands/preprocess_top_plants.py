# myapp/management/commands/preprocess_top_plants.py
import os

from django.core.management.base import BaseCommand
from django.db.models import Prefetch

from PlantItApp.models import UserPlants
from sklearn.preprocessing import OneHotEncoder, MultiLabelBinarizer
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from django.conf import settings


class Command(BaseCommand):
    help = 'Preprocess data for recommendation system'

    def handle(self, *args, **options):
        # Fetch all the user plants.
        user_plants = UserPlants.objects.all()

        # Create a list of plant IDs and amount of this specific plant.
        plants_amount = {}
        for user_plant in user_plants:
            if user_plant.plant_id in plants_amount:
                plants_amount[user_plant.plant_id] += 1
            else:
                plants_amount[user_plant.plant_id] = 1

        # transform the dictionary into a sorted list by amount of plants, descending and save only the ids.
        plants_amount = sorted(plants_amount.items(), key=lambda x: x[1], reverse=True)
        top_plants = [x[0] for x in plants_amount]

        # Export the top plants to a csv file.
        plant_df = pd.DataFrame(top_plants, columns=['id'])

        path = settings.TOP_PLANTS_PATH

        # Save the DataFrame to a CSV file or other storage
        plant_df.to_csv(path)
