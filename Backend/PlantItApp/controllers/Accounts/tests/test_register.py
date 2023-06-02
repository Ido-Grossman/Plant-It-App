from django.test import TestCase
from django.contrib.auth import get_user_model
from rest_framework.test import APIClient
from django.urls import reverse


# unit test
class UserModelTest(TestCase):
    def test_create_user(self):
        User = get_user_model()
        user = User.objects.create_user('test@test.com', 'password123')
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(user.email, 'test@test.com')


# integration test
class RegisterViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_register(self):
        data = {
            'email': 'test@test.com',
            'password': 'password123'
        }
        response = self.client.post(reverse('register'), data)
        self.assertEqual(response.status_code, 201)


# api test
class GoogleRegisterViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_google_register(self):
        data = {
            'email': 'test@test.com',
            'password': 'password123',
            'uid': '123456789'
        }
        response = self.client.post(reverse('google_register'), data)
        self.assertEqual(response.status_code, 201)
