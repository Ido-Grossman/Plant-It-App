from django.contrib.auth import get_user_model
from django.test import TestCase, RequestFactory

from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient
from rest_framework import status
from ....models import Plant



class GetPlantDetailsTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = get_user_model().objects.create_user(
            email='testuser@example.com',
            password='testpass',
            username='testuser'
        )
        self.token, _ = Token.objects.get_or_create(user=self.user)
        self.client = APIClient()
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.plant = Plant.objects.create(
            latin='testplant',
            family='testfamily',
            category='testcategory',
            origin='testorigin',
            climate='testclimate',
            toleratedlight='testtoleratedlight',
            idealight='testidealight',
            watering='testwatering',
            water_duration=7,
            mincelsius=10,
            maxcelsius=30,
            minfahrenheit=50,
            maxfahrenheit=86,
            plant_photo='plant_photos/test.jpg',
        )


    def test_get_plant_details_valid_id(self):
        response = self.client.get(f'/api/plants/{self.plant.id}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_get_plant_details_invalid_id(self):
        response = self.client.get('/9999/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)


class SearchPlantsTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = get_user_model().objects.create_user(
            email='testuser@example.com',
            password='testpass',
            username='testuser'
        )
        self.token, _ = Token.objects.get_or_create(user=self.user)
        self.client = APIClient()
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.plant = Plant.objects.create(
            latin='testplant',
            family='testfamily',
            category='testcategory',
            origin='testorigin',
            climate='testclimate',
            toleratedlight='testtoleratedlight',
            idealight='testidealight',
            watering='testwatering',
            water_duration=7,
            mincelsius=10,
            maxcelsius=30,
            minfahrenheit=50,
            maxfahrenheit=86,
            plant_photo='plant_photos/test.jpg',
        )

    def test_search_plants_valid_name(self):
        response = self.client.get('/api/plants/search/testplant/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_search_plants_invalid_name(self):
        response = self.client.get('/api/plants/search/hey/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
