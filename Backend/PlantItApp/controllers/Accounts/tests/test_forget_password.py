from django.test import TestCase, RequestFactory
from django.urls import reverse
from rest_framework.test import APITestCase, APIClient

from ....backends import CustomUser
from ..PasswordController import forgot_password

class PasswordUnitTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()
        self.user = CustomUser.objects.create_user(email='test@example.com', password='password123')

    def test_forgot_password(self):
        request = self.factory.post('/api/accounts/forgot-password/', {'email': 'test@example.com'})

        response = forgot_password(request)

        self.assertEqual(response.status_code, 200)

class PasswordAPITest(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = CustomUser.objects.create_user(email='test@example.com', password='password123')

    def test_forgot_password_api(self):
        data = {'email': 'test@example.com'}
        response = self.client.post(reverse('forgot_password'), data)

        self.assertEqual(response.status_code, 200)
